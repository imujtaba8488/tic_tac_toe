import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import './theme.dart';

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
  final List<int> playerMoves = List();
  final List<int> aiMoves = List();
  Turn turn;
  String playerMark = 'X', aiMark = '0';

  @override
  void initState() {
    totalMoves.fillRange(0, 9, '');
    turn = Turn.player;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (turn == Turn.ai) {
      aiAutoPlay();
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
                    onTap: () {
                      playMove(index);
                    },
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
            Divider(
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }

  void playMove(int at) {
    if (movesLeft.length > 0) {
      if (turn == Turn.player) {
        setState(() {
          totalMoves[at] = playerMark;
          playerMoves.add(at);
          turn = Turn.ai;
        });
      } else {
        setState(() {
          totalMoves[at] = aiMark;
          aiMoves.add(at);
          turn = Turn.player;
        });
      }
    } else {
      // Review: Decide winner or draw.
    }
  }

  void aiAutoPlay() {
    if (movesLeft.length > 0) {
      movesLeft.shuffle();

      Random random = Random();
      bool gotNextMove = false;
      int nextMove = 0;

      while (gotNextMove != true) {
        nextMove = random.nextInt(movesLeft.length);
        if (isMoveAvailable(nextMove)) {
          gotNextMove = true;
          break;
        }
      }

      playMove(nextMove);
    } else {
      // Review: Decide winner or draw.
    }
  }

  bool isMoveAvailable(int at) => totalMoves[at].isEmpty;

  // Returns the number of moves that are left to play.
  List<int> get movesLeft {
    List<int> remainingMoves = List();

    // Check for empty element in totalMoves and add that to remainingMoves.
    for (int i = 0; i < totalMoves.length; i++) {
      if (totalMoves[i].isEmpty) {
        remainingMoves.add(i);
      }
    }

    return remainingMoves;
  }
}
