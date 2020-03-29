import 'package:flutter/material.dart';

import 'package:augmentory/augmentory.dart';

class GameOver extends StatelessWidget {
  final String message;
  final Function onPressed;
  final String buttonText;

  GameOver(this.message, {this.onPressed, this.buttonText = 'Play Again'});

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
          onPressed: () {
            onPressed != null? onPressed() : print('');
            Navigator.pop(context);
          },
          child: Text(buttonText),
        )
      ],
    );
  }
}
