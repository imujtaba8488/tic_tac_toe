import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../boards/board.dart';
import '../scoped_models/game_model.dart';
import '../components/score_board.dart';
import 'statistics_page.dart';
import '../components/game_over_board.dart';
import 'leaderboard_page.dart';

/// Describes the themes that are available for the app.
enum Themes {
  grey,
  deep_orange,
  deep_purple,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameModel gameModel;
  Themes selectedTheme = Themes.grey;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, model) {
        gameModel = model;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Tooltip(
                message: 'Leaderboard',
                child: IconButton(
                  icon: Icon(
                    Icons.star,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeaderBoardPage(),
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: 'Statistics',
                child: IconButton(
                  icon: Icon(Icons.data_usage),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatisticsPage(),
                    ),
                  ),
                ),
              ),
              
              Tooltip(
                message: gameModel.disableSoundEffects ? 'Unmute' : 'Mute',
                child: IconButton(
                  icon: gameModel.disableSoundEffects
                      ? Icon(Icons.volume_off)
                      : Icon(Icons.volume_mute),
                  onPressed: () {
                    setState(
                      () => gameModel.disableSoundEffects =
                          !gameModel.disableSoundEffects,
                    );
                  },
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Scoreboard.
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: ScoreBoard(),
                ),

                // Actual playboard.
                Container(
                  padding: EdgeInsets.all(15.0),
                  height: MediaQuery.of(context).size.height / 1.9,
                  child: Board(),
                ),

                // GameOver response system.
                gameModel.statusChange == StatusChange.draw ||
                        gameModel.statusChange == StatusChange.player1_won ||
                        gameModel.statusChange == StatusChange.player2_won
                    ? Padding(
                        padding: EdgeInsets.all(15.0),
                        child: GameOverBoard(),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}
