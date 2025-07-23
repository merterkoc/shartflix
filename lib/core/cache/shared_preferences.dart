import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  factory Shared() => _instance;

  Shared._privateConstructor();

  static final Shared _instance = Shared._privateConstructor();

  static late SharedPreferences _preferences;

   Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> setInt(String key, int value) async {
    return _preferences.setInt(key, value);
  }

  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  Future<bool> setString(String key, String value) async {
    return _preferences.setString(key, value);
  }

  String? getString(String key) {
    return _preferences.getString(key);
  }

  Future<bool> setBool(String key, {required bool value}) async {
    return _preferences.setBool(key, value);
  }

  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return _preferences.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return _preferences.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  Future<bool> remove(String key) async {
    return _preferences.remove(key);
  }

  Future<bool> clear() async {
    return _preferences.clear();
  }
}
