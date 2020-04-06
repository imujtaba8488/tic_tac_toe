import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/game_model.dart';
import 'board_theme.dart';

class SuperWhiteBoard extends StatefulWidget {
  // What to do when the game status changes.
  final Function onGameStatusChange;
  final BoardTheme theme;

  SuperWhiteBoard(this.onGameStatusChange, {this.theme});

  @override
  _SuperWhiteBoardState createState() => _SuperWhiteBoardState();
}

class _SuperWhiteBoardState extends State<SuperWhiteBoard> {
  double borderWidth = 2.0;
  BoxDecoration decoration;
  GameModel gameModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, model) {
        gameModel = model;

        // Do layout everything first, then display an alert, if required.
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
                margin: EdgeInsets.all(1.0),
                decoration: widget.theme.decoration,
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
    setState(() {
      decoration = BoxDecoration(
        border: Border.all(
          width: 5,
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(3.0),
      );
    });
  }

  void onTapUp(TapUpDetails tapUpDetails) {
    setState(() {
      decoration = null;
    });
  }
}
