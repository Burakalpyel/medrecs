import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  );

  ThemeData get currentTheme => _currentTheme;

  void updateTheme(ThemeData newTheme) {
    _currentTheme = newTheme;
    notifyListeners();
  }
}
