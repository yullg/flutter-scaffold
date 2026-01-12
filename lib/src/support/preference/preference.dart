import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  final String name;

  @protected
  Preference.instance(this.name);

  static final _instances = <String, Preference>{};

  factory Preference(String name) {
    return _instances.putIfAbsent(name, () => Preference.instance(name));
  }

  final _sp = SharedPreferencesAsync();

  String actualKey(String key) => "${name}_$key";

  Future<bool> containsKey(String key) => _sp.containsKey(actualKey(key));

  Future<Iterable<String>> getKeys() => _sp.getKeys().then((keys) => keys.where((key) => key.startsWith("${name}_")));

  Future<int?> getInt(String key) => _sp.getInt(actualKey(key));

  Future<double?> getDouble(String key) => _sp.getDouble(actualKey(key));

  Future<bool?> getBool(String key) => _sp.getBool(actualKey(key));

  Future<String?> getString(String key) => _sp.getString(actualKey(key));

  Future<List<String>?> getStringList(String key) => _sp.getStringList(actualKey(key));

  Future<void> setInt(String key, int value) => _sp.setInt(actualKey(key), value);

  Future<void> setDouble(String key, double value) => _sp.setDouble(actualKey(key), value);

  Future<void> setBool(String key, bool value) => _sp.setBool(actualKey(key), value);

  Future<void> setString(String key, String value) => _sp.setString(actualKey(key), value);

  Future<void> setStringList(String key, List<String> value) => _sp.setStringList(actualKey(key), value);

  Future<void> remove(String key) => _sp.remove(actualKey(key));

  Future<void> clear() async {
    final keys = await getKeys();
    _sp.clear(allowList: keys.toSet());
  }
}

mixin EnumPreferenceMixin on Enum {
  @protected
  Preference get preference;

  Future<bool> exists() => preference.containsKey(name);

  Future<int?> getInt() => preference.getInt(name);

  Future<double?> getDouble(String key) => preference.getDouble(name);

  Future<bool?> getBool() => preference.getBool(name);

  Future<String?> getString() => preference.getString(name);

  Future<List<String>?> getStringList() => preference.getStringList(name);

  Future<void> setInt(int value) => preference.setInt(name, value);

  Future<void> setDouble(double value) => preference.setDouble(name, value);

  Future<void> setBool(bool value) => preference.setBool(name, value);

  Future<void> setString(String value) => preference.setString(name, value);

  Future<void> setStringList(List<String> value) => preference.setStringList(name, value);

  Future<void> remove() => preference.remove(name);
}
