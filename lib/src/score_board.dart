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
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  'Player',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 10),
                Text('${widget.playerScore}'),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  'AI',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 10),
                Text('${widget.aiScore}')
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  'Draw',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 10),
                Text('${widget.draws}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
