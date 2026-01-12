import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceWithCache {
  final String name;

  @protected
  PreferenceWithCache.instance(this.name);

  static final _instances = <String, PreferenceWithCache>{};

  factory PreferenceWithCache(String name) {
    return _instances.putIfAbsent(name, () => PreferenceWithCache.instance(name));
  }

  late SharedPreferencesWithCache _sp;

  String actualKey(String key) => "${name}_$key";

  Future<void> initialize({required Set<String> keys}) async {
    _sp = await SharedPreferencesWithCache.create(cacheOptions: SharedPreferencesWithCacheOptions(allowList: keys));
  }

  Future<void> reloadCache() => _sp.reloadCache();

  bool containsKey(String key) => _sp.containsKey(actualKey(key));

  Iterable<String> getKeys() => _sp.keys.where((key) => key.startsWith("${name}_"));

  int? getInt(String key) => _sp.getInt(actualKey(key));

  double? getDouble(String key) => _sp.getDouble(actualKey(key));

  bool? getBool(String key) => _sp.getBool(actualKey(key));

  String? getString(String key) => _sp.getString(actualKey(key));

  List<String>? getStringList(String key) => _sp.getStringList(actualKey(key));

  Future<void> setInt(String key, int value) => _sp.setInt(actualKey(key), value);

  Future<void> setDouble(String key, double value) => _sp.setDouble(actualKey(key), value);

  Future<void> setBool(String key, bool value) => _sp.setBool(actualKey(key), value);

  Future<void> setString(String key, String value) => _sp.setString(actualKey(key), value);

  Future<void> setStringList(String key, List<String> value) => _sp.setStringList(actualKey(key), value);

  Future<void> remove(String key) => _sp.remove(actualKey(key));

  Future<void> clear() => _sp.clear();
}

mixin EnumPreferenceWithCacheMixin on Enum {
  @protected
  PreferenceWithCache get preference;

  bool exists() => preference.containsKey(name);

  int? getInt() => preference.getInt(name);

  double? getDouble() => preference.getDouble(name);

  bool? getBool() => preference.getBool(name);

  String? getString() => preference.getString(name);

  List<String>? getStringList() => preference.getStringList(name);

  Future<void> setInt(int value) => preference.setInt(name, value);

  Future<void> setDouble(double value) => preference.setDouble(name, value);

  Future<void> setBool(bool value) => preference.setBool(name, value);

  Future<void> setString(String value) => preference.setString(name, value);

  Future<void> setStringList(List<String> value) => preference.setStringList(name, value);

  Future<void> remove() => preference.remove(name);
}
