import 'dart:math';

import 'sound_effect.dart';

class GameLogic {
  final List<String> _totalMoves = List(9);
  final String _playerMark = 'X';
  final String _aiMark = '0';
  final List<int> _playerMoves = [];
  final List<int> _aiMoves = [];
  Turn turn = Turn.player;
  final SoundEffectPlayer soundEffectPlayer = SoundEffectPlayer();

  GameLogic() {
    _totalMoves.fillRange(0, 9, '');
  }

  List<String> get movesPlayed => List.of(_totalMoves);

  void playMove(int index) {
    if (movesLeft.length > 0) {
      if (turn == Turn.player) {
        _totalMoves[index] = _playerMark;
        _playerMoves.add(index);
        turn = Turn.ai;
        soundEffectPlayer.play(SoundEffect.playerMove);
      } else {
        _totalMoves[index] = _aiMark;
        _aiMoves.add(index);
        turn = Turn.player;
        soundEffectPlayer.play(SoundEffect.aiMove);
      }
    } else {
      print('No more moves left');
    }
  }

  void aiAutoPlay() {
    if (_isWinPossibeFor(_aiMoves) != -1) {
      playMove(_isWinPossibeFor(_aiMoves));
    } else if (_isWinPossibeFor(_playerMoves) != -1) {
      playMove(_isWinPossibeFor(_playerMoves));
    } else {
      _playRandomMove();
    }
  }

  /// Plays a random move, if one is left.
  void _playRandomMove() {
    if (movesLeft.length > 0) {
      movesLeft.shuffle();

      // Pick a random move from the shuffled movesLeft list and play it.
      playMove(movesLeft[Random().nextInt(movesLeft.length)]);
    } else {
      print('No more moves left');
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
