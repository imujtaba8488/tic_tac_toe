import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './theme.dart';

class TicTacToe extends StatefulWidget {
  TicTacToe({Key key}) : super(key: key);

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<String> moves = List(9);

  bool playerPlayed = false;
  int movesPlayed = 0;

  int playerLastMoveIndex;

  @override
  void initState() {
    moves.fillRange(0, 9, '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme().theme.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: 9,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                onMove(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Center(
                  child: Text(moves[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void onMove(int index) {
    // for now consider player is going to play first.

    setState(() {
      moves[index] = '0';
      movesPlayed++;

      playerLastMoveIndex = index;

      playerPlayed = true;

      if (checkWon()) {
        for (int i = 0; i < moves.length; i++) {
          moves[i] = '';
        }

        print('You won!');
      } else {
        if (playerPlayed) {
          autoAiPlay();
        }
      }
    });
  }

  void autoAiPlay() {
    setState(() {
      
      aiPlay(nextAvailableSpot(playerLastMoveIndex));

      playerPlayed = false;
    });
  }

  int nextAvailableSpot(int lastMoveIndex) {
    int availableSpot;

    for (int i = 0; i < moves.length; i++) {
      if (i != lastMoveIndex) {
        if(moves[i] == '') {
          availableSpot = i;
          break;
        }
      }
    }
    return availableSpot;
  }

  void aiPlay(int index) {
    moves[index] = 'x';
  }

  bool checkWon() {
    if (moves[0] == '0' && moves[1] == '0' && moves[2] == '0') {
      return true;
    } else if (moves[3] == '0' && moves[4] == '0' && moves[5] == '0') {
      return true;
    } else if (moves[6] == '0' && moves[7] == '0' && moves[8] == '0') {
      return true;
    } else {
      return false;
    }
  }
}
