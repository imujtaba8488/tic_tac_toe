import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/models/cloud.dart';
import 'package:tic_tac_toe/src/scoped_models/game_model.dart';

// todo: Things that can be added to this class: Maybe sort wins as per date played. Add more stats like averageTimeTaken to win a game, averageMoveTime, winPercentage, lossPercentage etc.

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        return Scaffold(
          backgroundColor: gameModel.theme.backgroundColor,
          appBar: AppBar(
            backgroundColor: gameModel.theme.backgroundColor,
            actions: <Widget>[
              Tooltip(
                message: 'Reset Game Stats',
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: gameModel.theme.decoration,
                  child: IconButton(
                    icon: Icon(
                      Icons.restore,
                      color: gameModel.theme.iconColor,
                    ),
                    onPressed: () => Cloud().reset(),
                  ),
                ),
              )
            ],
          ),
          body: StreamBuilder(
            stream: Firestore.instance.collection('score').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData || snapshot.data.documents.length == 0) {
                return Center(
                  child: Text(
                    'No data...',
                    style: gameModel.theme.gameOverTextStyle,
                  ),
                );
              } else {
                for (int i = 0; i < snapshot.data.documents.length; i++) {
                  if (snapshot.data.documents[i]['username']
                      .contains(gameModel.player1.name)) {
                    return ListTile(
                      title: Container(
                        margin: EdgeInsets.all(15),
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white),
                          ),
                        ),
                        child: Text(
                          'ALL TIME SCORE',
                          style: gameModel.theme.gameOverTextStyle,
                        ),
                      ),
                      subtitle: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'wins: ${snapshot.data.documents[i]['wins']}',
                            style: gameModel.theme.resultTextStyle,
                          ),
                          Text(
                            'lost: ${snapshot.data.documents[i]['lost']}',
                            style: gameModel.theme.resultTextStyle,
                          ),
                        ],
                      ),
                    );
                  }
                }
                return Container();
              }
            },
          ),
        );
      },
    );
  }

  // _builder(context, document) {
  //   print('inside _builder');
  //   return ListTile(
  //     title: Text('score'),
  //     subtitle: Column(
  //       children: <Widget>[
  //         Text('Score....'),
  //         Text('wins....'),
  //         Text(document['wins'].toString()),
  //         // Text('lost: ${document['lost']}'),
  //       ],
  //     ),
  //   );
  // }
}
