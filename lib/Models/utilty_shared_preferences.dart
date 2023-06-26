import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UtilitySharedPreferences {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key)!);
  }

  Future<bool> save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, json.encode(value));
  }

  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  Future<bool> check(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
