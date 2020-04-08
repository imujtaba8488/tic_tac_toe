import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/components/score_card.dart';

import '../scoped_models/game_model.dart';

class ScoreBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        return Container(
          // decoration: gameModel.theme.decoration,
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ScoreCard(
                  gameModel.player1.name, gameModel.player1.currentScore.wins),
              ScoreCard(
                  gameModel.player2.name, gameModel.player2.currentScore.wins),
              ScoreCard('Draws', gameModel.draws),
            ],
          ),
        );
      },
    );
  }
}
