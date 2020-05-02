import 'sound_effect_player.dart';
import 'score.dart';

class Game {
  final List<String> _totalMoves;
  final List<int> _player1Moves;
  final List<int> _player2Moves;
  final Score player1Score = Score();
  final Score player2Score = Score();
  final SoundEffect player1SoundEffect = SoundEffect.userMove;
  final SoundEffect player2SoundEffect = SoundEffect.aiMove;

  Game()
      : _totalMoves = List.filled(9, ''),
        _player1Moves = [],
        _player2Moves = [];

  void addMove(int at, String move) {
    // if (!_totalMoves.contains(move)) {
    //   _totalMoves[at] = move;
    //   return true;
    // } else {
    //   return false;
    // }
    _totalMoves[at] = move;
  }

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

  bool isMoveAvailable(int at) => _totalMoves[at].isEmpty;

  /// Returns 'true' if there are still moves left to play, else returns false. If the game is still requesting another move, and there are no moves left to play it simply means that there is a 'draw'.
  bool get anyMoveLeft => moves.contains('');

  void resetPlayer1Moves() => _player1Moves.clear();

  void resetPlayer2Moves() => _player2Moves.clear();

  List<String> get moves => List.unmodifiable(_totalMoves);

  List<int> get player1Moves => List.unmodifiable(_player1Moves);

  List<int> get player2Moves => List.unmodifiable(_player2Moves);

  /// Returns the list of indicies left to play.
  List<int> get movesRemaining {
    List<int> remaining = [];

    for (int index = 0; index < _totalMoves.length; index++) {
      if (_totalMoves[index].isEmpty) remaining.add(index);
    }

    return remaining;
  }
}
