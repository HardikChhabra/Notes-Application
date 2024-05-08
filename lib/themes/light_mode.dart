import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade200,
    primary: Colors.black54,
    secondary: Colors.grey.shade300,
    tertiary: Colors.white.withRed(0).withGreen(50).withBlue(50),
    inversePrimary: Colors.grey.shade900,
  )
);