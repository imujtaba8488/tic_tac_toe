import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_page.dart';
import '../scoped_models/game_model.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        return Scaffold(
          backgroundColor: gameModel.theme.backgroundColor,
          body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Just T3',
                    style: gameModel.theme.gameOverTextStyle,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.0,
                    height: MediaQuery.of(context).size.height / 2.0,
                    child: CustomPaint(
                      painter: GameIdentityPainter(gameModel),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      // String name = '';
                      // await gameModel.login().then((value){
                      //   name = value.displayName;
                      // });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: Text('Login'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'copyright @ IM8488 (2020). All rights reserved.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class GameIdentityPainter extends CustomPainter {
  GameModel gameModel;

  GameIdentityPainter(this.gameModel);

  @override
  void paint(Canvas canvas, Size size) {
    drawBoard(canvas, size);
    drawMoves(canvas, size);

    canvas.drawLine(
      Offset(0.0, size.height / 1.4),
      Offset(size.width, size.height / 7.5),
      Paint()
        ..color = Colors.yellow
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Draws the play board.
  void drawBoard(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0.0, size.height / 3.0),
      Offset(size.width, size.height / 3.0),
      defaultBrush,
    );

    canvas.drawLine(
      Offset(0.0, size.height / 2.0),
      Offset(size.width, size.height / 2.0),
      defaultBrush,
    );

    canvas.drawLine(
      Offset(size.width / 3.0, size.height / 6.5),
      Offset(size.width / 3.0, size.height / 1.5),
      defaultBrush,
    );

    canvas.drawLine(
      Offset(size.width / 1.5, size.height / 6.5),
      Offset(size.width / 1.5, size.height / 1.5),
      defaultBrush,
    );
  }

  /// The default paint brush to use for painting the items.
  Paint get defaultBrush {
    return Paint()
      ..color = gameModel.theme.iconColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
  }

  /// Draws all the moves.
  void drawMoves(Canvas canvas, Size size) {
    drawMove(
      canvas,
      'X',
      Size(size.width / 16, size.height / 8),
    );

    drawMove(
      canvas,
      '0',
      Size(size.width / 2.5, size.height / 8),
    );

    drawMove(
      canvas,
      'X',
      Size(size.width / 1.3, size.height / 8),
    );

    drawMove(
      canvas,
      'X',
      Size(size.width / 2.5, size.height / 3.2),
    );

    drawMove(
      canvas,
      'X',
      Size(size.width / 16, size.height / 2),
    );

    drawMove(
      canvas,
      '0',
      Size(size.width / 1.3, size.height / 2),
    );
  }

  /// Draws a single move with the given [text] at a given place calculated using the [size].
  void drawMove(Canvas canvas, String text, Size at) {
    TextPainter textPainter = getTextPainterFor(text);

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(at.width, at.height),
    );
  }

  /// Gets a text painter for the given [text].
  TextPainter getTextPainterFor(String text) {
    return TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: gameModel.theme.moveTextStyleMonoton,
      ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
