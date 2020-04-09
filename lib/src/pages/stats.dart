import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tic_tac_toe/src/models/cloud.dart';
import 'package:tic_tac_toe/src/scoped_models/game_model.dart';

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
          ),
          body: StreamBuilder(
            stream: Firestore.instance.collection('players').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData || snapshot.data.documents.length == 0) {
                return Center(
                  child: Text('No data...'),
                );
              } else {
                return ListTile(
                  title: Text('all time score'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('wins: ${snapshot.data.documents[0]['wins']}'),
                      Text('lost: ${snapshot.data.documents[0]['lost']}'),
                      RaisedButton(
                        child: Text("Reset Scores..."),
                        onPressed: () => Cloud().reset(),
                      )
                    ],
                  ),
                );
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
