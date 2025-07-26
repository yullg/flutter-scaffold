import 'package:get_storage/get_storage.dart';

class Preference {
  final String name;

  Preference(this.name);

  Future<Iterable<String>> getKeys() => _sp.then((it) => it.getKeys());

  Future<bool?> getBool(String key) => _sp.then((it) => it.read(key));

  Future<int?> getInt(String key) => _sp.then((it) => it.read(key));

  Future<double?> getDouble(String key) => _sp.then((it) => it.read(key));

  Future<String?> getString(String key) => _sp.then((it) => it.read(key));

  Future<List<String>?> getStringList(String key) => _sp.then((it) => it.read(key)?.cast<String>());

  Future<void> setBool(String key, bool value) => _sp.then((it) => it.write(key, value));

  Future<void> setInt(String key, int value) => _sp.then((it) => it.write(key, value));

  Future<void> setDouble(String key, double value) => _sp.then((it) => it.write(key, value));

  Future<void> setString(String key, String value) => _sp.then((it) => it.write(key, value));

  Future<void> setStringList(String key, List<String> value) => _sp.then((it) => it.write(key, value));

  Future<void> remove(String key) => _sp.then((it) => it.remove(key));

  Future<void> clear() => _sp.then((it) => it.erase());

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
