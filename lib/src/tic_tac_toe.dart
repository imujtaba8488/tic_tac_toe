import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import './theme.dart';
import 'gameover.dart';

enum Turn { player, ai }
enum Winner { player, ai, draw, none }

class TicTacToe extends StatefulWidget {
  TicTacToe({Key key}) : super(key: key);

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  final List<String> totalMoves = List(9);
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  final List<int> playerMoveIndices = List();
  final List<int> aiMovesIndices = List();
  Turn turn;
  Winner winner;
  String playerMark = 'X', aiMark = '0';
  int playerScore = 0;
  int aiScore = 0;

  @override
  void initState() {
    totalMoves.fillRange(0, 9, '');
    turn = Turn.player;
    winner = Winner.none;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // If it's ai's turn, play ai's turn.
    if (!hasWon()) {
      if (turn == Turn.ai) {
        Future.delayed(const Duration(seconds: 1), () {
          aiPlay();
        });
      }
    }

    return Scaffold(
      backgroundColor: MyTheme().theme.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Text(totalMoves[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
            Text('Player Score: $playerScore'),
            Text('AI Score: $aiScore'),
            Divider(
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
