import 'package:flutter/material.dart';

class AppTheme {
  BoxDecoration _tileDecoration;
  TextStyle markStyle;

  AppTheme() {
    _tileDecoration = BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(5),
    );

    markStyle = TextStyle(
      fontSize: 20
    );
  }

  BoxDecoration get tileDecoration => _tileDecoration;
}