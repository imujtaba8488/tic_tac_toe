import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/boards/board_theme.dart';

import '../scoped_models/game_model.dart';
import 'score_card.dart';

class ScoreBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        return Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(5),
          decoration: NeomorphicConcave(Colors.deepOrange).decoration,
          // decoration: BoxDecoration(
          //   color: Colors.grey,
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.grey.shade100,
          //       offset: Offset(-1, -1),
          //       blurRadius: 2,
          //     ),
          //     BoxShadow(
          //       color: Colors.grey.shade900,
          //       offset: Offset(1, 1),
          //       blurRadius: 2,
          //     )
          //   ],
          //   borderRadius: BorderRadius.circular(5),
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // ScoreCard(gameModel.player1.name, gameModel.player1.score.wins),
              // ScoreCard(gameModel.player2.name, gameModel.player2.score.wins),
              // ScoreCard('Draws', gameModel.draws),
            ],
          ),
        );
      },
    );
  }
}


