import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/game_board.dart';
import 'package:tic_tac_toe/src/game_over.dart';
import 'package:tic_tac_toe/src/player.dart';
import 'package:tic_tac_toe/src/scoped_models/game_model.dart';
import 'package:tic_tac_toe/src/sound_effect.dart';
import 'package:tic_tac_toe/src/theme.dart';

import './src/game_board.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final GameModel gameModel = GameModel(
    Player(name: 'user', mark: 'X', moveSoundEffect: SoundEffect.userMove),
    Player(name: 'AI', mark: '0', moveSoundEffect: SoundEffect.aiMove),
    Turn.player1,
    disableSoundEffects: true,
  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: MyTheme().theme,
      home: ScopedModel(
        model: gameModel,
        child: GameBoard(),
      ),
    );
  }
}

void showGameOver(
  BuildContext context,
  String message, {
  Function onPressed,
  String buttonText = 'Play Again',
}) {
  showDialog(
    context: context,
    child: GameOver(message, onPressed: onPressed, buttonText: buttonText),
  );
}
