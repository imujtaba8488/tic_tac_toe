import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../boards/super_white_board.dart';
import '../scoped_models/game_model.dart';
import '../components/game_over.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameModel gameModel;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, model) {
        gameModel = model;
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5.0),
              height: MediaQuery.of(context).size.height / 1.5,
              child: SuperWhiteBoard(_onGameStatusChange),
            ),
          ],
        );
      },
    );
  }

  void _onGameStatusChange(_) {
    switch (gameModel.statusChange) {
      case StatusChange.draw:
        showGameOverDialog(context, gameModel.statusChange);
        break;

      case StatusChange.player1_won:
        showGameOverDialog(context, gameModel.statusChange);
        break;

      case StatusChange.player2_won:
        showGameOverDialog(context, gameModel.statusChange);
        break;

      case StatusChange.error_next_move_unavailable:
        showGameOverDialog(context, gameModel.statusChange);
        break;

      default:
        break;
    }
  }
}
