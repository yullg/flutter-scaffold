import 'package:flutter/services.dart';

class AndroidMediaProjectionPlugin {
  static const _methodChannel =
      MethodChannel("com.yullg.flutter.scaffold/media_projection");

  static Future<void> authorize() {
    return _methodChannel.invokeMethod<void>("authorize");
  }

  AndroidMediaProjectionPlugin._();
}
