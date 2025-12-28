import 'dart:io';

import 'android/android_basic_plugin.dart';
import 'ios/ios_basic_plugin.dart';

class SystemClockPlugin {
  /// 返回自启动以来的时长，包括睡眠时间。
  static Future<Duration> elapsedRealtime() {
    if (Platform.isAndroid) {
      return AndroidBasicPlugin.invoke(
        SystemClockABM.kElapsedRealtime,
      ).then((v) => v != null ? Duration(milliseconds: v) : Duration.zero);
    } else {
      return IsoBasicPlugin.invoke(
        ProcessInfoIBM.kSystemUptime,
      ).then((v) => v != null ? Duration(seconds: v.round()) : Duration.zero);
    }
  }

  /// 返回自启动以来的时长，不计算深度睡眠的时间。
  static Future<Duration> uptime() {
    if (Platform.isAndroid) {
      return AndroidBasicPlugin.invoke(
        SystemClockABM.kUptimeMillis,
      ).then((v) => v != null ? Duration(milliseconds: v) : Duration.zero);
    } else {
      return IsoBasicPlugin.invoke(
        ProcessInfoIBM.kSystemUptime,
      ).then((v) => v != null ? Duration(seconds: v.round()) : Duration.zero);
    }
  }

  SystemClockPlugin._();
}
