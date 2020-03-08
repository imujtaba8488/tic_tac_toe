import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import './theme.dart';
import 'gameover.dart';

enum Turn { player, ai }

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
  String playerMark = 'X', aiMark = '0';

  @override
  void initState() {
    totalMoves.fillRange(0, 9, '');
    turn = Turn.player;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // If it's ai's turn, play ai's turn.
    checkForWinner();
    if (turn == Turn.ai) {
      Future.delayed(const Duration(seconds: 1), () {
        aiPlay();
      });
    }

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
                // if the position where the player wants to play is available.
                if (isMoveAvailable(index)) {
                  playMove(index);
                } else {
                  playSound(SoundEffect.error);
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
    );
  }

  // One of the most important function.
  void playMove(int index) {
    setState(() {
      if (turn == Turn.player) {
        totalMoves[index] = 'X';
        playerMoveIndices.add(index);
        turn = Turn.ai;
        playSound(SoundEffect.move);
      } else {
        totalMoves[index] = '0';
        aiMovesIndices.add(index);
        turn = Turn.player;
        playSound(SoundEffect.aiMove);
      }
    });
  }

  void aiPlay() {
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
  }

  bool isMoveAvailable(int index) {
    return index >= 0 && totalMoves[index].isEmpty;
  }

  bool get aiCanWin {
    return canWin(aiMovesIndices) >= 0;
  }

  bool get playerCanWin {
    return canWin(playerMoveIndices) >= 0;
  }

  int get aiCanWinAt {
    return canWin(aiMovesIndices);
  }

  int get playerCanWinAt {
    return canWin(playerMoveIndices);
  }

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

  void checkForWinner() {
    // For horizontal...
    if (totalMoves[0] == playerMark &&
        totalMoves[1] == playerMark &&
        totalMoves[2] == playerMark) {
      declarePlayerAsWinner();
    } else if (totalMoves[0] == aiMark &&
        totalMoves[1] == aiMark &&
        totalMoves[2] == aiMark) {
      declareAiAsWinner();
    } else if (totalMoves[3] == playerMark &&
        totalMoves[4] == playerMark &&
        totalMoves[5] == playerMark) {
      declarePlayerAsWinner();
    } else if (totalMoves[3] == aiMark &&
        totalMoves[4] == aiMark &&
        totalMoves[5] == aiMark) {
      declareAiAsWinner();
    } else if (totalMoves[6] == playerMark &&
        totalMoves[7] == playerMark &&
        totalMoves[8] == playerMark) {
      declarePlayerAsWinner();
    } else if (totalMoves[6] == aiMark &&
        totalMoves[7] == aiMark &&
        totalMoves[8] == aiMark) {
      declareAiAsWinner();
    }

    // for vertical....
    else if (totalMoves[0] == playerMark &&
        totalMoves[3] == playerMark &&
        totalMoves[6] == playerMark) {
      declarePlayerAsWinner();
    } else if (totalMoves[0] == aiMark &&
        totalMoves[3] == aiMark &&
        totalMoves[6] == aiMark) {
      declareAiAsWinner();
    } else if (totalMoves[1] == playerMark &&
        totalMoves[4] == playerMark &&
        totalMoves[7] == playerMark) {
      declarePlayerAsWinner();
    } else if (totalMoves[1] == aiMark &&
        totalMoves[4] == aiMark &&
        totalMoves[7] == aiMark) {
      declareAiAsWinner();
    } else if (totalMoves[2] == playerMark &&
        totalMoves[5] == playerMark &&
        totalMoves[8] == playerMark) {
      declarePlayerAsWinner();
    } else if (totalMoves[2] == aiMark &&
        totalMoves[5] == aiMark &&
        totalMoves[8] == aiMark) {
      declareAiAsWinner();
    }

    // For diagonal...
    else if (totalMoves[0] == playerMark &&
        totalMoves[4] == playerMark &&
        totalMoves[8] == playerMark) {
      declarePlayerAsWinner();
    } else if (totalMoves[0] == aiMark &&
        totalMoves[4] == aiMark &&
        totalMoves[8] == aiMark) {
      declareAiAsWinner();
    } else if (totalMoves[2] == playerMark &&
        totalMoves[4] == playerMark &&
        totalMoves[6] == playerMark) {
      declarePlayerAsWinner();
    } else if (totalMoves[2] == aiMark &&
        totalMoves[4] == aiMark &&
        totalMoves[6] == aiMark) {
      declareAiAsWinner();
    }
  }

  void declarePlayerAsWinner() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: GameOver('You are the Winner', () => Navigator.pop(context)),
    ).then((f) => reset());
  }

  void declareAiAsWinner() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: GameOver('AI is the Winner', () => Navigator.pop(context)),
    ).then((f) => reset());
  }

  void playRandomly() {
    if (anyPositionAvailable()) {
      playMoveAtRandom();
    } else {
      gameOver();
    }
  }

  bool anyPositionAvailable() {
    return totalMoves.contains('');
  }

  List<int> positionsAvailable() {
    List<int> availablePos = List();

    for (int i = 0; i < totalMoves.length; i++) {
      if (totalMoves[i] == '') {
        availablePos.add(i);
      }
    }

    return availablePos;
  }

  void playMoveAtRandom() {
    if (positionsAvailable().length > 0) {
      positionsAvailable().shuffle();

      Random random = Random();
      int nextMove = random.nextInt(positionsAvailable().length);

      playMove(positionsAvailable()[nextMove]);
    }
  }

  void gameOver() {
    //todo;
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
    });
  }
}

enum SoundEffect { win, lost, draw, move, aiMove, error }
