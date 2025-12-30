import 'package:flutter/services.dart';

class AndroidBasicPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/basic");

  static Future<T?> invoke<T>(AndroidBasicMethod<T> method) {
    return _methodChannel.invokeMethod<T>(method.method, method.arguments);
  }

  AndroidBasicPlugin._();
}

sealed class AndroidBasicMethod<T> {
  final String method;
  final dynamic arguments;

  const AndroidBasicMethod(this.method, [this.arguments]);
}

class SystemClockABM<T> extends AndroidBasicMethod<T> {
  /// 返回自启动以来的毫秒数，不包括睡眠时间。
  static const kUptimeMillis = SystemClockABM<int>._("SystemClockABM", "uptimeMillis");

  /// 返回自启动以来经过的毫秒数，包括睡眠时间。
  static const kElapsedRealtime = SystemClockABM<int>._("SystemClockABM", "elapsedRealtime");

  const SystemClockABM._(super.method, [super.arguments]);
}
