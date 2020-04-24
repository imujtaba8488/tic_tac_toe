part of 'game_model.dart';

/// Return -1, if win is not possible for [forMoves], else returns the index where the win is possible for [forMoves] within the grid.
int _isWinPossible(List<int> forMoves, List<String> inMoves) {
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
