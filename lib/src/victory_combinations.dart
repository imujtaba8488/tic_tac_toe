/// Returns true if [moves] contains a winning combination.
bool hasWon(List<int> moves) {
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

List<int> winningCombination(List<int> moves) {
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
