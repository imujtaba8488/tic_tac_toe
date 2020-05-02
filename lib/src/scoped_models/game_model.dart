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
  }) {
    _currentGame = Game();
    _soundEffectPlayer = SoundEffectPlayer();
    statusChange = StatusChange.none;
  }

  /// Plays the move at the given index [at].
  void playMove(int at) {
    if (_currentGame.isMoveAvailable(at)) {
      if (_currentGame.anyMoveLeft) {
        _checkGameStatus();
        if (_playStatus == _PlayStatus.active) {
          _playTurn(at);
        } else {
          if (_playStatus == _PlayStatus.player1_won) {
            statusChange = StatusChange.player1_won;
          }else if (_playStatus == _PlayStatus.player2_won) {
            statusChange = StatusChange.player2_won;
          }
        }
      } else {
        statusChange = StatusChange.draw;
        _gameStatusChange();
      }
    } else {
      statusChange = StatusChange.error_next_move_unavailable;
      _gameStatusChange();
    }
  }

  /// Plays the [player] turn at the given position [at].
  void _playTurn(int at) {
    if (_turn == Turn.player1) {
      _currentGame.addMove(at, player1.mark);
      _currentGame.addPlayer1Move(at);
      _switchTurn();

      if (!disableSoundEffects)
        _soundEffectPlayer.play(_currentGame.player1SoundEffect);
    } else {
      _currentGame.addMove(at, player2.mark);
      _currentGame.addPlayer2Move(at);
      _switchTurn();

      if (!disableSoundEffects)
        _soundEffectPlayer.play(_currentGame.player2SoundEffect);
    }

    // Check to see if won / lost / draw after this game.
    _checkGameStatus();

    // Necessary. Notifies the listeners that a move has been played.
    notifyListeners();

    // Check and Play AI's turn.
    if (againstAI) {
      if (_turn == Turn.player2) {
        if (_currentGame.movesRemaining.length > 0) {
          if (_playStatus == _PlayStatus.active) {
            _playAiTurn();
          }
        }
      }
    }
  }

  /// Plays the AI turn.
  void _playAiTurn() {
    _isAiThinking = true;

    Future.delayed(aiThinkingDelay, () {
      _aiPlay();

      _isAiThinking = false;
    });
  }

  /// Checks if either of the players has won the game or if it is still on.
  void _checkGameStatus() {
    if (_hasWon(_currentGame.player1Moves)) {
      _winKey = _winningCombination(_currentGame.player1Moves);
      _playStatus = _PlayStatus.player1_won;
      _gameStatusChange();
    } else if (_hasWon(_currentGame.player2Moves)) {
      _winKey = _winningCombination(_currentGame.player2Moves);
      _playStatus = _PlayStatus.player2_won;
      _gameStatusChange();
    } else {
      _playStatus = _PlayStatus.active;
    }
  }

  /// Flips the turn.
  void _switchTurn() {
    _turn == Turn.player1 ? _turn = Turn.player2 : _turn = Turn.player1;
  }

  /// A very essential method, which describes and controls many factors that
  /// need updated or notified, when there is a change in game status.
  void _gameStatusChange() async {
    if (statusChange == StatusChange.draw) {
      if (!disableSoundEffects) _soundEffectPlayer.play(SoundEffect.draw);
      Score.draws++;
      notifyListeners();
    } else if (statusChange == StatusChange.player1_won) {
      if (!disableSoundEffects) _soundEffectPlayer.play(SoundEffect.win);
      _currentGame.player1Score.wins += 1;

      // Registers a win on cloud for player 1.
      Cloud().sync(player1.username, true);

      updatePlayerRank();
      notifyListeners();
    } else if (statusChange == StatusChange.player2_won) {
      if (!disableSoundEffects) _soundEffectPlayer.play(SoundEffect.lost);
      _currentGame.player2Score.wins += 1;

      // Registers a loss on cloud for player 1.
      Cloud().sync(player1.username, false);
      
      updatePlayerRank();
      notifyListeners();
    } else if (statusChange == StatusChange.error_next_move_unavailable) {
      if (!disableSoundEffects) _soundEffectPlayer.play(SoundEffect.error);
      notifyListeners();
    }
  }

  /// Plays the AI move. AI moves are subjected to many decisions, so that the
  /// AI plays intelligently. Later difficulty level can be set for the AI play.
  void _aiPlay() {
    if (_isWinPossible(_currentGame.player2Moves, _currentGame.moves) >= 0) {
      playMove(_isWinPossible(_currentGame.player2Moves, _currentGame.moves));
    } else if (_isWinPossible(_currentGame.player1Moves, _currentGame.moves) >=
        0) {
      playMove(_isWinPossible(_currentGame.player1Moves, _currentGame.moves));
    } else {
      _playRandomMove();
    }
  }

  /// Plays a random move from the [movesRemaining] i.e. the remaining moves.
  void _playRandomMove() {
    _currentGame.movesRemaining.shuffle();
    playMove(
      _currentGame
          .movesRemaining[Random().nextInt(_currentGame.movesRemaining.length)],
    );
  }

  /// Resets the game.
  void reset() {
    _currentGame.resetTotalMoves();
    _currentGame.resetPlayer1Moves();
    _currentGame.resetPlayer2Moves();

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
  List<String> get moves => _currentGame.moves;

  /// Returns true or false, depending upon whether the AI is thinking or not.
  bool get isAiThinking => _isAiThinking;

  /// Returns the total number of game draws.
  int get draws => Score.draws;

  /// Returns an unmodifiable list containing indexes which resulted in a win.
  List<int> get winKey => List.unmodifiable(_winKey);
}
