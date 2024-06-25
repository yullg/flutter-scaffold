import 'package:flutter/services.dart';

class AndroidDomainVerificationPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/domain_verification");

  static const int kDomainStateNone = 0;
  static const int kDomainStateSelected = 1;
  static const int kDomainStateVerified = 2;

  static Future<bool?> isLinkHandlingAllowed({
    String? packageName,
  }) {
    return _methodChannel.invokeMethod<bool>("isLinkHandlingAllowed", packageName);
  }

  static Future<Map<String, int>?> getHostToStateMap({
    String? packageName,
  }) {
    return _methodChannel.invokeMapMethod<String, int>("getHostToStateMap", packageName);
  }

  static Future<void> toSettings({
    String? packageName,
  }) async {
    await _methodChannel.invokeMethod("toSettings", packageName);
  }

  AndroidDomainVerificationPlugin._();
}
