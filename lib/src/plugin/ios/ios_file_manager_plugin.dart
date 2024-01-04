import '../../internal/default_method_channel.dart';

class IosFileManagerPlugin {
  static Future<void> copy({
    required String atUrl,
    required String toUrl,
    bool isSecurityScoped = false,
  }) async {
    return DefaultMethodChannel.invokeMethod("fmCopy", {
      "atUrl": atUrl,
      "toUrl": toUrl,
      "isSecurityScoped": isSecurityScoped,
    });
  }

  static Future<void> move({
    required String atUrl,
    required String toUrl,
    bool isSecurityScoped = false,
  }) async {
    return DefaultMethodChannel.invokeMethod("fmMove", {
      "atUrl": atUrl,
      "toUrl": toUrl,
      "isSecurityScoped": isSecurityScoped,
    });
  }

  IosFileManagerPlugin._();
}
