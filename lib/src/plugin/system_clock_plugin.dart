import 'package:system_clock/system_clock.dart';

class SystemClockPlugin {
  /// 返回自启动以来的时长，包括睡眠时间。
  static Future<Duration> elapsedRealtime() async => SystemClock.elapsedRealtime();

  /// 返回自启动以来的时长，不计算深度睡眠的时间。
  static Future<Duration> uptime() async => SystemClock.uptime();

  SystemClockPlugin._();
}
