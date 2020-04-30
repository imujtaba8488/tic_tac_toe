class Game {
  final List<int> _player1Moves;
  final List<int> _player2Moves;

  Game()
      : _player1Moves = [],
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

  void resetPlayer1Moves() => _player1Moves.clear();

  void resetPlayer2Moves() => _player2Moves.clear();

  List<int> get player1MovesPlayed => List.unmodifiable(_player1Moves);

  List<int> get player2MovesPlayed => List.unmodifiable(_player2Moves);
}
