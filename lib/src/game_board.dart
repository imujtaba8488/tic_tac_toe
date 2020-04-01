import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/scoped_models/game_model.dart';

import 'board_themes/super_white.dart';
import 'theme.dart';

class GameBoard extends StatefulWidget {
  GameBoard({Key key}) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  bool showProgressIndicator = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        return Scaffold(
          backgroundColor: MyTheme().theme.primaryColor,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                gameModel.isAiThinking
                    ? Column(
                        children: <Widget>[
                          Text('I am thinking. hold on'),
                          CircularProgressIndicator(),
                        ],
                      )
                    : Container(),
                // ScoreBoard(playerScore, aiScore, draws),
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return SuperWhite(index);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
