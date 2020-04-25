import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/game_model.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  double value = 1.0;

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this)
          ..addListener(() {
            setState(() {
              value = animation.value;
            });
          });

    animation = Tween(begin: 0.0, end: 1.0).animate(controller);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        // In case a GameOverAlert needs to be displayed based on the game Status only when the current widget has completely rendered itself, otherwise, displaying an alert based on the game Status during the build of this widget results in an error. This is what needs to be put here 'WidgetsBinding.instance.addPostFrameCallback(widget.onGameStatusChange)'

        // Create a 3x3 grid.
        return CustomPaint(
          foregroundPainter: StatusChangePainter(gameModel, value),
          child: GridView.builder(
            itemCount: 9,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // Checking for StatusChange helps in that as soon as the StatusChange changes from 'none' or 'error_next_move_unavailable' to any other StatusChange, any further user input is discarded. Without this check, though user couldn't change anything, but the score still updated. Hence, it prevents any unforeseen consequences. Also, remember, 'error_next_move_unavailable' simply hints the user that the move is not available to play.
                  if (gameModel.statusChange == StatusChange.none ||
                      gameModel.statusChange ==
                          StatusChange.error_next_move_unavailable)
                    gameModel.playMove(index);
                },
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  child: Center(
                    child: Text(
                      gameModel.moves[index],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Draws the lines / guides to intimate the user that the game is over by specifying the move list which resulted in the win.
class StatusChangePainter extends CustomPainter {
  GameModel _gameModel;
  double value;

  StatusChangePainter(this._gameModel, this.value);

  @override
  void paint(Canvas canvas, Size size) {
    if (_gameModel.winKey.contains(0) &&
        _gameModel.winKey.contains(1) &&
        _gameModel.winKey.contains(2)) {
      canvas.drawLine(
        Offset(0.0, size.height / 6.0),
        Offset(size.width * value, size.height / 6.0),
        brush,
      );
    } else if (_gameModel.winKey.contains(3) &&
        _gameModel.winKey.contains(4) &&
        _gameModel.winKey.contains(5)) {
      canvas.drawLine(
        Offset(0.0, size.height / 2.0),
        Offset(size.width * value, size.height / 2.0),
        brush,
      );
    } else if (_gameModel.winKey.contains(6) &&
        _gameModel.winKey.contains(7) &&
        _gameModel.winKey.contains(8)) {
      canvas.drawLine(
        Offset(0.0, size.height / 1.2),
        Offset(size.width * value, size.height / 1.2),
        brush,
      );
    } else if (_gameModel.winKey.contains(0) &&
        _gameModel.winKey.contains(3) &&
        _gameModel.winKey.contains(6)) {
      canvas.drawLine(
        Offset(size.width / 6.27, 0.0),
        Offset(size.width / 6.27, size.height * value),
        brush,
      );
    } else if (_gameModel.winKey.contains(1) &&
        _gameModel.winKey.contains(4) &&
        _gameModel.winKey.contains(7)) {
      canvas.drawLine(
        Offset((size.width / 2.0) * value, 0.0),
        Offset(size.width / 2.0, size.height * value),
        brush,
      );
    } else if (_gameModel.winKey.contains(2) &&
        _gameModel.winKey.contains(5) &&
        _gameModel.winKey.contains(8)) {
      canvas.drawLine(
        Offset((size.width / 1.2) * value, 0.0),
        Offset(size.width / 1.2, size.height * value),
        brush,
      );
    } else if (_gameModel.winKey.contains(0) &&
        _gameModel.winKey.contains(4) &&
        _gameModel.winKey.contains(8)) {
      canvas.drawLine(
        Offset(0.0, 0.0),
        Offset(size.width, size.height * value),
        brush,
      );
    } else if (_gameModel.winKey.contains(2) &&
        _gameModel.winKey.contains(4) &&
        _gameModel.winKey.contains(6)) {
      canvas.drawLine(
        Offset(size.width, 0.0),
        Offset(0.0, size.height * value),
        brush,
      );
    }
  }

  Paint get brush => Paint()
    ..strokeWidth = 5
    ..strokeCap = StrokeCap.round
    ..color = Colors.yellow;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
