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
