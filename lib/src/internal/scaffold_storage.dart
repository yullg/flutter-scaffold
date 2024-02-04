import 'package:get_storage/get_storage.dart';

import '../scaffold_constants.dart';

class ScaffoldStorage {
  static GetStorage get _sp => GetStorage(ScaffoldConstants.kGetStorageNameScaffold);

  static Set<String> getKeys() => Set.of(_sp.getKeys());

  static bool? getBool(String key) => _sp.read(key);

  static int? getInt(String key) => _sp.read(key);

  static double? getDouble(String key) => _sp.read(key);

  static String? getString(String key) => _sp.read(key);

  static List<String>? getStringList(String key) => _sp.read(key);

  static Future<void> setBool(String key, bool value) => _sp.write(key, value);

  static Future<void> setInt(String key, int value) => _sp.write(key, value);

  static Future<void> setDouble(String key, double value) => _sp.write(key, value);

  static Future<void> setString(String key, String value) => _sp.write(key, value);

  static Future<void> setStringList(String key, List<String> value) => _sp.write(key, value);

  static Future<void> remove(String key) => _sp.remove(key);

  static Future<void> clear() => _sp.erase();

  ScaffoldStorage._();
}
