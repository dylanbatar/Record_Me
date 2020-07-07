import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _isDark = false;

  bool get isDark => _isDark;
  set isDark(value) {
    _isDark = value;
    saveChange(_isDark);
    notifyListeners();
  }

  changeTheme() {
    _isDark = !_isDark;
    saveChange(_isDark);
    notifyListeners();
  }

  saveChange(value) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setString(
        'config',
        jsonEncode({
          "theme": value ? "dark" : "light",
        }));
  }

  loadConfig() async {
    SharedPreferences prefs = await _prefs;
    String config = prefs.getString('config');
    if (config == null || config == '') {
      await prefs.setString(
        'config',
        jsonEncode({
          "theme": "light",
        }),
      );
      config = prefs.getString('config');
    }

    if (jsonDecode(config)["theme"] == 'dark')
      isDark = true;
    else
      isDark = false;
  }

  //Constructor
  ThemeModel() {
    loadConfig();
  }
}
