import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primaryColor: isDarkTheme ? Colors.green.shade900 : Colors.green.shade100,
      hintColor: Colors.green,

      fontFamily: 'SAN',

      backgroundColor: isDarkTheme ? Colors.green.shade900 : Colors.green.shade100,
      cardColor: isDarkTheme ? Colors.green.shade900 : Colors.green.shade300,
      canvasColor: isDarkTheme ? Colors.green : Colors.greenAccent,
      splashColor: isDarkTheme ? Colors.green : Colors.green.shade200,
      scaffoldBackgroundColor: isDarkTheme ? Colors.green.shade900 : Colors.green.shade200,
      highlightColor: isDarkTheme ? Colors.white : Colors.black,
      dividerColor: isDarkTheme ? Colors.black : Colors.white,
      
//      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
//      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),

//      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
//      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
//      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
//      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
    );
  }
}
