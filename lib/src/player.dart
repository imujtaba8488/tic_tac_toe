import 'score.dart';

class Player {
  String name;
  String mark;
  List<int> movesPlayed;
  Score _score;

  Player() {
    movesPlayed = [];
    _score = Score();
  }

  void updateWin() {
    _score.wins++;
    _score.scoreType = ScoreType.win;
  }

  void updateLost() {
    _score.loss++;
    _score.scoreType = ScoreType.loss;
  }

  void updateDraw() {
    _score.draws++;
    _score.scoreType = ScoreType.draw;
  }

  // Later: Perhaps you may need to return a copy of this score.
  void get score => _score;
}
