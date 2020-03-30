import 'dart:math';

import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/player.dart';
import 'package:tic_tac_toe/src/victory_combinations.dart';
import 'package:tic_tac_toe/src/win_possibilities.dart';

import '../sound_effect.dart';

enum Turn { player1, player2 }

class GameModel extends Model {
  /// Total number of moves available within the game.
  List<String> moves = List(9);

  _GameStatus _gameStatus = _GameStatus.moves_available;
  _MoveStatus _moveStatus = _MoveStatus.next_move_available;
  _PlayStatus _playStatus = _PlayStatus.active;
  Error error = Error.none;

  Player player1, player2;
  Turn turn;

  /// The combination of indexes that resulted in a win.
  List<int> winKey = [];

  bool againstAI;
  bool disableSoundEffects;

  SoundEffectPlayer _soundEffectPlayer;

  Function onGameStatusChange;

  GameModel(
    this.player1,
    this.player2,
    this.turn, {
    this.againstAI = true,
    this.onGameStatusChange,
    this.disableSoundEffects = false,
  }) {
    _initMovesToDefaultState();

    // No need to create, if disabled.
    if (!disableSoundEffects) _soundEffectPlayer = SoundEffectPlayer();
  }

  /// Initializes the moves to their default state.
  void _initMovesToDefaultState() {
    for (int i = 0; i < 9; i++) {
      moves[i] = '';
    }
  }

  /// Plays the move at the given index [at].
  void playMove(int at) {
    _checkGameStatus();
    _checkMoveStatus(at);

    if (_gameStatus == _GameStatus.moves_available) {
      if (_playStatus == _PlayStatus.active) {
        if (_moveStatus == _MoveStatus.next_move_available) {
          turn == Turn.player1
              ? _playTurn(at, player1)
              : _playTurn(at, player2);
        }
      }
    }
  }

  /// Plays the [player] turn at the given position [at].
  void _playTurn(int at, Player player) {
    moves[at] = player.mark;
    player.movesPlayed.add(at);

    // Play move sound if not disabled.
    if (!disableSoundEffects) _soundEffectPlayer.play(player.moveSoundEffect);

    _switchTurn();
    _checkPlayStatus();

    // Check for draw only if the last move doesn't result in a win.
    if (_playStatus != _PlayStatus.player1_won ||
        _playStatus != _PlayStatus.player2_won) _checkGameStatus();

    // Play AI's turn, if playing aganist the AI. Observe the three 'if' checks.
    if (againstAI) if (movesRemaining.length > 0) if (turn == Turn.player2)
      Future.delayed(Duration(milliseconds: 500), () {
        print('inside AI...');
        // Todo: Maybe during the delay a message 'thinking' can be displayed.
        _aiPlay();
        notifyListeners();
      });
  }

  /// Checks if any moves are left to play or the game is over.
  void _checkGameStatus() {
    if (moves.contains('')) {
      _gameStatus = _GameStatus.moves_available;
    } else {
      _gameStatus = _GameStatus.draw;
      _gameStatusChange();
      notifyListeners();
    }
  }

  /// Checks if either of the players has won or the game is still on.
  void _checkPlayStatus() {
    if (hasWon(player1.movesPlayed)) {
      winKey = winningCombination(player1.movesPlayed);
      _playStatus = _PlayStatus.player1_won;
      _gameStatusChange();
    } else if (hasWon(player2.movesPlayed)) {
      winKey = winningCombination(player2.movesPlayed);
      _playStatus = _PlayStatus.player2_won;
      _gameStatusChange();
    } else {
      _playStatus = _PlayStatus.active;
    }
  }

  /// Checks if a move can be played at the given position [at].
  void _checkMoveStatus(int at) {
    if (moves[at].isEmpty) {
      _moveStatus = _MoveStatus.next_move_available;
    } else {
      _moveStatus = _MoveStatus.next_move_unavailable;
    }
  }

  /// Flips the turn.
  void _switchTurn() =>
      turn == Turn.player1 ? turn = Turn.player2 : turn = Turn.player1;

  /// Returns a list of indexes of moves that are yet to be played.
  List<int> get movesRemaining {
    List<int> remaining = [];

    for (int i = 0; i < moves.length; i++) {
      if (moves[i].isEmpty) {
        remaining.add(i);
      }
    }

    return remaining;
  }

  /// Resets the game to its original status.
  void _reset() {
    player1.movesPlayed.clear();
    player2.movesPlayed.clear();
    _gameStatus = _GameStatus.moves_available;
    _moveStatus = _MoveStatus.next_move_available;
    _playStatus = _PlayStatus.active;
    winKey.clear();

    _initMovesToDefaultState();

    // After resetting everything, if playing against AI and if it's AI's turn, play his turn.
    if (againstAI) if (turn == Turn.player2) _aiPlay();

    notifyListeners();
  }

  /// A very essential method, which describes and controls many factors that need updated or notified, when there is a change is game status.
  void _gameStatusChange() {
    if (_gameStatus == _GameStatus.draw) {
      player1.updateDraw();
      player1.updateDraw();

      if (!disableSoundEffects) _soundEffectPlayer.play(SoundEffect.draw);

      onGameStatusChange('draws', onPressed: _reset);
      notifyListeners();
    } else if (_playStatus == _PlayStatus.player1_won) {
      player1.updateWin();

      if (!disableSoundEffects) _soundEffectPlayer.play(SoundEffect.win);

      onGameStatusChange(
        player1.name + ' Score: ${player1.score.wins}',
        onPressed: _reset,
      );
      notifyListeners();
    } else if (_playStatus == _PlayStatus.player2_won) {
      player2.updateWin();

      if (!disableSoundEffects) _soundEffectPlayer.play(SoundEffect.lost);

      onGameStatusChange(
        player2.name + ' Score: ${player2.score.wins}',
        onPressed: _reset,
      );
      notifyListeners();
    } else if (_moveStatus == _MoveStatus.next_move_unavailable) {
      error = Error.next_move_unavailable;

      if (!disableSoundEffects) _soundEffectPlayer.play(SoundEffect.error);
      notifyListeners();
    }
  }

  /// Plays the AI move. AI moves are subjected to many decisions, so that the AI plays intelligently. Later difficulty level can be set for the AI play.
  void _aiPlay() {
    if (isWinPossible(player2.movesPlayed, moves) >= 0) {
      playMove(isWinPossible(player2.movesPlayed, moves));
    } else if (isWinPossible(player1.movesPlayed, moves) >= 0) {
      playMove(isWinPossible(player1.movesPlayed, moves));
    } else {
      _playRandomMove();
    }
  }

  /// Plays a random move from the remaining moves.
  void _playRandomMove() {
    movesRemaining.shuffle();
    playMove(movesRemaining[Random().nextInt(movesRemaining.length)]);
  }
}

/// Describes the game status, i.e. whether moves are yet left to play or all moves have been consumed, hence, a draw.
enum _GameStatus { moves_available, draw }

/// Describes the play status, i.e. whether either of the players have won or the game is still on.
enum _PlayStatus { player1_won, player2_won, active }

/// Describes the moves status, i.e. whether a move at a given index is available to be played or not.
enum _MoveStatus { next_move_available, next_move_unavailable }

/// Describes any error that has resulted, such as, if a move has been played and there is an attempt to play it again.
enum Error { next_move_unavailable, none}
