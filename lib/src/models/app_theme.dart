import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  BoxDecoration decoration;
  TextStyle moveTextStyleMonoton, moveTextStyleBlackHansSans, buttonTextStyle;
  Color backgroundColor;
  Color iconColor;
  TextStyle scoreTextStyle;
  TextStyle gameOverTextStyle;
  TextStyle resultTextStyle;
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

    moveTextStyleMonoton = GoogleFonts.monoton(
      color: color != Colors.white ? Colors.white : Colors.black,
      fontSize: 50,
    );

    moveTextStyleBlackHansSans = GoogleFonts.blackHanSans(
      color: color != Colors.white ? Colors.white : Colors.black,
      fontSize: 50,
    );

    backgroundColor = color;

    iconColor = Colors.white;

    scoreTextStyle = GoogleFonts.aclonica(
      fontSize: 40,
      color: Colors.yellow,
    );

    buttonTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
    );

    gameOverTextStyle = GoogleFonts.aclonica(
      color: Colors.white,
      fontSize: 30,
    );

    resultTextStyle = GoogleFonts.ultra(
      color: Colors.white,
      fontSize: 25,
    );
  }
}
