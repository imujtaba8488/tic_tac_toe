import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/game_model.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        return Scaffold(
          // backgroundColor: gameModel.theme.backgroundColor,
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 6,
                    child: Image.asset('assets/images/trophy.png'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Rank: ??',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(width: 0.0),
                    children: [
                      _statRow(
                        icon: Icon(Icons.thumb_up),
                        label: 'Won',
                        data: gameModel.player1.lifeTimeScore.wins.toString(),
                      ),
                      _statRow(
                        icon: Icon(Icons.thumb_down),
                        label: 'Lost',
                        data: gameModel.player1.lifeTimeScore.loss.toString(),
                      ),
                      _statRow(
                        // icon: Icon(Icons.),
                        label: 'Lifetime Move Count',
                        data: '??',
                      ),
                      _statRow(
                        // icon: Icon(Icons.multiline_chart),
                        label: 'Total Games Played',
                        data: '??',
                      ),
                      _statRow(
                        // icon: Icon(Icons.multiline_chart),
                        label: 'Winning Percentage',
                        data: '??',
                      ),
                      _statRow(
                        // icon: Icon(Icons.multiline_chart),
                        label: 'Loosing Percentage',
                        data: '??',
                      ),
                      _statRow(
                        // icon: Icon(Icons.multiline_chart),
                        label: 'Average Time / Move',
                        data: '??',
                      ),
                      _statRow(
                        // icon: Icon(Icons.multiline_chart),
                        label: 'Average Time / Game',
                        data: '??',
                      ),
                      _statRow(
                        // icon: Icon(Icons.multiline_chart),
                        label: 'Min Move Play Time',
                        data: '??',
                      ),
                      _statRow(
                        // icon: Icon(Icons.multiline_chart),
                        label: 'Max Move Play Time',
                        data: '??',
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  TableRow _statRow({Icon icon, String label, String data}) {
    return TableRow(
      children: [
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$label',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
