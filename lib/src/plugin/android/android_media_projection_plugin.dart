import 'package:flutter/services.dart';

class AndroidMediaProjectionPlugin {
  static const _methodChannel =
      MethodChannel("com.yullg.flutter.scaffold/media_projection");

  static Future<void> start() {
    return _methodChannel.invokeMethod("start");
  }

  static Future<void> stop() {
    return _methodChannel.invokeMethod("stop");
  }
}
