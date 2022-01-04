import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _prefs;

  static Future init() async {
    return _prefs = await SharedPreferences.getInstance();
  }

  // 0 -> personal user and 1 -> group user
  static setType(int typeInt) => _prefs!.setInt("type", typeInt);

  static getType() => _prefs!.get("type");

  static setGroupId(String id) => _prefs!.setString("id", id);

  static getGroupId() => _prefs!.getString("id");

  static firstime() => _prefs!.setBool("firstTime", true);

  static changeFirstTime(bool val) => _prefs!.setBool("firstTime", val);

  static getIfFirstTime() => _prefs!.getBool("firstTime");

  static clearEverythingInPrefs() => _prefs!.clear();
}
