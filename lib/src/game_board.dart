import 'package:flutter/material.dart';

import 'theme.dart';
import 'game_logic.dart';
import 'game_over.dart';

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
    aiMoveIfTurn();

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
                      if (gameLogic.hasAIWon || gameLogic.hasPlayerWon) {
                        // Review: What should happen here...
                      } else {
                        playerMove(index);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Text(gameLogic.movesPlayed[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void playerMove(int at) {
    // Player move is followed by a check to find out if the player has won.
    if (gameLogic.movesLeft.length > 0) {
      setState(() {
        gameLogic.playMove(at);
      });

      if (gameLogic.hasPlayerWon) {
        showGameOver('You won!');
      }
    } else {
      showGameOver('Its a Draw!');
    }
  }

  void aiMoveIfTurn() {
    // Don't play the turn if either the AI or the player has won.
    if (gameLogic.hasAIWon || gameLogic.hasPlayerWon) {
      // Reveiw: What should happen here??
    } else {
      // AI move is followed by a check to find out if the AI has won.
      if (gameLogic.turn == Turn.ai) {
        // AI play is delayed by half a second.
        Future.delayed(Duration(milliseconds: 500), () {
          if (gameLogic.movesLeft.length > 0) {
            setState(() {
              gameLogic.aiAutoPlay();
            });
          } else {
            showGameOver('Its a Draw!');
          }

          if (gameLogic.hasAIWon) {
            showGameOver('AI has Won');
          }

          // Review: Added because if the AI makes the first move and its a draw the alert doesn't pop. Will this solve that issue? It definitely does...
          if (gameLogic.movesLeft.length <= 0) {
            showGameOver('Its a Draw');
          }
        });
      }
    }
  }

  void showGameOver(String whoWon) {
    showDialog(
      context: context,
      child: GameOver(whoWon, () {
        clearBoard();
        Navigator.pop(context);
      }),
    );
  }

  void clearBoard() {
    setState(() {
      gameLogic.resetGame();
    });
  }
}
