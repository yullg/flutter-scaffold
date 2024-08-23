import '../config/scaffold_config.dart';
import '../support/preference/preference.dart';

class ScaffoldPreference {
  static Preference get _sp => Preference(ScaffoldConfig.kPreferenceNameScaffold);

  static Future<Iterable<String>> getKeys() => _sp.getKeys();

  static Future<bool?> getBool(String key) => _sp.getBool(key);

  static Future<int?> getInt(String key) => _sp.getInt(key);

  static Future<double?> getDouble(String key) => _sp.getDouble(key);

  static Future<String?> getString(String key) => _sp.getString(key);

  static Future<List<String>?> getStringList(String key) => _sp.getStringList(key);

  static Future<void> setBool(String key, bool value) => _sp.setBool(key, value);

  static Future<void> setInt(String key, int value) => _sp.setInt(key, value);

  static Future<void> setDouble(String key, double value) => _sp.setDouble(key, value);

  static Future<void> setString(String key, String value) => _sp.setString(key, value);

  static Future<void> setStringList(String key, List<String> value) => _sp.setStringList(key, value);

  static Future<void> remove(String key) => _sp.remove(key);

  static Future<void> clear() => _sp.clear();

  ScaffoldPreference._();
}
