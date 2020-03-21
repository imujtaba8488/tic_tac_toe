import 'dart:math';

import 'player.dart';
import 'sound_effect.dart';
import 'victory_combinations.dart';
import 'win_possibilities.dart';

class GameLogic {
  final List<String> _totalMoves = List(9);
  final Player user = Player();
  final Player ai = Player();
  Turn turn = Turn.player;
  Winner winner = Winner.none;
  Error error = Error.none;
  final SoundEffectPlayer soundEffectPlayer = SoundEffectPlayer();

  GameLogic() {
    _totalMoves.fillRange(0, 9, '');
    user.mark = 'X';
    ai.mark = '0';
  }

  List<String> get movesPlayed => List.of(_totalMoves);

  // Review: Think about it like this. When you call this method, you are asking it to play a move. Once the move is played, you want to know whether this was the winning move i.e. someone has won, or this move resulted in a draw or an error.
  void playMove(int index, {Function reportWinner, reportError}) {
    if (anyMoveLeft) {
      if (isMoveAvailable(index)) {
        if (turn == Turn.player) {
          _totalMoves[index] = user.mark;
          user.movesPlayed.add(index);
          _switchTurn();

          // After the move has been played.
          if (hasUserWon) {
            winner = Winner.player;
            reportWinner(winner);
          }
        } else {
          _totalMoves[index] = ai.mark;
          ai.movesPlayed.add(index);
          _switchTurn();

          // After the move has been played.
          if (hasAIWon) {
            winner = Winner.ai;
            reportWinner(winner);
          }
        }
      } else {
        reportError(Error.place_taken);
      }
    } else {
      winner = Winner.draw;
      reportWinner(Winner.draw);
    }
  }

  bool get anyMoveLeft => movesLeft.length > 0;

  bool isMoveAvailable(int index) => _totalMoves[index].isEmpty;

  void _switchTurn() => turn == Turn.ai ? turn = Turn.player : turn = Turn.ai;

  void aiAutoPlay({Function reportWinner, Function reportError}) {
    if (winner == Winner.none) {
      if (isWinPossibe(ai.movesPlayed, _totalMoves) != -1) {
        playMove(
          isWinPossibe(ai.movesPlayed, _totalMoves),
          reportWinner: reportWinner,
          reportError: reportError,
        );
      } else if (isWinPossibe(user.movesPlayed, _totalMoves) != -1) {
        playMove(
          isWinPossibe(user.movesPlayed, _totalMoves),
          reportWinner: reportWinner,
          reportError: reportError,
        );
      } else {
        // Declare draw if a random move is not available.
        if (!_playRandomMove()) {
          winner = Winner.draw;
          reportWinner(winner);
        }
      }
    }
  }

  /// Plays a random move, if one is left.
  bool _playRandomMove() {
    if (movesLeft.length > 0) {
      movesLeft.shuffle();

      // Pick a random move from the shuffled movesLeft list and play it.
      playMove(movesLeft[Random().nextInt(movesLeft.length)]);
      return true;
    } else {
      return false;
    }
  }

  List<int> get movesLeft {
    List<int> remainingMoves = List();

    for (int i = 0; i < _totalMoves.length; i++) {
      if (_totalMoves[i] == '') {
        remainingMoves.add(i);
      }
    }

    return remainingMoves;
  }

  bool get hasAIWon => hasWon(ai.movesPlayed);

  bool get hasUserWon => hasWon(user.movesPlayed);

  void resetGame() {
    for (int i = 0; i < _totalMoves.length; i++) {
      _totalMoves[i] = '';
    }
    // _aiMoves.clear();
    // _playerMoves.clear();

    _switchTurn();
  }
}

enum Turn { player, ai }

enum Winner { player, ai, draw, none }

enum Error { place_taken, none }
