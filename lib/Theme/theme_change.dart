import 'dart:developer';

import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        scaffoldBackgroundColor: isDarkTheme ? Colors.grey[900] : Colors.white,
        navigationBarTheme: NavigationBarThemeData(),
        primaryColor: isDarkTheme ? Colors.black38 : Colors.grey[50],
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: isDarkTheme ? Colors.white : Colors.black,
              displayColor: isDarkTheme ? Colors.white : Colors.black,
            ),
        iconTheme:
            IconThemeData(color: isDarkTheme ? Colors.white : Colors.black)
        // primaryColor: isDarkTheme ? darkCardColor : lightCardColor,
        // backgroundColor: isDarkTheme ? darkBackgroundColor : lightBackgroundColor,
        // hintColor: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade700,
        );
  }
}
