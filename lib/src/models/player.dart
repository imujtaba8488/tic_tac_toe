import 'score.dart';
import 'sound_effect_player.dart';

class Player {
  /// Name of the player.
  String name;

  /// The mark assigned to the player.
  String mark;

  /// The total number of moves played by this player.
  List<int> _movesPlayed;

  /// The current game score of the player.
  Score _currentScore;

  /// The lifetime score of the player for all the games.
  Score _lifeTimeScore;

  /// The move sound-effect assigned to this player.
  SoundEffect moveSoundEffect;

  Player({
    this.name = '',
    this.mark = '',
    this.moveSoundEffect = SoundEffect.userMove,
  }) {
    _movesPlayed = [];
    _currentScore = Score(wins: 0, loss: 0);
    _lifeTimeScore = Score();
  }

  /// Adds the given move [movePlayedAt] to the list of this player's moves.
  void addMove(int movePlayedAt) {
    _movesPlayed.add(movePlayedAt);
  }

  /// Resets all player moves back to 0.
  void resetMoves() {
    _movesPlayed.clear();
  }

  /// Updates score by a win.
  void registerAWin() {
    _currentScore.wins++;
    _lifeTimeScore.wins++;
  }

  /// Updates score by a loss.
  void registerALoss() {
    _currentScore.loss++;
    _lifeTimeScore.loss++;
  }

  /// Returns a read-only copy of moves played by this player.
  List<int> get movesPlayed => List<int>.unmodifiable(_movesPlayed);

  /// Returns a read-only copy of score of this player.
  Score get currentScore =>
      Score(wins: _currentScore.wins, loss: _currentScore.loss);
}
