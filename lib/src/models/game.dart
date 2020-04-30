class Game {
  final List<String> _totalMoves;
  final List<int> _player1Moves;
  final List<int> _player2Moves;

  Game()
      : _totalMoves = List.filled(9, ''),
        _player1Moves = [],
        _player2Moves = [];

  bool addPlayer1Move(int move) {
    if (!_player1Moves.contains(move)) {
      _player1Moves.add(move);
      return true;
    } else {
      return false;
    }
  }

  bool addPlayer2Move(int move) {
    if (!_player1Moves.contains(move)) {
      _player2Moves.add(move);
      return true;
    } else {
      return false;
    }
  }

  void resetTotalMoves() {
    for (int index = 0; index < _totalMoves.length; index++) {
      _totalMoves[index] = '';
    }
  }

  void resetPlayer1Moves() => _player1Moves.clear();

  void resetPlayer2Moves() => _player2Moves.clear();

  List<String> get totalMoves => List.unmodifiable(_totalMoves);

  List<int> get player1MovesPlayed => List.unmodifiable(_player1Moves);

  List<int> get player2MovesPlayed => List.unmodifiable(_player2Moves);

  /// Returns the list of indicies left to play.
  List<int> get movesRemaining {
    List<int> remaining = [];

    for (int index = 0; index < _totalMoves.length; index++) {
      if (_totalMoves[index].isEmpty) remaining.add(index);
    }

    return remaining;
  }
}
