import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static Future<String> getPrefValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  static Future<void> setPrefValue(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}