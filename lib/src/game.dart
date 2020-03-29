import 'package:tic_tac_toe/src/player.dart';
import 'package:tic_tac_toe/src/victory_combinations.dart';

enum Turn2 { player1, player2 }

class Game {
  List<String> places = List(9);
  GameStatus gameStatus = GameStatus.movesAvailable;
  Player player1, player2;
  Turn2 turn;
  List<int> winKey = [];

  Game(this.player1, this.player2, this.turn) {
    // init moves...
    for (int i = 0; i < 9; i++) {
      places[i] = '';
    }
  }

  GameStatus playMove(int at) {
    _checkGameStatus();

    if (at >= 0 && at < 9) {
      if (gameStatus == GameStatus.movesAvailable) {
        if (turn == Turn2.player1) {
          if (_isMoveAvailable(at)) {
            places[at] = player1.mark;
            player1.movesPlayed.add(at);
            turn = Turn2.player2;
            // switchTurn();

            _checkGameStatus();

            if (hasWon(player1.movesPlayed)) {
              winKey = winningCombination(player1.movesPlayed); // Review:
              gameStatus = GameStatus.player1Won;
              return gameStatus;
            } else if (gameStatus == GameStatus.draw) {
              gameStatus = GameStatus.draw;
              return gameStatus;
            } else {
              gameStatus = GameStatus.move_played;
              return gameStatus;
            }
          } else {
            gameStatus = GameStatus.move_unavailable;
            return gameStatus;
          }
        } else {
          if (_isMoveAvailable(at)) {
            places[at] = player2.mark;
            player2.movesPlayed.add(at);
            turn = Turn2.player1;
            // switchTurn();

            _checkGameStatus();

            if (hasWon(player2.movesPlayed)) {
              winKey = winningCombination(player2.movesPlayed); // Review:
              gameStatus = GameStatus.player2Won;
              return gameStatus;
            } else if (gameStatus == GameStatus.draw) {
              gameStatus = GameStatus.draw;
              return gameStatus;
            } else {
              gameStatus = GameStatus.move_played;
              return gameStatus;
            }
          } else {
            gameStatus = GameStatus.move_unavailable;
            return gameStatus;
          }
        }
      } else {
        gameStatus = GameStatus.draw;
        return gameStatus;
      }
    } else {
      gameStatus = GameStatus.invalid_move;
      return gameStatus;
    }
  }

  bool _isMoveAvailable(int at) {
    return places[at] == '';
  }

  void _checkGameStatus() {
    if (places.contains('')) {
      gameStatus = GameStatus.movesAvailable;
    } else {
      gameStatus = GameStatus.draw;
    }
  }

  void switchTurn() =>
      turn == Turn2.player1 ? turn = Turn2.player2 : turn = Turn2.player1;

  List<int> get movesRemaining {
    List<int> remaining = [];

    for (int i = 0; i < places.length; i++) {
      if (places[i].contains('')) {
        remaining.add(i);
      }
    }

    return remaining;
  }

  void reset() {
    player1.movesPlayed.clear();
    player2.movesPlayed.clear();
    winKey.clear();

    for (int i = 0; i < places.length; i++) {
      places[i] = '';
    }
  }
}

enum GameStatus {
  movesAvailable,
  move_unavailable,
  move_played,
  player1Won,
  player2Won,
  draw,
  invalid_move,
}
