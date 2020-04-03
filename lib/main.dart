import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './src/scoped_models/game_model.dart';
import './src/player.dart';
import './src/game_over.dart';
import './src/boards/super_white_board.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameModel gameModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScopedModel(
        model: gameModel = GameModel(
          Player(name: 'user', mark: 'X'),
          Player(name: 'ai', mark: '0'),
          Turn.player1,
          disableSoundEffects: true,
        ),
        child: Scaffold(
          body: SuperWhiteBoard(),
        ),
      ),
    );
  }

  void _onGameStatusChange(StatusChange statusChange, Function reset) {
    print('calling onGameStatusChange....');

    switch (statusChange) {
      case StatusChange.draw:
        _showGameOverDialog('Draw', reset);
        break;

      case StatusChange.player1_won:
        _showGameOverDialog('${gameModel.player1.name} has won', reset);
        break;

      case StatusChange.player1_won:
        _showGameOverDialog('${gameModel.player2.name} has won', reset);
        break;

      case StatusChange.error_next_move_unavailable:
        _showGameOverDialog(
          'error: move not valid.',
          () {
            Navigator.pop(context);
          },
          buttonText: 'OK',
        );
        break;

      default:
        break;
    }
  }

  void _showGameOverDialog(String message, Function reset,
      {String buttonText}) {
    print('show dialog');
    showDialog(
      context: context,
      child: GameOver(
        message,
        onPressed: reset,
      ),
    );
  }
}
