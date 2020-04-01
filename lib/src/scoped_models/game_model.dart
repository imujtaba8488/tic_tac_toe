import 'dart:math';

import 'package:scoped_model/scoped_model.dart';

import '../sound_effect.dart';
import '../player.dart';

/// Describes who's turn it is to play.
enum Turn { player1, player2 }

/// Describes the game status, i.e. whether moves are yet left to play or all moves have been consumed, hence, a draw.
enum _GameStatus { moves_available, draw }

/// Describes the play status, i.e. whether either of the players have won or the game is still on.
enum _PlayStatus { player1_won, player2_won, active }

/// Describes the moves status, i.e. whether a move at a given index is available to be played or not.
enum _MoveStatus { next_move_available, next_move_unavailable }

/// Describes any error that has resulted, such as, if a move has been played and there is an attempt to play it again.
enum Error { next_move_unavailable, none }

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
    if (_hasWon(player1.movesPlayed)) {
      winKey = _winningCombination(player1.movesPlayed);
      _playStatus = _PlayStatus.player1_won;
      _gameStatusChange();
    } else if (_hasWon(player2.movesPlayed)) {
      winKey = _winningCombination(player2.movesPlayed);
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

    // After resetting everything, if playing against AI and if it's AI's turn, play it's turn.
    if (againstAI) if (turn == Turn.player2) _aiPlay();

    notifyListeners();
  }

  /// A very essential method, which describes and controls many factors that need updated or notified, when there is a change in game status.
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

/// Return -1, if win is not possible for [forMoves], else returns the index where the win is possible for [forMoves] within the grid.
int isWinPossible(List<int> forMoves, List<String> inMoves) {
  if (_isHorizontalWinPossible(forMoves, inMoves) != -1) {
    return _isHorizontalWinPossible(forMoves, inMoves);
  } else if (_isVerticalWinPossibleFor(forMoves, inMoves) != -1) {
    return _isVerticalWinPossibleFor(forMoves, inMoves);
  } else if (_isDiagonalWinPossibleFor(forMoves, inMoves) != -1) {
    return _isDiagonalWinPossibleFor(forMoves, inMoves);
  } else {
    return -1;
  }
}

/// Returns -1, if win is not possible for [forMoves], else returns the index where the win is possible for [forMoves] within the grid.
int _isHorizontalWinPossible(
  List<int> forMoves,
  List<String> inMoves,
) {
  if (forMoves.contains(0) && forMoves.contains(1) && inMoves[2].isEmpty) {
    return 2;
  } else if (forMoves.contains(0) &&
      forMoves.contains(2) &&
      inMoves[1].isEmpty) {
    return 1;
  } else if (forMoves.contains(1) &&
      forMoves.contains(2) &&
      inMoves[0].isEmpty) {
    return 0;
  } else if (forMoves.contains(3) &&
      forMoves.contains(4) &&
      inMoves[5].isEmpty) {
    return 5;
  } else if (forMoves.contains(3) &&
      forMoves.contains(5) &&
      inMoves[4].isEmpty) {
    return 4;
  } else if (forMoves.contains(4) &&
      forMoves.contains(5) &&
      inMoves[3].isEmpty) {
    return 3;
  } else if (forMoves.contains(6) &&
      forMoves.contains(7) &&
      inMoves[8].isEmpty) {
    return 8;
  } else if (forMoves.contains(6) &&
      forMoves.contains(8) &&
      inMoves[7].isEmpty) {
    return 7;
  } else if (forMoves.contains(7) &&
      forMoves.contains(8) &&
      inMoves[6].isEmpty) {
    return 6;
  } else {
    return -1;
  }
}

/// Returns -1, if the win is not possible for [forMoves], else returns the index where the win is possible for [forMoves] within the grid.
int _isVerticalWinPossibleFor(List<int> forMoves, List<String> inMoves) {
  if (forMoves.contains(0) && forMoves.contains(3) && inMoves[6].isEmpty) {
    return 6;
  } else if (forMoves.contains(3) &&
      forMoves.contains(6) &&
      inMoves[0].isEmpty) {
    return 0;
  } else if (forMoves.contains(0) &&
      forMoves.contains(6) &&
      inMoves[3].isEmpty) {
    return 3;
  } else if (forMoves.contains(1) &&
      forMoves.contains(4) &&
      inMoves[7].isEmpty) {
    return 7;
  } else if (forMoves.contains(4) &&
      forMoves.contains(7) &&
      inMoves[1].isEmpty) {
    return 1;
  } else if (forMoves.contains(1) &&
      forMoves.contains(7) &&
      inMoves[4].isEmpty) {
    return 4;
  } else if (forMoves.contains(2) &&
      forMoves.contains(5) &&
      inMoves[8].isEmpty) {
    return 8;
  } else if (forMoves.contains(5) &&
      forMoves.contains(8) &&
      inMoves[2].isEmpty) {
    return 2;
  } else if (forMoves.contains(2) &&
      forMoves.contains(8) &&
      inMoves[5].isEmpty) {
    return 5;
  } else {
    return -1;
  }
}

/// Returns -1, if the win is not possible for [forMoves], else returns the index where the win is possible for [forMoves] within the grid.
int _isDiagonalWinPossibleFor(List<int> forMoves, List<String> inMoves) {
  if (forMoves.contains(0) && forMoves.contains(4) && inMoves[8].isEmpty) {
    return 8;
  } else if (forMoves.contains(4) &&
      forMoves.contains(8) &&
      inMoves[0].isEmpty) {
    return 0;
  } else if (forMoves.contains(0) &&
      forMoves.contains(8) &&
      inMoves[4].isEmpty) {
    return 4;
  } else if (forMoves.contains(2) &&
      forMoves.contains(4) &&
      inMoves[6].isEmpty) {
    return 6;
  } else if (forMoves.contains(4) &&
      forMoves.contains(6) &&
      inMoves[2].isEmpty) {
    return 2;
  } else if (forMoves.contains(2) &&
      forMoves.contains(6) &&
      inMoves[4].isEmpty) {
    return 4;
  } else {
    return -1;
  }
}

/// Returns true if [moves] contains a winning combination.
bool _hasWon(List<int> moves) {
  if (moves.contains(0) && moves.contains(1) && moves.contains(2)) {
    return true;
  } else if (moves.contains(3) && moves.contains(4) && moves.contains(5)) {
    return true;
  } else if (moves.contains(6) && moves.contains(7) && moves.contains(8)) {
    return true;
  } else if (moves.contains(0) && moves.contains(3) && moves.contains(6)) {
    return true;
  } else if (moves.contains(1) && moves.contains(4) && moves.contains(7)) {
    return true;
  } else if (moves.contains(2) && moves.contains(5) && moves.contains(8)) {
    return true;
  } else if (moves.contains(0) && moves.contains(4) && moves.contains(8)) {
    return true;
  } else if (moves.contains(2) && moves.contains(4) && moves.contains(6)) {
    return true;
  } else {
    return false;
  }
}

/// Returns the list of indexes that resulted in a win for the given [moves].
List<int> _winningCombination(List<int> moves) {
  if (moves.contains(0) && moves.contains(1) && moves.contains(2)) {
    return [0, 1, 2];
  } else if (moves.contains(3) && moves.contains(4) && moves.contains(5)) {
    return [3, 4, 5];
  } else if (moves.contains(6) && moves.contains(7) && moves.contains(8)) {
    return [6, 7, 8];
  } else if (moves.contains(0) && moves.contains(3) && moves.contains(6)) {
    return [0, 3, 6];
  } else if (moves.contains(1) && moves.contains(4) && moves.contains(7)) {
    return [1, 4, 7];
  } else if (moves.contains(2) && moves.contains(5) && moves.contains(8)) {
    return [2, 5, 8];
  } else if (moves.contains(0) && moves.contains(4) && moves.contains(8)) {
    return [0, 4, 8];
  } else if (moves.contains(2) && moves.contains(4) && moves.contains(6)) {
    return [2, 4, 6];
  } else {
    return [];
  }
}
