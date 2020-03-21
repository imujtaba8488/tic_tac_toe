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
    if (gameLogic.turn == Turn.ai) {
      gameLogic.aiAutoPlay(reportWinnerFound: showGameOver);
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
                      if (gameLogic.hasAIWon || gameLogic.hasPlayerWon) {
                        // Review: What should happen here...
                      } else {
                        playMove(index);
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

  void playMove(int index) {
    setState(() {
      gameLogic.playMove(index);
    });
  }

  void showGameOver(Winner winner) {
    print(
      'Winner is: ${winner == Winner.ai ? 'AI is the Winner' : 'Player is the Winner'}',
    );
  }

  void clearBoard() {
    setState(() {
      gameLogic.resetGame();
    });
  }
}
