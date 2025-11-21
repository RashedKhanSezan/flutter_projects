import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get themeMode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggleTheme([bool? toDark]) {
    if (toDark != null) {
      _mode = toDark ? ThemeMode.dark : ThemeMode.light;
    } else {
      _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    }
    notifyListeners();
  }

  void setLight() {
    _mode = ThemeMode.light;
    notifyListeners();
  }

  void setDark() {
    _mode = ThemeMode.dark;
    notifyListeners();
  }
}
