import 'package:flutter/material.dart';
import 'package:todo_list/themes/dark_mode.dart';
import 'package:todo_list/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode? true:false;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    themeData = (_themeData == lightMode)? darkMode: lightMode;
  }
}