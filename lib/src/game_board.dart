import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/src/score.dart';

import 'game_logic.dart';
import 'game_over.dart';
import 'theme.dart';
import 'score_board.dart';

class GameBoard extends StatefulWidget {
  GameBoard({Key key}) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final GameLogic gameLogic = GameLogic();

  int playerScore = 0, aiScore = 0, draws = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('playerScore: $playerScore');
    print('aiScore: $aiScore');

    // Important and only required when playing against the AI. Calls the AI post rendering the current board modifications. Calling it post rendering is required in order to display an alert (if gameover), otherwise, it displays an error if an alert is displayed while the UI is rebuilt.
    if (gameLogic.winner == Winner.none) {
      if (gameLogic.turn == Turn.ai) {
        WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
      }
    }

    return Scaffold(
      backgroundColor: MyTheme().theme.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            ScoreBoard(playerScore, aiScore, draws),
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
                          color: Colors.green,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue,
                              spreadRadius: 3,
                            ),
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 2
                            )
                          ]),
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

  /// Plays the move at the given [index].
  void playMove(int index) {
    setState(() {
      gameLogic.playMove(
        index,
        reportWinner: showGameOver,
        reportScore: (score) {
          if (score.scoreType == ScoreType.win) {
            playerScore++;
          } else if (score.scoreType == ScoreType.draw) {
            draws++;
          }
        },
      );
    });
  }

  void showGameOver(Winner winner) {
    showDialog(
      context: context,
      child: GameOver(winner.toString(), clearBoard),
    );
  }

  /// Clears the board, exits the gameover alert, and resets the game.
  void clearBoard() {
    gameLogic.resetGame();
    Navigator.pop(context);
    setState(() {});
  }

  /// Plays the AI move after the specified delay.
  _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        gameLogic.aiAutoPlay(
          reportWinner: showGameOver,
          reportScore: (score) {
            print('Score Type: ${score.scoreType}');
            if (score.scoreType == ScoreType.win) {
              aiScore++;
            } else if (score.scoreType == ScoreType.draw) {
              draws++;
            }
          },
        );
      });
    });
  }
}
