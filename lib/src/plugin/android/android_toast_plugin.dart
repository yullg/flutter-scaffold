import 'package:flutter/services.dart';

class AndroidToastPlugin {
  static const _methodChannel =
      MethodChannel("com.yullg.flutter.scaffold/toast");

  static Future<void> show({
    required String text,
    bool longDuration = false,
  }) async {
    await _methodChannel.invokeMethod("show", {
      "text": text,
      "longDuration": longDuration,
    });
  }

  AndroidToastPlugin._();
}
