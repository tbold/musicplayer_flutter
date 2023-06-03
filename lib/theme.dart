import 'package:flutter/material.dart';

ThemeData customTheme() {
  final ThemeData lightTheme = ThemeData.light();
  return lightTheme.copyWith(
      primaryColor: Color(0xffce107c),
      indicatorColor: Color(0xFF807A6B),
      scaffoldBackgroundColor: Color.fromARGB(255, 245, 245, 245),
      // primaryIconTheme: lightTheme.primaryIconTheme.copyWith(
      //   color: Colors.white,
      //   size: 20,
      // ),
      // iconTheme: lightTheme.iconTheme.copyWith(
      //   color: Colors.white,
      // ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255, 192, 183, 161),
      ));
}
