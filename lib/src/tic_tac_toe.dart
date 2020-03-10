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
                    onTap: () {
                      // if the position where the player wants to play is available.
                      if (anyMoveLeft()) {
                        if (isMoveAvailable(index)) {
                          playMove(index);
                        } else {
                          playSound(SoundEffect.error);
                        }
                      } else {
                        setState(() {
                          winner = Winner.draw;
                        });
                      }
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
            Text('Player Score: $playerScore'),
            Text('AI Score: $aiScore'),
            Divider(
              color: Colors.amber,
            ),
            hasWon()
                ? gameOver(
                    winner == Winner.player ? 'You Have Won' : 'AI has Won')
                : winner == Winner.draw ? gameOver('Its a Draw') : Container(),
          ],
        ),
      ),
    );
  }

  // Quite an important function ... document later on.
  void playMove(int index) {
    setState(() {
      if (turn == Turn.player) {
        totalMoves[index] = playerMark;
        playerMoveIndices.add(index);
        playSound(SoundEffect.move);
        turn = Turn.ai;
        if (hasWon()) {
          winner = Winner.player;
          playerScore++;
        }
      } else {
        totalMoves[index] = aiMark;
        aiMovesIndices.add(index);
        playSound(SoundEffect.aiMove);
        turn = Turn.player;
        if (hasWon()) {
          winner = Winner.ai;
          aiScore++;
        }
      }
    });
  }

  void aiPlay() {
    if (anyMoveLeft()) {
      if (aiCanWin) {
        print('Going down AI CAN WIN at: $aiCanWinAt....');
        if (isMoveAvailable(aiCanWinAt)) {
          playMove(aiCanWinAt);
        } else {
          playRandomly();
        }
      } else if (playerCanWin) {
        print('Going down PLAYER CAN WIN at: $playerCanWinAt....');
        if (isMoveAvailable(playerCanWinAt)) {
          playMove(playerCanWinAt);
        } else {
          playRandomly();
        }
      } else {
        playRandomly();
      }
    } else {
      setState(() {
        winner = Winner.draw;
      });
    }
  }

  bool isMoveAvailable(int index) {
    return index >= 0 && totalMoves[index].isEmpty;
  }

  bool get aiCanWin {
    return canWin(aiMovesIndices) >= 0;
  }

  /// Return true, if there is a possibility that the player can win.
  bool get playerCanWin {
    return canWin(playerMoveIndices) >= 0;
  }

  /// Returns true, if there is a possiblity that the ai can win.
  int get aiCanWinAt {
    return canWin(aiMovesIndices);
  }

  /// Returns the index where the player can win at.
  int get playerCanWinAt {
    return canWin(playerMoveIndices);
  }

  // Returns the index of a winning possibility for a given list containing the indicies occupied so far, else returns -1 if there is no possibility of winning.
  int canWin(List<int> indicies) {
    // For horizontal
    if (indicies.contains(1) && indicies.contains(2) && totalMoves[0].isEmpty) {
      return 0;
    } else if (indicies.contains(0) &&
        indicies.contains(2) &&
        totalMoves[1].isEmpty) {
      return 1;
    } else if (indicies.contains(0) &&
        indicies.contains(1) &&
        totalMoves[2].isEmpty) {
      return 2;
    } else if (indicies.contains(4) &&
        indicies.contains(5) &&
        totalMoves[3].isEmpty) {
      return 3;
    } else if (indicies.contains(3) &&
        indicies.contains(5) &&
        totalMoves[4].isEmpty) {
      return 4;
    } else if (indicies.contains(3) &&
        indicies.contains(4) &&
        totalMoves[5].isEmpty) {
      return 5;
    } else if (indicies.contains(7) &&
        indicies.contains(8) &&
        totalMoves[6].isEmpty) {
      return 6;
    } else if (indicies.contains(6) &&
        indicies.contains(8) &&
        totalMoves[7].isEmpty) {
      return 7;
    } else if (indicies.contains(6) &&
        indicies.contains(7) &&
        totalMoves[8].isEmpty) {
      return 8;
    }

    // For vertical...
    else if (indicies.contains(3) &&
        indicies.contains(6) &&
        totalMoves[0].isEmpty) {
      return 0;
    } else if (indicies.contains(0) &&
        indicies.contains(6) &&
        totalMoves[3].isEmpty) {
      return 3;
    } else if (indicies.contains(0) &&
        indicies.contains(3) &&
        totalMoves[6].isEmpty) {
      return 6;
    } else if (indicies.contains(7) &&
        indicies.contains(4) &&
        totalMoves[1].isEmpty) {
      return 1;
    } else if (indicies.contains(1) &&
        indicies.contains(7) &&
        totalMoves[4].isEmpty) {
      return 4;
    } else if (indicies.contains(1) &&
        indicies.contains(4) &&
        totalMoves[7].isEmpty) {
      return 7;
    } else if (indicies.contains(2) &&
        indicies.contains(8) &&
        totalMoves[5].isEmpty) {
      return 5;
    } else if (indicies.contains(5) &&
        indicies.contains(8) &&
        totalMoves[2].isEmpty) {
      return 2;
    } else if (indicies.contains(2) &&
        indicies.contains(5) &&
        totalMoves[8].isEmpty) {
      return 8;
    }

    // For diagonal
    else if (indicies.contains(0) &&
        indicies.contains(4) &&
        totalMoves[8].isEmpty) {
      return 8;
    } else if (indicies.contains(4) &&
        indicies.contains(8) &&
        totalMoves[0].isEmpty) {
      return 0;
    } else if (indicies.contains(0) &&
        indicies.contains(8) &&
        totalMoves[4].isEmpty) {
      return 4;
    } else if (indicies.contains(2) &&
        indicies.contains(4) &&
        totalMoves[6].isEmpty) {
      return 6;
    } else if (indicies.contains(2) &&
        indicies.contains(6) &&
        totalMoves[4].isEmpty) {
      return 4;
    } else if (indicies.contains(6) &&
        indicies.contains(4) &&
        totalMoves[2].isEmpty) {
      return 2;
    }

    // If no chance
    else {
      return -1;
    }
  }

  bool hasWon() {
    // For horizontal...
    if (totalMoves[0] == playerMark &&
        totalMoves[1] == playerMark &&
        totalMoves[2] == playerMark) {
      return true;
    } else if (totalMoves[0] == aiMark &&
        totalMoves[1] == aiMark &&
        totalMoves[2] == aiMark) {
      return true;
    } else if (totalMoves[3] == playerMark &&
        totalMoves[4] == playerMark &&
        totalMoves[5] == playerMark) {
      return true;
    } else if (totalMoves[3] == aiMark &&
        totalMoves[4] == aiMark &&
        totalMoves[5] == aiMark) {
      return true;
    } else if (totalMoves[6] == playerMark &&
        totalMoves[7] == playerMark &&
        totalMoves[8] == playerMark) {
      return true;
    } else if (totalMoves[6] == aiMark &&
        totalMoves[7] == aiMark &&
        totalMoves[8] == aiMark) {
      return true;
    }

    // for vertical....
    else if (totalMoves[0] == playerMark &&
        totalMoves[3] == playerMark &&
        totalMoves[6] == playerMark) {
      return true;
    } else if (totalMoves[0] == aiMark &&
        totalMoves[3] == aiMark &&
        totalMoves[6] == aiMark) {
      return true;
    } else if (totalMoves[1] == playerMark &&
        totalMoves[4] == playerMark &&
        totalMoves[7] == playerMark) {
      return true;
    } else if (totalMoves[1] == aiMark &&
        totalMoves[4] == aiMark &&
        totalMoves[7] == aiMark) {
      return true;
    } else if (totalMoves[2] == playerMark &&
        totalMoves[5] == playerMark &&
        totalMoves[8] == playerMark) {
      return true;
    } else if (totalMoves[2] == aiMark &&
        totalMoves[5] == aiMark &&
        totalMoves[8] == aiMark) {
      return true;
    }

    // For diagonal...
    else if (totalMoves[0] == playerMark &&
        totalMoves[4] == playerMark &&
        totalMoves[8] == playerMark) {
      return true;
    } else if (totalMoves[0] == aiMark &&
        totalMoves[4] == aiMark &&
        totalMoves[8] == aiMark) {
      return true;
    } else if (totalMoves[2] == playerMark &&
        totalMoves[4] == playerMark &&
        totalMoves[6] == playerMark) {
      return true;
    } else if (totalMoves[2] == aiMark &&
        totalMoves[4] == aiMark &&
        totalMoves[6] == aiMark) {
      return true;
    } else {
      return false;
    }
  }

  void playRandomly() {
    if (anyMoveLeft()) {
      playMoveAtRandom();
    } else {
      showDialog(
        context: context,
        child: GameOver('Its a Draw!', () => Navigator.pop(context)),
      ).then((f) => reset());
    }
  }

  bool anyMoveLeft() {
    return totalMoves.contains('');
  }

  /// Returns the number of moves that the left to play.
  List<int> movesLeft() {
    List<int> availablePos = List();

    for (int i = 0; i < totalMoves.length; i++) {
      if (totalMoves[i] == '') {
        availablePos.add(i);
      }
    }

    return availablePos;
  }

  /// Plays a move at random only when a move is available.
  void playMoveAtRandom() {
    if (movesLeft().length > 0) {
      movesLeft().shuffle();

      Random random = Random();
      int nextMove = random.nextInt(movesLeft().length);

      playMove(movesLeft()[nextMove]);
    }
  }

  /// Run when the game is over.
  Widget gameOver(String message) {
    return ListTile(
      title: Text(
        'Results...',
        style: TextStyle(color: Colors.blue),
      ),
      subtitle: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      trailing: RaisedButton(
        onPressed: () => reset(),
        child: Text('Play Again!'),
      ),
    );
  }

  void playSound(SoundEffect soundEffect) {
    switch (soundEffect) {
      case SoundEffect.win:
        audioPlayer.open('assets/audio/win.mp3');
        audioPlayer.play();
        break;

      case SoundEffect.lost:
        audioPlayer.open('assets/audio/lost.mp3');
        audioPlayer.play();
        break;

      case SoundEffect.draw:
        audioPlayer.open('assets/audio/draw.mp3');
        audioPlayer.play();
        break;

      case SoundEffect.move:
        audioPlayer.open('assets/audio/move2.mp3');
        audioPlayer.play();
        break;

      case SoundEffect.aiMove:
        audioPlayer.open('assets/audio/move.mp3');
        audioPlayer.play();
        break;

      // REVIEW: ....
      case SoundEffect.error:
        break;

      default:
        break;
    }
  }

  void reset() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        totalMoves[i] = '';
      }
      playerMoveIndices.clear();
      aiMovesIndices.clear();
    });
  }
}

enum SoundEffect { win, lost, draw, move, aiMove, error }
