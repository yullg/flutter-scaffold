import '../internal/scaffold_logger.dart';
import '../internal/scaffold_storage.dart';
import '../support/logger/logger.dart';
import 'uuid_helper.dart';

class GuidHelper {
  static const _kStorageKey = "yg_guid";

  /// 获取GUID (global unique identifier)，如果没有就生成一个。
  static String get() {
    return ScaffoldStorage.getString(_kStorageKey) ?? reset();
  }

  /// 重新生成一个GUID后返回。
  static String reset() {
    final result = UuidHelper.v4();
    ScaffoldStorage.setString(_kStorageKey, result).then((value) {
      ScaffoldLogger.info(Logger.message(library: "guid_helper", part: "Reset", what: "Guid saved", args: [result]));
    }, onError: (e, s) {
      ScaffoldLogger.error(
          Logger.message(library: "guid_helper", part: "Reset", what: "Failed to save guid", args: [result]), e, s);
    });
    return result;
  }

  GuidHelper._();
}
