import 'package:flutter/material.dart';

import 'game_logic.dart';

class PurpleBoard extends StatelessWidget {
  final GameLogic gameLogic;
  final int playAt;

  PurpleBoard(this.gameLogic, this.playAt);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        border: Border.all(
          width: 6,
          color: Colors.green,
        ),
        boxShadow: [BoxShadow()],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(gameLogic.movesPlayed[playAt]),
      ),
    );
  }
}
