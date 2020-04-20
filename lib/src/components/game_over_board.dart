import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/game_model.dart';

class GameOverBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        return Container(
          decoration: gameModel.theme.decoration,
          child: ListTile(
            title: Text(
              'GameOver...',
              style: gameModel.theme.gameOverTextStyle,
            ),
            subtitle: gameResult(gameModel),
            trailing: Container(
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: gameModel.theme.backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 1.0,
                    offset: Offset(-0.5, -0.5)

                  ),
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 1.0,
                    offset: Offset(0.5, 0.5),
                  ),
                ],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: FlatButton(
                onPressed: () => gameModel.reset(),
                child: Text(
                  'Play Again?',
                  style: gameModel.theme.buttonTextStyle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Text gameResult(GameModel gameModel) {
    switch (gameModel.statusChange) {
      case StatusChange.draw:
        return Text(
          'It\'s a draw',
          style: TextStyle(color: Colors.white),
        );

      case StatusChange.player1_won:
        return Text(
          'You won!',
          style: TextStyle(color: Colors.white),
        );

      case StatusChange.player2_won:
        return Text(
          'AI won. Better luck next time.',
          style: TextStyle(color: Colors.white),
        );

      default:
        return null;
    }
  }
}
