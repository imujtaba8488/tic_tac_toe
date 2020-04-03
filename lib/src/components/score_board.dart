import 'package:flutter/material.dart';

class ScoreBoard extends StatefulWidget {
  final int playerScore, aiScore, draws;

  ScoreBoard(this.playerScore, this.aiScore, this.draws);

  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(10),
      // decoration: BoxDecoration(
      //   color: Colors.deepPurple,
      //   borderRadius: BorderRadius.circular(10),
      //   border: Border.all(color: Colors.green, width: 5),
      // ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: scoreCard('Player', widget.playerScore.toString()),
          ),
          Expanded(
            child: scoreCard('AI', widget.aiScore.toString()),
          ),
          Expanded(
            child: scoreCard('Draws', widget.draws.toString()),
          ),
        ],
      ),
    );
  }

  Widget scoreCard(String title, String score) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.green,
            ),
          ),
          SizedBox(height: 10),
          Text(score),
        ],
      ),
    );
  }
}
