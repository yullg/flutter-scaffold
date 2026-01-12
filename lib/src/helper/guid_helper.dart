import '../internal/scaffold_preference.dart';
import 'uuid_helper.dart';

class GuidHelper {
  /// 获取GUID (global unique identifier)，如果没有就生成一个。
  static Future<String> get() async {
    return await ScaffoldPreferences.guid.getString() ?? await reset();
  }

  /// 重新生成一个GUID后返回。
  static Future<String> reset() async {
    final result = UuidHelper.v4();
    await ScaffoldPreferences.guid.setString(result);
    return result;
  }

  GuidHelper._();
}
