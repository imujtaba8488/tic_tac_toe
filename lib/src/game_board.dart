import 'package:flutter/material.dart';
import 'package:tic_tac_toe/src/game_logic.dart';
import 'package:tic_tac_toe/src/gameover.dart';

import './theme.dart';

enum Winner { player, ai, draw, none }

class GameBoard extends StatefulWidget {
  GameBoard({Key key}) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final GameLogic gameLogic = GameLogic();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // When rebuilding check if it's AIs' turn or the players'.
    if (gameLogic.turn == Turn.ai) {
      // AI play is delayed by half a second.
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          gameLogic.aiAutoPlay();
        });
      });
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
                        child: Text(gameLogic.totalMoves[index]),
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
    if (gameLogic.movesLeft.length > 0) {
      setState(() {
        gameLogic.playMove(at);
      });

      // if (gameLogic.hasWon(aiMoves)) {
      //   showGameOver('AI has Won');
      // } else if (gameLogic.hasWon(playerMoves)) {
      //   showGameOver('Player has Won.');
      // }
    } else {
      showGameOver('It is a draw!');
    }
  }

  void showGameOver(String whoHasWon) {
    showDialog(
      context: context,
      child: GameOver(
        whoHasWon,
        playAgain,
      ),
    );
  }

  void playAgain() {
    // setState(() {
    //   for (int i = 0; i < totalMoves.length; i++) {
    //     totalMoves[i] = '';
    //   }
    // });
    // aiMoves.clear();
    // playerMoves.clear();
    Navigator.pop(context);
  }
}
