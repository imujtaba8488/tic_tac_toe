class Score {
  int wins = 0;
  int loss = 0;
  int draws = 0;
  ScoreType scoreType = ScoreType.none;
}

enum ScoreType {
  none,
  win,
  loss,
  draw,
}