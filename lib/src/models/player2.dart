import '../models/score.dart';

class Player2 {
  String email;
  String username;
  String password;
  String mark;
  int totalGamesPlayed;
  Score lifeTimeScore;
  int rank;

  Player2({
    this.email = '',
    this.username = '',
    this.password = '',
    this.mark = 'X',
    this.totalGamesPlayed = 0,
    this.lifeTimeScore,
    this.rank = 0,
  }) {
    assert(lifeTimeScore != null, 'lifeTimeScore cannot be null');
  }
}
