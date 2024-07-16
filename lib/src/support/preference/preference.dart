import 'package:get_storage/get_storage.dart';

class Preference {
  final String name;

  Preference(this.name);

  Future<Iterable<String>> getKeys() async => (await _sp).getKeys();

  Future<bool?> getBool(String key) async => (await _sp).read(key);

  Future<int?> getInt(String key) async => (await _sp).read(key);

  Future<double?> getDouble(String key) async => (await _sp).read(key);

  Future<String?> getString(String key) async => (await _sp).read(key);

  Future<List<String>?> getStringList(String key) async => (await _sp).read(key);

  Future<void> setBool(String key, bool value) async => (await _sp).write(key, value);

  Future<void> setInt(String key, int value) async => (await _sp).write(key, value);

  Future<void> setDouble(String key, double value) async => (await _sp).write(key, value);

  Future<void> setString(String key, String value) async => (await _sp).write(key, value);

  Future<void> setStringList(String key, List<String> value) async => (await _sp).write(key, value);

  Future<void> remove(String key) async => (await _sp).remove(key);

  Future<void> clear() async => (await _sp).erase();

  GetStorage? _storage;

  Future<GetStorage> get _sp async {
    GetStorage? result = _storage;
    if (result != null) {
      return result;
    } else {
      result = GetStorage(name);
      await result.initStorage;
      _storage = result;
      return result;
    }
  }
}
