import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import './theme.dart';
import './sound_effect.dart';

enum Turn { player, ai }
enum Winner { player, ai, draw, none }

class TicTacToe extends StatefulWidget {
  TicTacToe({Key key}) : super(key: key);

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  final List<String> totalMoves = List(9);
  final SoundEffectPlayer soundEffectPlayer = SoundEffectPlayer();
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
      // AI play is delayed by half a second.
      Future.delayed(Duration(milliseconds: 500), () {
        aiAutoPlay();
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
          soundEffectPlayer.play(SoundEffect.playerMove);
        });
      } else {
        setState(() {
          print('Ai Mark at: $at'); // temp

          totalMoves[at] = aiMark;
          aiMoves.add(at);
          turn = Turn.player;
          soundEffectPlayer.play(SoundEffect.aiMove);
        });
      }
    } else {
      print('No more moves left'); // temp
      // Review: Decide winner or draw.
    }
  }

  void aiAutoPlay() {
    if (movesLeft.length > 0) {
      playRandomMove();
    } else {
      print('No more moves left'); // temp
      // Review: Decide winner or draw.
    }
  }

  /// Plays a random move, if one is left.
  void playRandomMove() {
    if (movesLeft.length > 0) {
      movesLeft.shuffle();

      // Pick a random move from the shuffled movesLeft list and play it.
      playMove(movesLeft[Random().nextInt(movesLeft.length)]);
    } else {
      print('No more moves left'); //temp
      // Review: Decide winner, draw, or gameover.
    }
  }

  /// Returns true if the move [at] is available to play.
  bool isMoveAvailable(int at) => totalMoves[at].isEmpty;

  /// Returns the number of moves that are left to play.
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

  int winningProbability(List<int> moves) {
    // Horizontal Possibilities.
    if (moves.contains(0) && moves.contains(1) && totalMoves[2].isEmpty) {
      return 2;
    } else if (moves.contains(0) &&
        moves.contains(2) &&
        totalMoves[1].isEmpty) {
      return 1;
    } else if (moves.contains(1) &&
        moves.contains(2) &&
        totalMoves[0].isEmpty) {
      return 0;
    } else if (moves.contains(3) &&
        moves.contains(5) &&
        totalMoves[3].isEmpty) {
      return 3;
    } else {
      return -1;
    }
  }

  /// this is complete ...
  int horizontalWinProbability(List<int> moves) {
    if (moves.contains(0) && moves.contains(1) && totalMoves[2].isEmpty) {
      return 2;
    } else if (moves.contains(0) &&
        moves.contains(2) &&
        totalMoves[1].isEmpty) {
      return 1;
    } else if (moves.contains(1) &&
        moves.contains(2) &&
        totalMoves[0].isEmpty) {
      return 0;
    } else if (moves.contains(3) &&
        moves.contains(4) &&
        totalMoves[5].isEmpty) {
      return 5;
    } else if (moves.contains(3) &&
        moves.contains(5) &&
        totalMoves[4].isEmpty) {
      return 4;
    } else if (moves.contains(4) &&
        moves.contains(5) &&
        totalMoves[3].isEmpty) {
      return 3;
    } else if(moves.contains(6) && moves.contains(7) && totalMoves[8].isEmpty) {
      return 8;
    } else if(moves.contains(6) && moves.contains(8) && totalMoves[7].isEmpty) {
      return 7;
    } else if(moves.contains(7) && moves.contains(8) && totalMoves[6].isEmpty) {
      return 6;
    } else {
      return -1;
    }
  }

  // Review: this is incomplete...
  int verticalWinProbability(List<int> moves) {
    if (moves.contains(0) && moves.contains(1) && totalMoves[2].isEmpty) {
      return 2;
    } else if (moves.contains(0) &&
        moves.contains(2) &&
        totalMoves[1].isEmpty) {
      return 1;
    } else if (moves.contains(1) &&
        moves.contains(2) &&
        totalMoves[0].isEmpty) {
      return 0;
    } else if (moves.contains(3) &&
        moves.contains(4) &&
        totalMoves[5].isEmpty) {
      return 5;
    } else if (moves.contains(3) &&
        moves.contains(5) &&
        totalMoves[4].isEmpty) {
      return 4;
    } else if (moves.contains(4) &&
        moves.contains(5) &&
        totalMoves[3].isEmpty) {
      return 3;
    } else if(moves.contains(6) && moves.contains(7) && totalMoves[8].isEmpty) {
      return 8;
    } else if(moves.contains(6) && moves.contains(8) && totalMoves[7].isEmpty) {
      return 7;
    } else if(moves.contains(7) && moves.contains(8) && totalMoves[6].isEmpty) {
      return 6;
    } else {
      return -1;
    }
  }

  // Review: this is incomplete...
  int diagonalWinProbability(List<int> moves) {
    if (moves.contains(0) && moves.contains(1) && totalMoves[2].isEmpty) {
      return 2;
    } else if (moves.contains(0) &&
        moves.contains(2) &&
        totalMoves[1].isEmpty) {
      return 1;
    } else if (moves.contains(1) &&
        moves.contains(2) &&
        totalMoves[0].isEmpty) {
      return 0;
    } else if (moves.contains(3) &&
        moves.contains(4) &&
        totalMoves[5].isEmpty) {
      return 5;
    } else if (moves.contains(3) &&
        moves.contains(5) &&
        totalMoves[4].isEmpty) {
      return 4;
    } else if (moves.contains(4) &&
        moves.contains(5) &&
        totalMoves[3].isEmpty) {
      return 3;
    } else if(moves.contains(6) && moves.contains(7) && totalMoves[8].isEmpty) {
      return 8;
    } else if(moves.contains(6) && moves.contains(8) && totalMoves[7].isEmpty) {
      return 7;
    } else if(moves.contains(7) && moves.contains(8) && totalMoves[6].isEmpty) {
      return 6;
    } else {
      return -1;
    }
  }
}
