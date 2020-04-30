import 'score.dart';
import 'sound_effect_player.dart';

class Player {
  String name;
  String email;
  String username;
  String password;

  /// The mark assigned to the player.
  String mark;

  /// Tracks number of moves played by this player for the current game.
  List<int> _currentMovesPlayed;

  /// The current game score of the player.
  Score _currentScore;

  /// The move sound-effect assigned to this player.
  SoundEffect moveSoundEffect;

  /// The lifetime score of the player for all the games.
  Score lifeTimeScore;

  int rank;
  int lifeTimeMoveCount;
  int totalGamesPlayed;
  // Others here such as; min move time, max move time, etc.

  Player({
    this.name = '',
    this.mark = '',
    this.moveSoundEffect = SoundEffect.userMove,
  }) {
    _currentMovesPlayed = [];
    _currentScore = Score(wins: 0, loss: 0);
    lifeTimeScore = Score();
  }

  /// Adds the given move [movePlayedAt] to the list of this player's moves.
  void addMove(int movePlayedAt) {
    _currentMovesPlayed.add(movePlayedAt);
  }

  /// Resets all player moves back to 0.
  void resetMoves() {
    _currentMovesPlayed.clear();
  }

  /// Updates score by a win.
  void registerAWin() {
    _currentScore.wins++;
  }

  /// Updates score by a loss.
  void registerALoss() {
    _currentScore.loss++;
  }

  /// Returns a read-only copy of moves played by this player.
  List<int> get movesPlayed => List<int>.unmodifiable(_currentMovesPlayed);

  /// Returns a read-only copy of score of this player.
  Score get currentScore =>
      Score(wins: _currentScore.wins, loss: _currentScore.loss);
}
