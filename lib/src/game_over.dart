import 'package:flutter/material.dart';

import 'package:augmentory/augmentory.dart';

class GameOver extends StatelessWidget {
  final String message;
  final Function onPlayAgain;

  GameOver(this.message, this.onPlayAgain);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: ListTile(
        title: message.containsIgnoreCase('draw')
            ? Text('Phew!')
            : message.containsIgnoreCase('ai')
                ? Text('Better Luck Next time!!')
                : Text('Congratulations!!!'),
        subtitle: Text(message),
      ),
      actions: <Widget>[
        RaisedButton(
          onPressed: onPlayAgain,
          child: Text('Play Again'),
        )
      ],
    );
  }
}
