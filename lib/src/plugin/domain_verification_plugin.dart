import 'dart:io';

import '../internal/default_method_channel.dart';

class DomainVerificationPlugin {
  static const int DOMAIN_STATE_NONE = 0;
  static const int DOMAIN_STATE_SELECTED = 1;
  static const int DOMAIN_STATE_VERIFIED = 2;

  static Future<bool?> isLinkHandlingAllowed(String packageName) {
    if (Platform.isAndroid) {
      return DefaultMethodChannel.invokeMethod("dvIsLinkHandlingAllowed", packageName);
    }
    return Future.value(null);
  }

  static Future<bool?> isMyLinkHandlingAllowed() {
    if (Platform.isAndroid) {
      return DefaultMethodChannel.invokeMethod("dvIsMyLinkHandlingAllowed");
    }
    return Future.value(null);
  }

  static Future<Map<String, int>?> getHostToStateMap(String packageName) async {
    if (Platform.isAndroid) {
      final result = await DefaultMethodChannel.invokeMethod("dvGetHostToStateMap", packageName);
      return result?.cast<String, int>();
    }
    return null;
  }

  static Future<Map<String, int>?> getMyHostToStateMap() async {
    if (Platform.isAndroid) {
      final result = await DefaultMethodChannel.invokeMethod("dvGetMyHostToStateMap");
      return result?.cast<String, int>();
    }
    return null;
  }

  static Future<bool?> toSettings(String packageName) {
    if (Platform.isAndroid) {
      return DefaultMethodChannel.invokeMethod("dvToSettings", packageName);
    }
    return Future.value(null);
  }

  static Future<bool?> toMySettings() {
    if (Platform.isAndroid) {
      return DefaultMethodChannel.invokeMethod("dvToMySettings");
    }
    return Future.value(null);
  }

  DomainVerificationPlugin._();
}
