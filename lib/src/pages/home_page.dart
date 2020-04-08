import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../boards/board.dart';
import '../scoped_models/game_model.dart';
import '../components/game_over.dart';
import '../models/app_theme.dart';

enum ThemeSelected {
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
  ThemeSelected selectedTheme = ThemeSelected.grey;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, model) {
        gameModel = model;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: gameModel.theme.backgroundColor,
            actions: <Widget>[
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: gameModel.theme.decoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _themeSelector(Colors.grey, ThemeSelected.grey, gameModel),
                    _themeSelector(Colors.deepOrange, ThemeSelected.deep_orange,
                        gameModel),
                    _themeSelector(Colors.deepPurple, ThemeSelected.deep_purple,
                        gameModel),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                decoration: gameModel.theme.decoration,
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
              ),
            ],
          ),
          backgroundColor: gameModel.theme.backgroundColor,
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// This will be called after the widget has been completely rendered. Hence, the '_' in the parenthesis. // todo: Learn about underscore in paranthesis later on.
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

      // case StatusChange.error_next_move_unavailable:
      //   showGameOverDialog(context, gameModel.statusChange);
      //   break;

      default:
        break;
    }
  }

  /// Selects the theme based on the given properties. // ? Should you extract this into its own file as a separate widget? 
  Widget _themeSelector(
    Color color,
    ThemeSelected themeSelected,
    GameModel gameModel,
  ) {
    return InkWell(
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
      onTap: () {
        if (themeSelected == ThemeSelected.deep_orange) {
          gameModel.theme = Neomorphic(color: Colors.deepOrange);
          setState(() {
            selectedTheme = themeSelected;
          });
        } else if (themeSelected == ThemeSelected.deep_purple) {
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
