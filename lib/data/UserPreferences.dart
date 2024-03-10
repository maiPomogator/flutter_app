import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static bool getIsAuth() {
    return _preferences.getBool('isAuth') ?? false;
  }

  static Future<void> setIsAuth(bool value) async {
    await _preferences.setBool('isAuth', value);
  }

  static Future<void> setMainType(String type) async {
    await _preferences.setString('mainType', type);
  }

  static String? getMainType() {
    return _preferences.getString('mainType');
  }

  static String? getTheme() {
    return _preferences.getString('theme');
  }

  static Future<void> setTheme(String theme) async {
    await _preferences.setString('theme', theme);
  }
}
