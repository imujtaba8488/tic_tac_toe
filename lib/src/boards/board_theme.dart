import 'package:flutter/material.dart';

abstract class BoardTheme {
  BoxDecoration decoration;
  TextStyle textStyle;
}

class DarkTheme extends BoardTheme {
  DarkTheme() {
    decoration = BoxDecoration(
      color: Colors.black,
      border: Border.all(color: Colors.amber, width: 2),
      borderRadius: BorderRadius.circular(5.0),
    );

    textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30,
    );
  }
}

class WhiteTheme extends BoardTheme {
  WhiteTheme() {
    decoration = BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black, width: 2),
      borderRadius: BorderRadius.circular(5.0),
    );

    textStyle = TextStyle(
      color: Colors.black,
      fontSize: 30,
    );
  }
}
