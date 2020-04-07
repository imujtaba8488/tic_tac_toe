import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/game_model.dart';

void showGameOverDialog(BuildContext context, StatusChange statusChange) {
  showDialog(
    context: context,
    barrierDismissible: false,
    child: _GameOverDialog(context, statusChange),
  );
}

class _GameOverDialog extends StatelessWidget {
  final BuildContext _context;
  final StatusChange _statusChange;

  _GameOverDialog(this._context, this._statusChange);

  @override
  Widget build(BuildContext context) {
    // Ignoring the context from the build method.
    GameModel gameModel = ScopedModel.of(_context);

    return AlertDialog(
      backgroundColor: gameModel.theme.backgroundColor,
      content: ListTile(
        title: Text('Game Over'),
        subtitle: _getText(gameModel),
      ),
      actions: <Widget>[
        RaisedButton(
          child: Text('Play Again?'),
          onPressed: () {
            gameModel.reset();
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Widget _getText(GameModel gameModel) {
    switch (_statusChange) {
      case StatusChange.draw:
        return Text('Draw.');

      case StatusChange.player1_won:
        return Text('${gameModel.player1.name} has won.');

      case StatusChange.player2_won:
        return Text('${gameModel.player2.name} has won.');

      case StatusChange.error_next_move_unavailable:
        return Text('error: Move not allowed.');

      default:
        return Text('');  // Temp...
    }
  }
}
