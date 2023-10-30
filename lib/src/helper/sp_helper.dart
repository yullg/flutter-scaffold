import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  static late SharedPreferences _sp;

  @Deprecated("This method is forced to be exposed because of syntax restrictions,"
      " but you should never use it.")
  static Future<void> initialize() async {
    _sp = await SharedPreferences.getInstance();
  }

  static bool containsKey(String key) => _sp.containsKey(key);

  static Object? get(String key) => _sp.get(key);

  static bool? getBool(String key) => _sp.getBool(key);

  static double? getDouble(String key) => _sp.getDouble(key);

  static int? getInt(String key) => _sp.getInt(key);

  static Set<String> getKeys() => _sp.getKeys();

  static String? getString(String key) => _sp.getString(key);

  static List<String>? getStringList(String key) => _sp.getStringList(key);

  static Future<void> reload() => _sp.reload();

  static Future<bool> remove(String key) => _sp.remove(key);

  static Future<bool> setBool(String key, bool value) => _sp.setBool(key, value);

  static Future<bool> setDouble(String key, double value) => _sp.setDouble(key, value);

  static Future<bool> setInt(String key, int value) => _sp.setInt(key, value);

  static Future<bool> setString(String key, String value) => _sp.setString(key, value);

  static Future<bool> setStringList(String key, List<String> value) => _sp.setStringList(key, value);

  static Future<bool> clear() => _sp.clear();

  SPHelper._();
}
