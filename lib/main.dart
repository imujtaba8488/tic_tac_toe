import 'package:flutter/material.dart';

import 'src/tic_tac_toe.dart';
import 'src/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: MyTheme().theme,
      home: TicTacToe(),
    );
  }
}