import 'dart:convert';

//import 'package:jam/models/daily_report_formats.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<SharedPreferences> getPrefs() {
    return SharedPreferences.getInstance();
  }

  static Future<bool> setStringPreference(String key, String value) async {
    SharedPreferences prefs = await getPrefs();
    return await prefs.setString(key, value);
  }

  static saveObject(String key, value) async {
    SharedPreferences prefs = await getPrefs();
    prefs.setString(key, value);
  }





  static Future<bool> setBooleanPreference(String key, bool value) async {
    SharedPreferences prefs = await getPrefs();
    return await prefs.setBool(key, value);
  }

  static Future<bool> setIntegerPreference(String key, int value) async {
    SharedPreferences prefs = await getPrefs();
    return prefs.setInt(key, value);
  }

  static Future<bool> setDoublePreference(String key, double value) async {
    SharedPreferences prefs = await getPrefs();
    return prefs.setDouble(key, value);
  }

  static void setLoggedinUser(String userName) {
    setStringPreference("loggedin", userName);
  }

  static Future<String> getLoggedinUser() {
    return getStringPreference("loggedin");
  }

  static void setAppToken(String token) {
    setStringPreference("token", token);
  }

  static Future<String> getAppToken() {
    return getStringPreference("token");
  }

  static void setLoggedIn(bool isLoggedIn) {
    setBooleanPreference("isLoggedIn", isLoggedIn);
  }

  static Future<bool> isLoggedIn() async {
    return getBooleanPreference("isLoggedIn");
  }

  static Future<bool> getBooleanPreference(String key) async {
    SharedPreferences prefs = await getPrefs();
    return prefs.containsKey(key) ? prefs.getBool(key) : false;
  }

  static Future<String> getStringPreference(String key) async {
    SharedPreferences prefs = await getPrefs();
    return prefs.containsKey(key) ? prefs.getString(key) : "";
  }

  static Future<String> readObject(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> removePreference(String key) async {
    SharedPreferences prefs = await getPrefs();
    return prefs.remove(key);
  }
}
