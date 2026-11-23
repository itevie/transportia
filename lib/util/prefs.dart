import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _instance = Preferences._();

  factory Preferences() => _instance;

  Preferences._();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  bool contains(String key) {
    return _prefs.containsKey(key);
  }
}
