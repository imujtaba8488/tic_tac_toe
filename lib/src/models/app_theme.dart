import 'package:flutter/material.dart';

class AppTheme {
  BoxDecoration _tileDecoration;

  AppTheme() {
    _tileDecoration = BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(5),
    );
  }

  BoxDecoration get tileDecoration => _tileDecoration;
}