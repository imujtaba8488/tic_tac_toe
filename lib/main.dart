import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/pages/home_page.dart';

import './src/scoped_models/game_model.dart';
import './src/models/player.dart';
import './src/pages/login_page.dart';
import './src/models/app_theme.dart';

void main() => runApp(TicTacToe());

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: GameModel(
        Player(name: 'You', mark: 'X'),
        Player(name: 'AI', mark: '0'),
        Turn.player1,
        theme: Neomorphic(),
      ),
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}