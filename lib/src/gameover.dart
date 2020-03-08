import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  final String message;
  final Function onPlayAgain;

  GameOver(this.message, this.onPlayAgain);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$message'),
      actions: <Widget>[
        RaisedButton(
          onPressed: onPlayAgain,
          child: Text('Play Again'),
        )
      ],
    );
  }
}
