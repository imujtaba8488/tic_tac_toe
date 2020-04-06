import 'package:flutter/material.dart';
import 'package:tic_tac_toe/src/boards/board_theme.dart';

class ScoreCard extends StatelessWidget {
  final String label;
  final int score;

  ScoreCard(this.label, this.score);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(15),
          decoration: NeomorphicConcave(Colors.orange).decoration,
          // decoration: BoxDecoration(
          //   color: Colors.grey[500],
          //   gradient: LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //       colors: [
          //         Colors.grey[300],
          //         Colors.grey[600],
          //       ]),
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
          child: Column(
            children: <Widget>[
              Text(
                label,
                style: TextStyle(fontSize: 16),
              ),
              Text(score.toString()),
            ],
          ),
        );
      },
    );
  }
}
