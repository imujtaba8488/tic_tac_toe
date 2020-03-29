import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/scoped_models/game_session.dart';

import 'board_themes/super_white.dart';
import 'game_over.dart';
import 'theme.dart';

class GameBoard extends StatefulWidget {
  GameBoard({Key key}) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  GameSession gameSession;

  @override
  void initState() {
    gameSession = GameSession(showGameOver);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: gameSession,
      child: Scaffold(
        backgroundColor: MyTheme().theme.primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              // ScoreBoard(playerScore, aiScore, draws),
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: SuperWhite(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showGameOver(
    String message, {
    Function onPressed,
    String buttonText = 'Play Again',
  }) {
    showDialog(
      context: context,
      child: GameOver(message, onPressed: onPressed, buttonText: buttonText),
    );
  }
}
