import 'package:tic_tac_toe/src/sound_effect.dart';

import 'score.dart';

class Player {
  String name;
  String mark;
  List<int> movesPlayed;
  Score _score;
  SoundEffect moveSoundEffect;

  Player({this.name, this.mark, this.moveSoundEffect}) {
    movesPlayed = [];
    _score = Score();
  }

  void updateWin() {
    _score.wins++;
  }

  void updateLost() {
    _score.loss++;
  }

  void updateDraw() {
    // Score.draws++;
  }

  // Later: Perhaps you may need to return a copy of this score.
  void get score => _score;
}
