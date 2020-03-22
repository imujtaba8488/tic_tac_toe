import 'dart:math';

import 'player.dart';
import 'sound_effect.dart';
import 'victory_combinations.dart';
import 'win_possibilities.dart';

class GameLogic {
  final List<String> _totalMoves = List(9);
  final Player user = Player();
  final Player ai = Player();
  Turn turn = Turn.user;
  Winner winner = Winner.none;
  Error error = Error.none;
  final SoundEffectPlayer _soundEffectPlayer = SoundEffectPlayer();

  GameLogic() {
    _totalMoves.fillRange(0, 9, '');
    user.name = 'User';
    ai.name = 'AI';
    user.mark = 'X';
    ai.mark = '0';
  }

  List<String> get movesPlayed => List.of(_totalMoves);

  // Review: Think about it like this. When you call this method, you are asking it to play a move. Once the move is played, you want to know whether this was the winning move i.e. someone has won, or this move resulted in a draw or an error.
  void playMove(int index, {Function reportWinner, reportError}) {
    if (anyMoveLeft) {
      if (isMoveAvailable(index)) {
        if (turn == Turn.user) {
          _totalMoves[index] = user.mark;
          user.movesPlayed.add(index);
          _switchTurn();
          _soundEffectPlayer.play(SoundEffect.userMove);

          // Once the move has been played, check if user is the winner or if this was the last move of the game, hence a draw.
          if (hasUserWon) {
            winner = Winner.user;
            reportWinner != null ? reportWinner(winner) : _printWinner();
            _soundEffectPlayer.play(SoundEffect.win);
          } else if (anyMoveLeft == false) {
            winner = Winner.draw;
            reportWinner != null ? reportWinner(winner) : _printWinner();
            _soundEffectPlayer.play(SoundEffect.draw);
          }
        } else {
          _totalMoves[index] = ai.mark;
          ai.movesPlayed.add(index);
          _switchTurn();
          _soundEffectPlayer.play(SoundEffect.aiMove);

          // Once the move has been played, check if user is the winner or if this was the last move of the game, hence a draw.
          if (hasAIWon) {
            winner = Winner.ai;
            reportWinner != null ? reportWinner(winner) : _printWinner();
            _soundEffectPlayer.play(SoundEffect.lost);
          } else if (anyMoveLeft == false) {
            winner = Winner.draw;
            reportWinner != null ? reportWinner(winner) : _printWinner();
            _soundEffectPlayer.play(SoundEffect.draw);
          }
        }
      } else {
        error = Error.place_taken;
        reportError != null ? reportError(Error.place_taken) : _printError();
        _soundEffectPlayer.play(SoundEffect.error);
      }
    } else {
      winner = Winner.draw;
      reportWinner(Winner.draw);
      _soundEffectPlayer.play(SoundEffect.draw);
    }
  }

  void aiAutoPlay({Function reportWinner, Function reportError}) {
    if (winner == Winner.none) {
      if (isWinPossible(ai.movesPlayed, _totalMoves) != -1) {
        playMove(
          isWinPossible(ai.movesPlayed, _totalMoves),
          reportWinner: reportWinner,
          reportError: reportError,
        );
      } else if (isWinPossible(user.movesPlayed, _totalMoves) != -1) {
        playMove(
          isWinPossible(user.movesPlayed, _totalMoves),
          reportWinner: reportWinner,
          reportError: reportError,
        );
      } else {
        // Declare draw if a random move is not available.
        if (!_playRandomMove()) {
          winner = Winner.draw;
          reportWinner != null ? reportWinner(winner) : _printWinner();
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

    _soundEffectPlayer.stop();
  }

  void _switchTurn() => turn == Turn.ai ? turn = Turn.user : turn = Turn.ai;

  void _printWinner() {
    switch (winner) {
      case Winner.ai:
        print('${ai.name} is the winner!');
        break;

      case Winner.user:
        print('${user.name} is the winner!');
        break;

      default:
        print('It is a draw!');
        break;
    }
  }

  void _printError() {
    switch (error) {
      case Error.place_taken:
        print('Error: Place is already taken');
        break;

      default:
        break;
    }
  }

  //*** Getters and Setters ***//

  bool get hasAIWon => hasWon(ai.movesPlayed);

  bool get hasUserWon => hasWon(user.movesPlayed);

  bool get anyMoveLeft => _totalMoves.contains('');

  bool isMoveAvailable(int index) => _totalMoves[index].isEmpty;
}

enum Turn { user, ai }

enum Winner { user, ai, draw, none }

enum Error { place_taken, none }
