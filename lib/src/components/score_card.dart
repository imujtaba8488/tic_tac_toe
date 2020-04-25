import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/scoped_models/game_model.dart';

import 'package:augmentory/augmentory.dart';

class ScoreCard extends StatelessWidget {
  final String label;
  final int score;

  ScoreCard(this.label, this.score);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        return Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Tooltip(
                  message: label.containsIgnoreCase('ai')
                      ? 'AI Score'
                      : label.containsIgnoreCase('draws')
                          ? 'Draws'
                          : 'Your Score',
                  child: Icon(
                    label.containsIgnoreCase('ai')
                        ? Icons.computer
                        : label.containsIgnoreCase('Draws')
                            ? Icons.close
                            : Icons.person,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                score.toString(),
              ),
            ],
          ),
        );
      },
    );
  }
}
