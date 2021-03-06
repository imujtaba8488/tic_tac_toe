import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/pages/leader_board_page.dart';

import '../boards/board.dart';
import '../scoped_models/game_model.dart';
import '../models/app_theme.dart';
import '../components/score_board.dart';
import 'statistics_page.dart';
import '../components/game_over_board.dart';

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
            backgroundColor: gameModel.theme.backgroundColor,
            actions: <Widget>[
              Tooltip(
                message: 'Exit',
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: gameModel.theme.decoration,
                  child: IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () => SystemNavigator.pop(),
                  ),
                ),
              ),
              Tooltip(
                message: 'Leaderboard',
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: gameModel.theme.decoration,
                  child: IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LeaderBoardPage()),
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: 'Statistics',
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: gameModel.theme.decoration,
                  child: IconButton(
                    icon: Icon(Icons.data_usage),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StatisticsPage()),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: gameModel.theme.decoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _themeSelector(Colors.grey, Themes.grey, gameModel),
                    _themeSelector(
                      Colors.deepOrange,
                      Themes.deep_orange,
                      gameModel,
                    ),
                    _themeSelector(
                      Colors.deepPurple,
                      Themes.deep_purple,
                      gameModel,
                    ),
                  ],
                ),
              ),
              Tooltip(
                message: gameModel.disableSoundEffects ? 'Unmute' : 'Mute',
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: gameModel.theme.decoration,
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
              ),
            ],
          ),
          backgroundColor: gameModel.theme.backgroundColor,
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

  /// Selects the theme based on the given properties. // ? Should you extract this into its own file as a separate widget?
  Widget _themeSelector(
    Color color,
    Themes themeSelected,
    GameModel gameModel,
  ) {
    return InkWell(
      child: Tooltip(
        message: selectedTheme == Themes.grey
            ? 'Neomorphic Grey'
            : selectedTheme == Themes.deep_orange
                ? 'Neomorphic Deep Orange'
                : 'Neomorphic Deep Purple',
        child: Container(
          margin: EdgeInsets.all(5),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: selectedTheme == themeSelected
                ? Border.all(color: Colors.white)
                : null,
          ),
        ),
      ),
      onTap: () {
        if (themeSelected == Themes.deep_orange) {
          gameModel.theme = Neomorphic(color: Colors.deepOrange);
          setState(() {
            selectedTheme = themeSelected;
          });
        } else if (themeSelected == Themes.deep_purple) {
          gameModel.theme = Neomorphic(color: Colors.blue[900]);
          setState(() {
            selectedTheme = themeSelected;
          });
        } else {
          gameModel.theme = Neomorphic(color: Colors.grey);
          setState(() {
            selectedTheme = themeSelected;
          });
        }
      },
    );
  }
}
