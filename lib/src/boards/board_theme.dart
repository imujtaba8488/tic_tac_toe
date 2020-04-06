import 'package:flutter/material.dart';

abstract class BoardTheme {
  BoxDecoration decoration;
  TextStyle textStyle;
  Color get color;
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

  get color => Colors.black;
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

  get color => Colors.white;
}

class NeomorphicGrey extends BoardTheme {
  NeomorphicGrey() {
    decoration = BoxDecoration(
      color: Colors.grey,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade100,
          offset: Offset(-1, -1),
          blurRadius: 2,
        ),
        BoxShadow(
          color: Colors.grey.shade800,
          offset: Offset(1, 1),
          blurRadius: 2,
        )
      ],
      borderRadius: BorderRadius.circular(15.0),
    );
    textStyle = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 30,
    );
  }

  get color => Colors.grey;
}

class NeomorphicConcave extends BoardTheme {
  final Color color;

  NeomorphicConcave(this.color) {
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
      color: Colors.grey.shade600,
      fontSize: 30,
    );
  }

  get noShadowDecoration => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
      );
}

class NeomorphicConvex extends BoardTheme {
  final Color color;

  NeomorphicConvex(this.color) {
    decoration = BoxDecoration(
      color: color,
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue,
            Colors.green,
          ]),
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.white,
      //     offset: Offset(-1, -1),
      //     blurRadius: 2,
      //   ),
      //   BoxShadow(
      //     color: Colors.black,
      //     offset: Offset(1, 1),
      //     blurRadius: 2,
      //   )
      // ],
      borderRadius: BorderRadius.circular(15.0),
    );
    textStyle = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 30,
    );
  }
}
