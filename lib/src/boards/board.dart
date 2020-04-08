import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/game_model.dart';

class Board extends StatefulWidget {
  /// Action to be taken when the gameStatus changes.
  final Function onGameStatusChange;

  Board(this.onGameStatusChange);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        // GameOverAlert may be displayed based on the gameStatus only when the current widget has completely rendered itself, otherwise, displaying an alert based on the gameStatus during the build of this widget results in an error.
        WidgetsBinding.instance.addPostFrameCallback(widget.onGameStatusChange);

        // Creates a 3x3 grid.
        return GridView.builder(
          itemCount: 9,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                gameModel.playMove(index);
              },
              child: Container(
                margin: EdgeInsets.all(5.0),
                decoration: gameModel.theme.decoration,
                child: Center(
                  child: Text(
                    gameModel.moves[index],
                    style: gameModel.theme.moveTextStyleBlackHansSans,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
