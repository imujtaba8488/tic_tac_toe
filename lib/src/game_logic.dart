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

          print('User Played'); // Temp.

          // After the move has been played.
          if (hasUserWon) {
            winner = Winner.player;
            reportWinner(winner);
          }

          if (!anyMoveLeft) {
            winner = Winner.draw;
            reportWinner(winner);
          }
        } else {
          _totalMoves[index] = ai.mark;
          ai.movesPlayed.add(index);
          _switchTurn();

          print('AI Played'); // Temp.

          // After the move has been played.
          if (hasAIWon) {
            winner = Winner.ai;
            reportWinner(winner);
          }

          if (!anyMoveLeft) {
            winner = Winner.draw;
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
          print("** DRAW in Random **");
          winner = Winner.draw;
          reportWinner(winner);
        }
      }
    }
  }

  /// Plays a random move, if one is left.
  bool _playRandomMove() {
    // First, get all the moves that are left to play. Then randomly shuffle the moves that are left. Finally, pick a random move from the randomly shuffled list of moves that were left.
    List<int> movesLeft = [];

    for (int i = 0; i < _totalMoves.length; i++) {
      if (_totalMoves[i].isEmpty) {
        movesLeft.add(i);
      }
    }

    if (anyMoveLeft) {
      movesLeft.shuffle();

      // Pick a random move from the shuffled movesLeft list and play it.
      playMove(movesLeft[Random().nextInt(movesLeft.length)]);
      return true;
    } else {
      return false;
    }
  }

  void resetGame() {
    for (int i = 0; i < _totalMoves.length; i++) {
      _totalMoves[i] = '';
    }

    ai.movesPlayed.clear();
    user.movesPlayed.clear();

    winner = Winner.none;

    _switchTurn();
  }

  void _switchTurn() => turn == Turn.ai ? turn = Turn.player : turn = Turn.ai;

  //*** Gettes and Setters ***//

  bool get hasAIWon => hasWon(ai.movesPlayed);

  bool get hasUserWon => hasWon(user.movesPlayed);

  bool get anyMoveLeft => _totalMoves.contains('');

  bool isMoveAvailable(int index) => _totalMoves[index].isEmpty;
}

enum Turn { player, ai }

enum Winner { player, ai, draw, none }

enum Error { place_taken, none }
