import 'package:flutter/material.dart';

abstract class AppTheme {
  BoxDecoration decoration;
  TextStyle textStyle;
  Color backgroundColor;
}

class Neomorphic extends AppTheme {
  Color color;
  Neomorphic({this.color = Colors.grey}) {
    decoration = BoxDecoration(
      color: color,
      boxShadow: [
        BoxShadow(
          color: Colors.white,
          offset: Offset(-1, -1),
          blurRadius: 2,
        ),
        BoxShadow(
          color: Colors.black,
          offset: Offset(1, 1),
          blurRadius: 2,
        )
      ],
      borderRadius: BorderRadius.circular(15.0),
    );

    textStyle = TextStyle(
      color: color != Colors.white ? Colors.white : Colors.black,
      fontSize: 30,
    );

    backgroundColor = color;
  }
}
