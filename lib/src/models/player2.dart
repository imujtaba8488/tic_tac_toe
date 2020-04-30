import '../models/score.dart';
import '../models/sound_effect_player.dart';

class Player2 {
  String email;
  String username;
  String password;
  String mark;
  int totalGamesPlayed;
  Score lifeTimeScore;
  int rank;
  SoundEffect moveSoundEffect;

  Player2({
    this.email = '',
    this.username = '',
    this.password = '',
    this.mark = 'X',
    this.totalGamesPlayed = 0,
    this.lifeTimeScore,
    this.rank = 0,
    this.moveSoundEffect = SoundEffect.userMove,
  }) {
    assert(lifeTimeScore != null, 'lifeTimeScore cannot be null');
  }
}
