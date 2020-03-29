import 'dart:math';

import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/game.dart';
import 'package:tic_tac_toe/src/player.dart';
import 'package:tic_tac_toe/src/win_possibilities.dart';

class GameSession extends Model {
  Player user, ai;
  Game game;
  GameStatus gameStatus;
  Function _onGameStatusChange;

  GameSession(this._onGameStatusChange) {
    user = Player(name: 'user', mark: 'X');
    ai = Player(name: 'ai', mark: '0');
    game = Game(user, ai, Turn2.player1);
  }

  void playMove(int at) {
    gameStatus = game.playMove(at);
    checkGameStatus();

    // When AI play is activated.
    if (game.turn == Turn2.player2) {
      if (gameStatus != GameStatus.draw) {
        if (gameStatus != GameStatus.player1Won) {
          aiPlay();
        }
      }
    }
    notifyListeners();
  }

  void aiPlay() {
    if (isWinPossible(ai.movesPlayed, game.places) >= 0) {
      playMove(isWinPossible(ai.movesPlayed, game.places));
    } else if (isWinPossible(user.movesPlayed, game.places) >= 0) {
      playMove(isWinPossible(user.movesPlayed, game.places));
    } else {
      playRandomMove();
    }
  }

  void playRandomMove() {
    game.movesRemaining.shuffle();
    playMove(game.movesRemaining[Random().nextInt(game.movesRemaining.length)]);
  }

  void _resetGame() {
    game.reset();

    // Play AI's turn, if after reset it is the AI's turn.
    if (game.turn == Turn2.player2) {
      aiPlay();
    }

    notifyListeners();
  }

  void checkGameStatus() {
    switch (gameStatus) {
      case GameStatus.player1Won:
        _onGameStatusChange('user won.', onPressed: _resetGame);
        break;

      case GameStatus.player2Won:
        _onGameStatusChange('ai won.', onPressed: _resetGame);
        break;

      case GameStatus.draw:
        _onGameStatusChange('Its a draw.', onPressed: _resetGame);
        break;

      case GameStatus.move_unavailable:
        _onGameStatusChange('Error: Move not available', buttonText: 'OK');
        break;

      case GameStatus.invalid_move:
        print('error: invalid move');
        break;

      default:
        print('move played');
        break;
    }
  }
}
