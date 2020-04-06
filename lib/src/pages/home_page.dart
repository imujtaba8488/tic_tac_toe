import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../boards/board.dart';
import '../scoped_models/game_model.dart';
import '../components/game_over.dart';
import '../boards/board_theme.dart';
import '../components/score_board.dart';

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

        return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: NeomorphicGrey().decoration,
                child: IconButton(
                  icon: gameModel.disableSoundEffects
                      ? Icon(Icons.volume_off)
                      : Icon(Icons.volume_mute),
                  onPressed: () {
                    setState(() {
                      gameModel.disableSoundEffects =
                          !gameModel.disableSoundEffects;
                    });
                  },
                ),
              )
            ],
          ),
          backgroundColor: Colors.grey,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ScoreBoard(),
                // ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Board(
                    _onGameStatusChange,
                    theme: NeomorphicGrey(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Remember this is going to be called after the widget is completely rendered, hence, the underscore in the parenthesis. Probably learn what it is.
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
