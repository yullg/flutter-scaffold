import 'package:flutter/services.dart';

class AndroidToastPlugin {
  static const _methodChannel =
      MethodChannel("com.yullg.flutter.scaffold/toast");

  static Future<void> show({
    required String text,
    bool isLongLength = false,
  }) {
    return _methodChannel.invokeMethod<void>("show", {
      "text": text,
      "isLongLength": isLongLength,
    });
  }

  AndroidToastPlugin._();
}
