import 'score.dart';
import 'sound_effect.dart';

class Player {
  String name;
  String mark;
  List<int> _movesPlayed;
  Score _score;
  SoundEffect moveSoundEffect;

  Player({
    this.name = '',
    this.mark = '',
    this.moveSoundEffect = SoundEffect.userMove,
  }) {
    _movesPlayed = [];
    _score = Score(wins: 0, loss: 0);
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
  void registerWin() {
    _score.wins++;
  }

  /// Updates score by a loss.
  void registerLoss() {
    _score.loss++;
  }

  /// Returns a read-only copy of moves played by this player.
  List<int> get movesPlayed => List<int>.unmodifiable(_movesPlayed);

  /// Returns a read-only copy of score of this player.
  Score get score => Score(wins: _score.wins, loss: _score.loss);
}
