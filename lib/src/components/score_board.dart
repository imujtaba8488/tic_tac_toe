import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/game_model.dart';

class ScoreBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        return Row(
          children: <Widget>[
            Container(),
          ],
        );
      },
    );
  }
}
