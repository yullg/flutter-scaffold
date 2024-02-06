import '../internal/scaffold_storage.dart';
import 'uuid_helper.dart';

class GuidHelper {
  static const _kStorageKey = "yg_guid";

  /// 获取GUID (global unique identifier)，如果没有就生成一个。
  static Future<String> get() async {
    return ScaffoldStorage.getString(_kStorageKey) ?? await reset();
  }

  /// 重新生成一个GUID后返回。
  static Future<String> reset() async {
    final result = UuidHelper.v4();
    await ScaffoldStorage.setString(_kStorageKey, result);
    return result;
  }

  GuidHelper._();
}
