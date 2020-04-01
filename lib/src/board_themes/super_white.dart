import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/scoped_models/game_model.dart';

class SuperWhite extends StatefulWidget {
  final int index;

  SuperWhite(this.index);

  @override
  _SuperWhiteState createState() => _SuperWhiteState();
}

class _SuperWhiteState extends State<SuperWhite> {
  double borderWidth = 2.0;
  BoxDecoration decoration;
  GameModel gameModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, game) {
        gameModel = game;

        return GestureDetector(
          onTap: () => gameModel.playMove(widget.index),
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          child: Container(
            margin: EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: borderWidth,
                color: Colors.grey[300],
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Container(
              decoration: game.winKey.contains(widget.index)
                  ? BoxDecoration(color: Colors.blue)
                  : decoration,
              child: Center(
                child: Text(
                  game.moves[widget.index],
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
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
