import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:social_media_app/Theme/theme_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemePreferences themePreferences = ThemePreferences();
  bool IsThemeStatusBlack = false;
  bool get getThemeStatus => IsThemeStatusBlack;
  set setTheme(bool val) {
    IsThemeStatusBlack = val;
    themePreferences.changeTheme(IsThemeStatusBlack);

    notifyListeners();
  }
}
