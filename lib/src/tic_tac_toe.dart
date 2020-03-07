import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import './theme.dart';

class TicTacToe extends StatefulWidget {
  TicTacToe({Key key}) : super(key: key);

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<String> moves = List(9);
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
   
    moves.fillRange(0, 9, '');
    super.initState();
  }

  void showWinner(BuildContext context, String winner) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('$winner'),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                  audioPlayer.stop();
                },
                child: Text('Play again?'),
              )
            ],
          );
        }).then((f){
          clearList();
        });

    // print(winner);
    // clearList();
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
                 audioPlayer.open('assets/audio/move2.mp3');
                audioPlayer.play();
                playerMove(index);
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

  void clearList() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        moves[i] = '';
      }
    });
  }

  checkAndDeclareIfDraw() {
    if (checkPlayerHasWon() == false &&
        checkAIHasWon() == false &&
        !moves.contains('')) {
      
      audioPlayer.open('assets/audio/draw.mp3');
      audioPlayer.play();

      showWinner(context, 'It was a DRAW!!!');

      clearList();
    }
  }

  void playerMove(int index) {
    setState(() {
      if (moves[index] == '') {
        moves[index] = 'X';

        if (moves.contains('')) {
          autoAIPlay();
        }
      }
    });

    if (checkPlayerHasWon()) {
      showWinner(context, 'You have Won!!!');
      audioPlayer.open('assets/audio/won.mp3');
      audioPlayer.play();
    } else if (checkAIHasWon()) {
      declareAIAsWinner();
      audioPlayer.open('assets/audio/lost.mp3');
      audioPlayer.play();
    } else {
      checkAndDeclareIfDraw();
    }
  }

  void declareAIAsWinner() {
    showWinner(context, 'AI has won!!!');
  }

  void autoAIPlay() {
    if (canPlayerWin()) {
      if (canAIWin()) {
        if (moves[aiMayWinAt()] == '') {
          moves[aiMayWinAt()] = '0';
        } else {
          if (moves[playerMayWinAt()] == '') {
            moves[playerMayWinAt()] = '0';
          } else {
            insertAtRandom();
          }
        }
      } else {
        if (moves[playerMayWinAt()] == '') {
          moves[playerMayWinAt()] = '0';
        } else {
          insertAtRandom();
        }
      }
    } else {
      insertAtRandom();
    }
  }

  void insertAtRandom() {
    bool moved = false;

    while (moved != true) {
      Random random = Random();
      int nextMove = random.nextInt(9);

      if (moves[nextMove] == '') {
        moves[nextMove] = '0';
        moved = true;
        break;
      }
    }
  }

  bool canAIWin() {
    return aiMayWinAt() >= 0;
  }

  bool canPlayerWin() {
    return playerMayWinAt() >= 0;
  }

  int playerMayWinAt() {
    if (moves[1] == 'X' && moves[2] == 'X') {
      return 0;
    } else if (moves[0] == 'X' && moves[2] == 'X') {
      return 1;
    } else if (moves[0] == 'X' && moves[1] == 'X') {
      return 2;
    } else if (moves[4] == 'X' && moves[5] == 'X') {
      return 3;
    } else if (moves[3] == 'X' && moves[5] == 'X') {
      return 4;
    } else if (moves[3] == 'X' && moves[4] == 'X') {
      return 5;
    } else if (moves[7] == 'X' && moves[8] == 'X') {
      return 6;
    } else if (moves[6] == 'X' && moves[8] == 'X') {
      return 7;
    } else if (moves[6] == 'X' && moves[7] == 'X') {
      return 8;
    } else if (moves[3] == 'X' && moves[6] == 'X') {
      return 0;
    } else if (moves[0] == 'X' && moves[6] == 'X') {
      return 3;
    } else if (moves[0] == 'X' && moves[3] == 'X') {
      return 6;
    } else if (moves[4] == 'X' && moves[7] == 'X') {
      return 1;
    } else if (moves[1] == 'X' && moves[7] == 'X') {
      return 4;
    } else if (moves[1] == 'X' && moves[4] == 'X') {
      return 7;
    } else if (moves[5] == 'X' && moves[8] == 'X') {
      return 2;
    } else if (moves[2] == 'X' && moves[8] == 'X') {
      return 5;
    } else if (moves[2] == 'X' && moves[5] == 'X') {
      return 8;
    } else if (moves[4] == 'X' && moves[8] == 'X') {
      return 0;
    } else if (moves[0] == 'X' && moves[8] == 'X') {
      return 4;
    } else if (moves[4] == 'X' && moves[8] == 'X') {
      return 0;
    } else if (moves[0] == 'X' && moves[4] == 'X') {
      return 8;
    } else {
      return 4;
    }
  }

  int aiMayWinAt() {
    if (moves[1] == '0' && moves[2] == '0') {
      return 0;
    } else if (moves[0] == '0' && moves[2] == '0') {
      return 1;
    } else if (moves[0] == '0' && moves[1] == '0') {
      return 2;
    } else if (moves[4] == '0' && moves[5] == '0') {
      return 3;
    } else if (moves[3] == '0' && moves[5] == '0') {
      return 4;
    } else if (moves[3] == '0' && moves[4] == '0') {
      return 5;
    } else if (moves[7] == '0' && moves[8] == '0') {
      return 6;
    } else if (moves[6] == '0' && moves[8] == '0') {
      return 7;
    } else if (moves[6] == '0' && moves[7] == '0') {
      return 8;
    } else if (moves[3] == '0' && moves[6] == '0') {
      return 0;
    } else if (moves[0] == '0' && moves[6] == '0') {
      return 3;
    } else if (moves[0] == '0' && moves[3] == '0') {
      return 6;
    } else if (moves[4] == '0' && moves[7] == '0') {
      return 1;
    } else if (moves[1] == '0' && moves[7] == '0') {
      return 4;
    } else if (moves[1] == '0' && moves[4] == '0') {
      return 7;
    } else if (moves[5] == '0' && moves[8] == '0') {
      return 2;
    } else if (moves[2] == '0' && moves[8] == '0') {
      return 5;
    } else if (moves[2] == '0' && moves[5] == '0') {
      return 8;
    } else if (moves[4] == '0' && moves[8] == '0') {
      return 0;
    } else if (moves[0] == '0' && moves[8] == '0') {
      return 4;
    } else if (moves[4] == '0' && moves[8] == '0') {
      return 0;
    } else if (moves[0] == '0' && moves[4] == '0') {
      return 8;
    } else {
      return 4;
    }
  }

  bool checkPlayerHasWon() {
    if (moves[0] == 'X' && moves[1] == 'X' && moves[2] == 'X') {
      return true;
    } else if (moves[3] == 'X' && moves[4] == 'X' && moves[5] == 'X') {
      return true;
    } else if (moves[6] == 'X' && moves[7] == 'X' && moves[8] == 'X') {
      return true;
    } else if (moves[0] == 'X' && moves[3] == 'X' && moves[6] == 'X') {
      return true;
    } else if (moves[1] == 'X' && moves[4] == 'X' && moves[7] == 'X') {
      return true;
    } else if (moves[2] == 'X' && moves[5] == 'X' && moves[8] == 'X') {
      return true;
    } else if (moves[0] == 'X' && moves[4] == 'X' && moves[8] == 'X') {
      return true;
    } else if (moves[2] == 'X' && moves[4] == 'X' && moves[6] == 'X') {
      return true;
    } else {
      return false;
    }
  }

  bool checkAIHasWon() {
    if (moves[0] == '0' && moves[1] == '0' && moves[2] == '0') {
      return true;
    } else if (moves[3] == '0' && moves[4] == '0' && moves[5] == '0') {
      return true;
    } else if (moves[6] == '0' && moves[7] == '0' && moves[8] == '0') {
      return true;
    } else if (moves[0] == '0' && moves[3] == '0' && moves[6] == '0') {
      return true;
    } else if (moves[1] == '0' && moves[4] == '0' && moves[7] == '0') {
      return true;
    } else if (moves[2] == '0' && moves[5] == '0' && moves[8] == '0') {
      return true;
    } else if (moves[0] == '0' && moves[4] == '0' && moves[8] == '0') {
      return true;
    } else if (moves[2] == '0' && moves[4] == '0' && moves[6] == '0') {
      return true;
    } else {
      return false;
    }
  }
}
