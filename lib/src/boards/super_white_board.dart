import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/scoped_models/game_model.dart';

class SuperWhiteBoard extends StatefulWidget {
  SuperWhiteBoard();

  @override
  _SuperWhiteBoardState createState() => _SuperWhiteBoardState();
}

class _SuperWhiteBoardState extends State<SuperWhiteBoard> {
  double borderWidth = 2.0;
  BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        return GridView.builder(
          itemCount: 9,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => gameModel.playMove(index),
              onTapDown: onTapDown,
              onTapUp: onTapUp,
              child: Container(
                height: MediaQuery.of(context).size.height / 1.5,
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
                    decoration: gameModel.winKey.contains(index)
                        ? BoxDecoration(color: Colors.blue)
                        : decoration,
                    child: Center(
                      child: Text(
                        gameModel.moves[index],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
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
