import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/game_model.dart';

class LeaderBoardPage extends StatefulWidget {
  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  AsyncSnapshot ss;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {

        return Scaffold(
          backgroundColor: gameModel.theme.backgroundColor,
          appBar: AppBar(
            backgroundColor: gameModel.theme.backgroundColor,
          ),
          body: ScopedModelDescendant<GameModel>(
            builder: (context, child, gameModel) {
              return StreamBuilder(
                stream: Firestore.instance.collection('score').snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data.documents.length == 0) {
                    return Center(
                      child: Text(
                        'No data...',
                        style: gameModel.theme.gameOverTextStyle,
                      ),
                    );
                  } else {
                    ss = snapshot;

                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: itemBuilder,
                    );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return ListTile(
      title: Text(
        "${ss.data.documents[index]['username']}'",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      trailing: Container(
        width: MediaQuery.of(context).size.width / 2.0,
        child: Row(
          children: <Widget>[
            Text(
              'Wins: ${ss.data.documents[index]['wins']}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Lost: ${ss.data.documents[index]['lost']}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
