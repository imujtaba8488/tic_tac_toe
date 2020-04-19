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

class _BoardState extends State<Board> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  double value;

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
        // !Mention reason why putting here later ....
        if (gameModel.winKey.length == 3) controller.forward().orCancel;

        // GameOverAlert may be displayed based on the gameStatus only when the current widget has completely rendered itself, otherwise, displaying an alert based on the gameStatus during the build of this widget results in an error.
        WidgetsBinding.instance.addPostFrameCallback(widget.onGameStatusChange);

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
                onTap: () => gameModel.playMove(index),
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
          ),
        );
      },
    );
  }
}

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
        Offset(0.0, size.height / 8.0),
        Offset(size.width * value, size.height / 8.0),
        brush,
      );
    } else if (_gameModel.winKey.contains(3) &&
        _gameModel.winKey.contains(4) &&
        _gameModel.winKey.contains(5)) {
      canvas.drawLine(
        Offset(0.0, size.height / 2.56),
        Offset(size.width * value, size.height / 2.56),
        brush,
      );
    } else if (_gameModel.winKey.contains(6) &&
        _gameModel.winKey.contains(7) &&
        _gameModel.winKey.contains(8)) {
      canvas.drawLine(
        Offset(0.0, size.height / 1.54),
        Offset(size.width * value, size.height / 1.54),
        brush,
      );
    } else if (_gameModel.winKey.contains(0) &&
        _gameModel.winKey.contains(3) &&
        _gameModel.winKey.contains(6)) {
      canvas.drawLine(
        Offset(size.width / 6.27, 0.0),
        Offset(size.width / 6.27, (size.height / 1.27) * value),
        brush,
      );
    } else if (_gameModel.winKey.contains(1) &&
        _gameModel.winKey.contains(4) &&
        _gameModel.winKey.contains(7)) {
      canvas.drawLine(
        Offset((size.width / 2.0) * value, 0.0),
        Offset(size.width / 2.0, (size.height / 1.27) * value),
        brush,
      );
    } else if (_gameModel.winKey.contains(2) &&
        _gameModel.winKey.contains(5) &&
        _gameModel.winKey.contains(8)) {
      canvas.drawLine(
        Offset((size.width / 1.2) * value, 0.0),
        Offset(size.width / 1.2, (size.height / 1.27) * value),
        brush,
      );
    } else if (_gameModel.winKey.contains(0) &&
        _gameModel.winKey.contains(4) &&
        _gameModel.winKey.contains(8)) {
      canvas.drawLine(
        Offset(0.0, 0.0),
        Offset(size.width, (size.height / 1.27) * value),
        brush,
      );
    } else if (_gameModel.winKey.contains(2) &&
        _gameModel.winKey.contains(4) &&
        _gameModel.winKey.contains(6)) {
      canvas.drawLine(
        Offset(size.width, 0.0),
        Offset(0.0, (size.height / 1.27) * value),
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
