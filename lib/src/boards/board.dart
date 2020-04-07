import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/game_model.dart';
import 'board_theme.dart';

class Board extends StatefulWidget {
  /// Action to be taken when the gameStatus changes.
  final Function onGameStatusChange;

  /// The theme which is to be applied to the current board.
  final BoardTheme theme;

  Board(this.onGameStatusChange, {this.theme});

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  double borderWidth = 2.0;
  BoxDecoration decoration;
  GameModel gameModel;

  @override
  void initState() {
    decoration = widget.theme.decoration;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, model) {
        gameModel = model;

        // Alert may be displayed based on the gameStatus only when the current widget has completely rendered itself, otherwise, displaying an alert based on the gameStatus during the build of this widget results in an error.
        WidgetsBinding.instance.addPostFrameCallback(widget.onGameStatusChange);

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
              // onTapDown: onTapDown,
              // onTapUp: onTapUp,
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 3,
                margin: EdgeInsets.all(5.0),
                decoration: decoration,
                child: Center(
                  child: Text(
                    gameModel.moves[index],
                    style: widget.theme.textStyle,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void onTapDown(TapDownDetails tapDownDetails) {
    print('inside tap down');
    setState(() {
      decoration = NeomorphicConcave(widget.theme.color).noShadowDecoration;
    });
  }

  void onTapUp(TapUpDetails tapUpDetails) {
    setState(() {
      decoration = widget.theme.decoration;
    });
  }
}
