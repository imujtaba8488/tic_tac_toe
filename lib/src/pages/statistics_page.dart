import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/game_model.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Lifetime Achievement',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 6,
                    child: Image.asset('assets/images/trophy.png'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    'Rank: ${gameModel.player1.rank}',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Table(
                    // border: TableBorder.all(width: 0.0),
                    children: [
                      _mainStatRow(
                        child1: Icon(
                          Icons.arrow_upward,
                          color: Colors.blue,
                        ),
                        child2: Icon(
                          Icons.arrow_downward,
                          color: Colors.red,
                        ),
                      ),
                      _mainStatRow(
                        child1: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.orange,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Won',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        child2: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.orange,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Lost',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      _mainStatRow(
                        child1: Text(
                          '${gameModel.player1.lifeTimeScore.wins}',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child2: Text(
                          '${gameModel.player1.lifeTimeScore.loss}',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    children: [
                      _extraStatRow(
                        // icon: Icon(Icons.),
                        label: 'Lifetime Move Count',
                        data: '??',
                      ),
                      _extraStatRow(
                        // icon: Icon(Icons.multiline_chart),
                        label: 'Total Games Played',
                        data: '??',
                      ),
                      _extraStatRow(
                        // icon: Icon(Icons.multiline_chart),
                        label: 'Winning Percentage',
                        data: '??',
                      ),
                      _extraStatRow(
                        // icon: Icon(Icons.multiline_chart),
                        label: 'Loosing Percentage',
                        data: '??',
                      ),
                      _extraStatRow(
                        // icon: Icon(Icons.multiline_chart),
                        label: 'Average Time / Move',
                        data: '??',
                      ),
                      _extraStatRow(
                        // icon: Icon(Icons.multiline_chart),
                        label: 'Average Time / Game',
                        data: '??',
                      ),
                      _extraStatRow(
                        // icon: Icon(Icons.multiline_chart),
                        label: 'Min Move Play Time',
                        data: '??',
                      ),
                      _extraStatRow(
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

  /// Returns a TableRow for the main stats. // !Review later...
  TableRow _mainStatRow({@required Widget child1, @required Widget child2}) {
    return TableRow(
      children: [
        Container(
          padding: EdgeInsets.all(4.0),
          alignment: Alignment.center,
          child: child1,
        ),
        Container(
          alignment: Alignment.center,
          child: child2,
        ),
      ],
    );
  }

  /// Returns a TableRow for extra stats. // ! Review later...
  TableRow _extraStatRow({
    Icon icon,
    String label,
    String data,
    double fontSize = 14.0,
  }) {
    return TableRow(
      children: [
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$label: ',
                  style: TextStyle(fontSize: fontSize),
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
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ),
      ],
    );
  }
}
