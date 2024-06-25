import 'package:flutter/services.dart';

class AndroidToastPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/toast");

  static Future<void> show({
    required String text,
    bool longTime = false,
  }) async {
    await _methodChannel.invokeMethod("show", {
      "text": text,
      "longTime": longTime,
    });
  }

  AndroidToastPlugin._();
}
