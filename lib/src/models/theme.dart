import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  ThemeData theme;

  MyTheme() {
    theme = ThemeData(
      // primarySwatch: Colors.grey[900]
      primaryColor: Colors.grey,
      textTheme: TextTheme(
        body1: TextStyle(
          fontSize: 30,
        )
        // body1: GoogleFonts.ubuntu(
        //   color: Colors.white,
        //   fontSize: 30,
        // ),
      ),
    );
  }
}
