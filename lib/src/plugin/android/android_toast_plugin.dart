import 'package:flutter/services.dart';

class AndroidToastPlugin {
  static const _methodChannel =
      MethodChannel("com.yullg.flutter.scaffold/toast");

  static const int kDurationLengthShort = 1;
  static const int kDurationLengthLong = 2;

  static Future<void> show({
    required String text,
    int duration = kDurationLengthShort,
  }) {
    return _methodChannel.invokeMethod<void>("show", {
      "text": text,
      "duration": duration,
    });
  }

  static Future<void> cancel() {
    return _methodChannel.invokeMethod<void>("cancel");
  }

  AndroidToastPlugin._();
}
