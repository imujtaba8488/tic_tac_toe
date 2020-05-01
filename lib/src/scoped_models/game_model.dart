import 'dart:math';

import 'package:scoped_model/scoped_model.dart';

import '../models/cloud.dart';
import '../models/player.dart';
import '../models/score.dart';
import '../models/sound_effect_player.dart';
import '../models/game.dart';

part 'win_lose_logic.dart';
part 'constants.dart';

class GameModel extends Model {
  /// Total number of moves available within the game.
  List<String> _moves;
  _GameStatus _gameStatus = _GameStatus.moves_available;
  _MoveStatus _moveStatus = _MoveStatus.next_move_available;
  _PlayStatus _playStatus = _PlayStatus.active;

  Player player1, player2;
  Turn _turn;

  /// The combination of indexes that resulted in a win.
  List<int> _winKey = [];

  /// Whether to play against the AI or not.
  bool againstAI;

  /// Whether to disable or enable the play sound effects.
  bool disableSoundEffects;

  SoundEffectPlayer _soundEffectPlayer;

  /// Whether the AI is taking it's time to think, before it plays it's turn.
  bool _isAiThinking = false;

  /// The time that the AI should take to play it's turn.
  Duration aiThinkingDelay;

  /// Whether to show or hide the logs.
  bool enableLogs;

  /// Returns the current status of the game. For example, during the course of
  /// time, either of players may won, game may result in a draw, an error might
  /// occur, etc.
  StatusChange statusChange;

  Game _currentGame;

  GameModel(
    this.player1,
    this.player2,
    this._turn, {
    this.againstAI = true,
    this.disableSoundEffects = false,
    this.aiThinkingDelay = const Duration(milliseconds: 500),
    this.enableLogs = false,
  }) {
    _currentGame = Game();

    _soundEffectPlayer = SoundEffectPlayer();

    statusChange = StatusChange.none;

    if (enableLogs) _gameStartUpLogs();
  }

  /// Plays the move at the given index [at].
  void playMove(int at) {
    _checkGameStatus();
    _checkMoveStatus(at);

    if (_gameStatus == _GameStatus.moves_available) {
      if (_playStatus == _PlayStatus.active) {
        if (_moveStatus == _MoveStatus.next_move_available) {
          _turn == Turn.player1 ? _playTurn(at) : _playTurn(at);
        }
      }
    }
  }

  /// Plays the [player] turn at the given position [at].
  void _playTurn(int at) {
    if (_turn == Turn.player1) {
      _moves[at] = player1.mark;
      _currentGame.addPlayer1Move(at);
      if (!disableSoundEffects)
        _soundEffectPlayer.play(
          _currentGame.player1SoundEffect,
        );
    } else {
      _moves[at] = player2.mark;
      _currentGame.addPlayer2Move(at);
      if (!disableSoundEffects)
        _soundEffectPlayer.play(
          _currentGame.player2SoundEffect,
        );
    }

    _checkPlayStatus();

    // Check for draw only if the last move doesn't result in a win.
    if (_playStatus != _PlayStatus.player1_won ||
        _playStatus != _PlayStatus.player2_won) _checkGameStatus();

    // Necessary. Notifies the listeners that a move has been played.
    notifyListeners();

    // Play AI's turn, if playing aganist the AI. Observe the three 'if' checks.
    if (againstAI) if (_turn ==
        Turn.player2) if (_currentGame.movesRemaining.length > 0) _playAiTurn();

    // Observe: How does the AI know that it has to play first, in case the user
    // wins or user causes the draw? Since, in both the cases, it is the user
    // who plays (last / finishes), and after each user play, if it's AI's turn,
    // it is played automatically. *** Also look at the reset() method for this
    // explanation ***
  }

  /// Plays the AI turn.
  void _playAiTurn() {
    _isAiThinking = true;

    Future.delayed(aiThinkingDelay, () {
      _aiPlay();

      _isAiThinking = false;
    });
  }

  /// Checks if any moves are left to play or the game is over.
  void _checkGameStatus() {
    if (_moves.contains('')) {
      _gameStatus = _GameStatus.moves_available;
    } else {
      _gameStatus = _GameStatus.draw;
      _gameStatusChange();
    }
  }

  /// Checks if either of the players has won the game or if it is still on.
  void _checkPlayStatus() {
    if (_hasWon(player1.movesPlayed)) {
      _winKey = _winningCombination(player1.movesPlayed);
      _playStatus = _PlayStatus.player1_won;
      _gameStatusChange();
    } else if (_hasWon(player2.movesPlayed)) {
      _winKey = _winningCombination(player2.movesPlayed);
      _playStatus = _PlayStatus.player2_won;
      _gameStatusChange();
    } else {
      _playStatus = _PlayStatus.active;
    }
  }

  /// Checks if a move can be played at the given position [at].
  void _checkMoveStatus(int at) {
    if (_moves[at].isEmpty) {
      _moveStatus = _MoveStatus.next_move_available;
    } else {
      _moveStatus = _MoveStatus.next_move_unavailable;
      _gameStatusChange();
    }
  }

  /// Flips the turn.
  void _switchTurn() {
    _turn == Turn.player1 ? _turn = Turn.player2 : _turn = Turn.player1;
  }

  /// A very essential method, which describes and controls many factors that
  /// need updated or notified, when there is a change in game status.
  void _gameStatusChange() async {
    if (_gameStatus == _GameStatus.draw) {
      if (!disableSoundEffects) _soundEffectPlayer.play(SoundEffect.draw);
      Score.draws++;
      statusChange = StatusChange.draw;
      notifyListeners();
    } else if (_playStatus == _PlayStatus.player1_won) {
      player1.updateCurrentWin();
      if (!disableSoundEffects) _soundEffectPlayer.play(SoundEffect.win);
      statusChange = StatusChange.player1_won;

      // 'True' indicates that a win needs to be registered on cloud. Await is important here because _updateLifeTimeScore() and notifyListeners() should only run when this is complete.
      await Cloud().sync(player1.name, true);
      _syncScoreWithCloud(player1);
      updatePlayerRank();

      notifyListeners();
    } else if (_playStatus == _PlayStatus.player2_won) {
      player2.updateCurrentWin();
      if (!disableSoundEffects) _soundEffectPlayer.play(SoundEffect.lost);
      statusChange = StatusChange.player2_won;

      // 'False' indicates that a loss needs to be registered on cloud. Await is important here because _updateLifeTimeScore() and notifyListeners() should only run when this is complete.
      await Cloud().sync(player1.name, false);
      _syncScoreWithCloud(player1);
      updatePlayerRank();

      notifyListeners();
    } else if (_moveStatus == _MoveStatus.next_move_unavailable) {
      if (!disableSoundEffects) _soundEffectPlayer.play(SoundEffect.error);
      statusChange = StatusChange.error_next_move_unavailable;
      notifyListeners();
    }
  }

  /// Plays the AI move. AI moves are subjected to many decisions, so that the
  /// AI plays intelligently. Later difficulty level can be set for the AI play.
  void _aiPlay() {
    if (_isWinPossible(player2.movesPlayed, _moves) >= 0) {
      playMove(_isWinPossible(player2.movesPlayed, _moves));
    } else if (_isWinPossible(player1.movesPlayed, _moves) >= 0) {
      playMove(_isWinPossible(player1.movesPlayed, _moves));
    } else {
      _playRandomMove();
    }
  }

  /// Plays a random move from the [movesRemaining] i.e. the remaining moves.
  void _playRandomMove() {
    _currentGame.movesRemaining.shuffle();
    playMove(
      _currentGame.movesRemaining[Random().nextInt(
        _currentGame.movesRemaining.length,
      )],
    );
  }

  /// Resets the game.
  void reset() {
    _currentGame.resetTotalMoves();
    _currentGame.resetPlayer1Moves();
    _currentGame.resetPlayer2Moves();

    _gameStatus = _GameStatus.moves_available;
    _moveStatus = _MoveStatus.next_move_available;
    _playStatus = _PlayStatus.active;

    statusChange = StatusChange.none;

    _winKey.clear();

    // If reset is called within this class, the the following statement is not
    // required. However, if called from outside of this class, the following
    // statement is necessary. At least, that is what I have understood so far.
    // ? Maybe look into this later. Review...
    if (_turn == Turn.player2) _playAiTurn();

    // Stop any SoundEffect from playing. This does not disable SoundEffects,
    // it only stops the current one from playing.
    if (!disableSoundEffects) _soundEffectPlayer.stop();

    notifyListeners();
  }

  void _gameStartUpLogs() {
    print('Sound Effects: ${disableSoundEffects ? 'off' : 'on'}');
    print('AI Play: ${againstAI ? 'on' : 'off'}');
  }

  /// Refreshes and updates local data with cloud data.
  void refreshScores() => _syncScoreWithCloud(player1);

  /// Synchronizes local data with the cloud data.
  void _syncScoreWithCloud(Player player) async {
    // Get user data from the cloud.
    Map<String, dynamic> p = await Cloud().getUser(player.name);

    // Sync local data with the cloud data.
    if (player.name.isNotEmpty) {
      player.lifeTimeScore.wins = p['wins'];
      player.lifeTimeScore.loss = p['lost'];
    }
  }

  Future<Player> getPlayer(String username) async {
    Map<String, dynamic> user = await Cloud().getUser(username);

    Player player = Player();

    player.email = user['email'];
    player.username = user['username'];
    player.password = user['password'];
    player.lifeTimeScore = Score(wins: user['wins'], loss: user['lost']);

    return player;
  }

  Future<List<Player>> get allPlayers async {
    List<Map<String, dynamic>> users = await Cloud().allUsers;

    List<Player> allPlayers = [];

    users.forEach((user) {
      Player player = Player();
      player.email = user['email'];
      player.username = user['username'];
      player.password = user['password'];
      player.lifeTimeScore = Score(wins: user['wins'], loss: user['lost']);
      allPlayers.add(player);
    });

    return allPlayers;
  }

  void updatePlayerRank() async {
    print('inside update player rank.....');

    List<Player> all = await allPlayers;

    all.sort((Player p1, Player p2) {
      return p1.lifeTimeScore.wins.compareTo(p2.lifeTimeScore.wins);
    });

    for (int index = 0; index < all.length; index++) {
      all[index].rank = all.length - index;

      if (all[index].username == player1.username) {
        player1.rank = all[index].rank;
        print('rank: ${player1.rank}');
      }
    }
  }

  // ****************** Getters and Setters  ****************** //

  /// Returns a read-only copy of moves.
  List<String> get moves => List.unmodifiable(_moves);

  /// Returns true or false, depending upon whether the AI is thinking or not.
  bool get isAiThinking => _isAiThinking;

  /// Returns the total number of game draws.
  int get draws => Score.draws;

  /// Returns an unmodifiable list containing indexes which resulted in a win.
  List<int> get winKey => List.unmodifiable(_winKey);
}
