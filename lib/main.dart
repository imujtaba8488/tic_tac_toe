import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/models/sound_effect_player.dart';

import './src/models/player.dart';
import './src/pages/login_page.dart';
import './src/scoped_models/game_model.dart';

void main() => runApp(TicTacToe());

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: GameModel(
        Player(name: '', mark: 'X', moveSoundEffect: SoundEffect.userMove),
        Player(name: 'AI', mark: '0', moveSoundEffect: SoundEffect.aiMove),
        Turn.player1,
        disableSoundEffects: true,
      ),
      child: MaterialApp(
        home: LoginPage(),
      ),
    );
  }
}
