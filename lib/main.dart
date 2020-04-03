import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './src/scoped_models/game_model.dart';
import './src/models/player.dart';
import './src/pages/home_page.dart';
import './src/models/theme.dart';

void main() => runApp(TicTacToe());

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: GameModel(
        Player(name: 'user', mark: 'X'),
        Player(name: 'ai', mark: '0'),
        Turn.player1,
        disableSoundEffects: true,
      ),
      child: MaterialApp(
        theme: MyTheme().theme,
        home: Scaffold(
          body: HomePage(),
        ),
      ),
    );
  }
}
