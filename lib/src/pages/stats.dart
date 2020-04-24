import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/models/cloud.dart';
import 'package:tic_tac_toe/src/scoped_models/game_model.dart';

// todo: Things that can be added to this class: Maybe sort wins as per date played. Add more stats like averageTimeTaken to win a game, averageMoveTime, winPercentage, lossPercentage etc.

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        return Scaffold(
          backgroundColor: gameModel.theme.backgroundColor,
          appBar: AppBar(
            backgroundColor: gameModel.theme.backgroundColor,
          ),
          body: ListTile(
            title: Container(
              margin: EdgeInsets.all(15),
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white),
                ),
              ),
              child: Text(
                'ALL TIME SCORE',
                style: gameModel.theme.gameOverTextStyle,
              ),
            ),
            subtitle: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'wins: ${gameModel.player1.lifeTimeScore.wins}',
                  style: gameModel.theme.resultTextStyle,
                ),
                Text(
                  'lost: ${gameModel.player1.lifeTimeScore.loss}',
                  style: gameModel.theme.resultTextStyle,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
