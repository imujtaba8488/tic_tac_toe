import 'dart:math';

import 'sound_effect.dart';

class GameLogic {
  final List<String> _totalMoves = List(9);
  final String _playerMark = 'X';
  final String _aiMark = '0';
  final List<int> _playerMoves = [];
  final List<int> _aiMoves = [];
  Turn turn = Turn.player;
  Winner winner = Winner.none;
  Error error = Error.none;
  bool _winnerFound = false;
  final SoundEffectPlayer soundEffectPlayer = SoundEffectPlayer();

  GameLogic() {
    _totalMoves.fillRange(0, 9, '');
  }

  List<String> get movesPlayed => List.of(_totalMoves);

  // Review: Think about it like this. When you call this method, you are asking it to play a move. Once the move is played, you want to know whether this was the winning move i.e. someone has won, or this move resulted in a draw or an error.
  void playMove(
    int index, {
    Function reportWinnerFound,
    Function drawDeclared,
    Function reportError,
  }) {
    // First check if a move is left to play, if one is left find out who's turn it is, then check out if that move is playable i.e. that place is not already taken by someone else i.e. player or ai. If the move is playable, play the move and then check if this move resulted in a victory, draw, error or nothing.
    if (movesLeft.length > 0) {
      if (turn == Turn.player) {
        if (_totalMoves[index].isEmpty) {
          _totalMoves[index] = _playerMark;
          _playerMoves.add(index);
          turn = Turn.ai;
          // soundEffectPlayer.play(SoundEffect.playerMove);

          // after the move is played
          if (hasPlayerWon) {
            _winnerFound = true;
            winner = Winner.player;
            reportWinnerFound != null
                ? reportWinnerFound(winner)
                : print('Player has won');
          }
        } else {
          print('error...');
        }
      } else if (turn == Turn.ai) {
        if (_totalMoves[index].isEmpty) {
          _totalMoves[index] = _aiMark;
          _aiMoves.add(index);
          turn = Turn.player;
          // soundEffectPlayer.play(SoundEffect.aiMove);

          // after the move is played
          if (hasAIWon) {
            _winnerFound = true;
            winner = Winner.ai;
            reportWinnerFound != null
                ? reportWinnerFound(winner)
                : print("AI has won.");
          }
        } else {
          error = Error.place_taken;
          reportError != null
              ? reportError(error)
              : print("Error: Place taken");
        }
      }
    } else {
      winner = Winner.draw;
      drawDeclared != null ? drawDeclared() : print('It is a draw!');
    }
  }

  void aiAutoPlay({
    Function reportWinnerFound,
    Function drawDeclared,
    Function reportError,
  }) {
    // AI should only play if the winner is not yet found, or a move is still left to play.
    if (!_winnerFound) {
      if (_isWinPossibeFor(_aiMoves) != -1) {
        playMove(
          _isWinPossibeFor(_aiMoves),
          reportWinnerFound: reportWinnerFound,
          drawDeclared: drawDeclared,
          reportError: reportError,
        );
      } else if (_isWinPossibeFor(_playerMoves) != -1) {
        playMove(
          _isWinPossibeFor(_playerMoves),
          reportWinnerFound: reportWinnerFound,
          drawDeclared: drawDeclared,
          reportError: reportError,
        );
      } else {
        // Declare draw if a random move is not available.
        if(!_playRandomMove()) {
          drawDeclared != null ? drawDeclared() : print("It is a draw");
        }
      }
    }
  }

  /// Plays a random move, if one is left.
  bool _playRandomMove() {
    if (movesLeft.length > 0) {
      movesLeft.shuffle();

      // Pick a random move from the shuffled movesLeft list and play it.
      playMove(movesLeft[Random().nextInt(movesLeft.length)]);
      return true;
    } else {
      return false;
    }
  }

  List<int> get movesLeft {
    List<int> remainingMoves = List();

    for (int i = 0; i < _totalMoves.length; i++) {
      if (_totalMoves[i] == '') {
        remainingMoves.add(i);
      }
    }

    return remainingMoves;
  }

  /// Return -1, if win is not possible for [moves], else returns the index where the win is possible for [moves] within the grid.
  int _isWinPossibeFor(List<int> moves) {
    if (_isHorizontalWinPossibleFor(moves) != -1) {
      return _isHorizontalWinPossibleFor(moves);
    } else if (_isVerticalWinPossibleFor(moves) != -1) {
      return _isVerticalWinPossibleFor(moves);
    } else if (_isDiagonalWinPossibleFor(moves) != -1) {
      return _isDiagonalWinPossibleFor(moves);
    } else {
      return -1;
    }
  }

  /// Returns -1, if win is not possible for [horizontalMoves], else returns the index where the win is possible for [horizontalMoves] within the grid.
  int _isHorizontalWinPossibleFor(List<int> horizontalMoves) {
    if (horizontalMoves.contains(0) &&
        horizontalMoves.contains(1) &&
        _totalMoves[2].isEmpty) {
      return 2;
    } else if (horizontalMoves.contains(0) &&
        horizontalMoves.contains(2) &&
        _totalMoves[1].isEmpty) {
      return 1;
    } else if (horizontalMoves.contains(1) &&
        horizontalMoves.contains(2) &&
        _totalMoves[0].isEmpty) {
      return 0;
    } else if (horizontalMoves.contains(3) &&
        horizontalMoves.contains(4) &&
        _totalMoves[5].isEmpty) {
      return 5;
    } else if (horizontalMoves.contains(3) &&
        horizontalMoves.contains(5) &&
        _totalMoves[4].isEmpty) {
      return 4;
    } else if (horizontalMoves.contains(4) &&
        horizontalMoves.contains(5) &&
        _totalMoves[3].isEmpty) {
      return 3;
    } else if (horizontalMoves.contains(6) &&
        horizontalMoves.contains(7) &&
        _totalMoves[8].isEmpty) {
      return 8;
    } else if (horizontalMoves.contains(6) &&
        horizontalMoves.contains(8) &&
        _totalMoves[7].isEmpty) {
      return 7;
    } else if (horizontalMoves.contains(7) &&
        horizontalMoves.contains(8) &&
        _totalMoves[6].isEmpty) {
      return 6;
    } else {
      return -1;
    }
  }

  /// Returns -1, if the win is not possible for [verticalMoves], else returns the index where the win is possible for [verticalMoves] within the grid.
  int _isVerticalWinPossibleFor(List<int> verticalMoves) {
    if (verticalMoves.contains(0) &&
        verticalMoves.contains(3) &&
        _totalMoves[6].isEmpty) {
      return 6;
    } else if (verticalMoves.contains(3) &&
        verticalMoves.contains(6) &&
        _totalMoves[0].isEmpty) {
      return 0;
    } else if (verticalMoves.contains(0) &&
        verticalMoves.contains(6) &&
        _totalMoves[3].isEmpty) {
      return 3;
    } else if (verticalMoves.contains(1) &&
        verticalMoves.contains(4) &&
        _totalMoves[7].isEmpty) {
      return 7;
    } else if (verticalMoves.contains(4) &&
        verticalMoves.contains(7) &&
        _totalMoves[1].isEmpty) {
      return 1;
    } else if (verticalMoves.contains(1) &&
        verticalMoves.contains(7) &&
        _totalMoves[4].isEmpty) {
      return 4;
    } else if (verticalMoves.contains(2) &&
        verticalMoves.contains(5) &&
        _totalMoves[8].isEmpty) {
      return 8;
    } else if (verticalMoves.contains(5) &&
        verticalMoves.contains(8) &&
        _totalMoves[2].isEmpty) {
      return 2;
    } else if (verticalMoves.contains(2) &&
        verticalMoves.contains(8) &&
        _totalMoves[5].isEmpty) {
      return 5;
    } else {
      return -1;
    }
  }

  /// Returns -1, if the win is not possible for [diagonalMoves], else returns the index where the win is possible for [diagonalMoves] within the grid.
  int _isDiagonalWinPossibleFor(List<int> diagonalMoves) {
    if (diagonalMoves.contains(0) &&
        diagonalMoves.contains(4) &&
        _totalMoves[8].isEmpty) {
      return 8;
    } else if (diagonalMoves.contains(4) &&
        diagonalMoves.contains(8) &&
        _totalMoves[0].isEmpty) {
      return 0;
    } else if (diagonalMoves.contains(0) &&
        diagonalMoves.contains(8) &&
        _totalMoves[4].isEmpty) {
      return 4;
    } else if (diagonalMoves.contains(2) &&
        diagonalMoves.contains(4) &&
        _totalMoves[6].isEmpty) {
      return 6;
    } else if (diagonalMoves.contains(4) &&
        diagonalMoves.contains(6) &&
        _totalMoves[2].isEmpty) {
      return 2;
    } else if (diagonalMoves.contains(2) &&
        diagonalMoves.contains(6) &&
        _totalMoves[4].isEmpty) {
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

  bool get hasAIWon {
    return _hasWon(_aiMoves);
  }

  bool get hasPlayerWon {
    return _hasWon(_playerMoves);
  }

  void resetGame() {
    for (int i = 0; i < _totalMoves.length; i++) {
      _totalMoves[i] = '';
    }
    _aiMoves.clear();
    _playerMoves.clear();
  }
}

enum Turn { player, ai }

enum Winner { player, ai, draw, none }

enum Error { place_taken, none }
