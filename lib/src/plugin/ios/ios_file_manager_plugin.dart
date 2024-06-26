import 'package:flutter/services.dart';

class IosFileManagerPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/file_manager");

  static Future<void> createDirectory({
    required Uri at,
    required bool withIntermediateDirectories,
  }) {
    return _methodChannel.invokeMethod<void>("createDirectory", {
      "at": at.toString(),
      "withIntermediateDirectories": withIntermediateDirectories,
    });
  }

  static Future<void> copyItem({
    required Uri at,
    required Uri to,
  }) {
    return _methodChannel.invokeMethod<void>("copyItem", {
      "at": at.toString(),
      "to": to.toString(),
    });
  }

  static Future<void> moveItem({
    required Uri at,
    required Uri to,
  }) {
    return _methodChannel.invokeMethod<void>("moveItem", {
      "at": at.toString(),
      "to": to.toString(),
    });
  }

  IosFileManagerPlugin._();
}
