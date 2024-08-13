import 'package:flutter/material.dart';

var theme = ThemeData(
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    elevation: 1, // 그림자 정도
    titleTextStyle: TextStyle(
        color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),
);
