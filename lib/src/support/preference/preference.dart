import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  final String name;
  final String _prefix;

  Preference(this.name) : _prefix = "${name}_";

  String actualKey(String key) => "$_prefix$key";

  Future<bool> containsKey(String key) => _sp.containsKey(actualKey(key));

  Future<Iterable<String>> getKeys() => _sp.getKeys().then((keys) => keys.where((key) => key.startsWith(_prefix)));

  Future<bool?> getBool(String key) => _sp.getBool(actualKey(key));

  Future<int?> getInt(String key) => _sp.getInt(actualKey(key));

  Future<double?> getDouble(String key) => _sp.getDouble(actualKey(key));

  Future<String?> getString(String key) => _sp.getString(actualKey(key));

  Future<List<String>?> getStringList(String key) => _sp.getStringList(actualKey(key));

  Future<void> setBool(String key, bool value) => _sp.setBool(actualKey(key), value);

  Future<void> setInt(String key, int value) => _sp.setInt(actualKey(key), value);

  Future<void> setDouble(String key, double value) => _sp.setDouble(actualKey(key), value);

  Future<void> setString(String key, String value) => _sp.setString(actualKey(key), value);

  Future<void> setStringList(String key, List<String> value) => _sp.setStringList(actualKey(key), value);

  Future<void> remove(String key) => _sp.remove(actualKey(key));

  Future<void> clear() async {
    final keys = await getKeys();
    _sp.clear(allowList: keys.toSet());
  }

  final _sp = SharedPreferencesAsync();
}
