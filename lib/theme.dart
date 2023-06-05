import 'package:flutter/material.dart';

ThemeData customTheme() {
  final ThemeData lightTheme = ThemeData.light();
  return lightTheme.copyWith(
      primaryColor: Color.fromARGB(255, 220, 48, 146),
      indicatorColor: Color(0xFF807A6B),
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255, 222, 208, 171),
      ));
}
