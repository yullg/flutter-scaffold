import '../../internal/default_method_channel.dart';

class AndroidDomainVerificationPlugin {
  static const int kDomainStateNone = 0;
  static const int kDomainStateSelected = 1;
  static const int kDomainStateVerified = 2;

  static Future<bool?> isLinkHandlingAllowed({
    String? packageName,
  }) {
    return DefaultMethodChannel.invokeMethod("dvIsLinkHandlingAllowed", packageName);
  }

  static Future<Map<String, int>?> getHostToStateMap({
    String? packageName,
  }) {
    return DefaultMethodChannel.invokeMapMethod("dvGetHostToStateMap", packageName);
  }

  static Future<void> toSettings({
    String? packageName,
  }) {
    return DefaultMethodChannel.invokeMethod("dvToSettings", packageName);
  }

  AndroidDomainVerificationPlugin._();
}
