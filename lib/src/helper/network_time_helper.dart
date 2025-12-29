import 'dart:io';

import 'package:dio/dio.dart';

import '../internal/scaffold_dio.dart';
import '../plugin/android/android_basic_plugin.dart';
import '../plugin/ios/ios_basic_plugin.dart';

class NetworkTimeHelper {
  static DateTime? _lastNetworkTime;
  static Duration? _lastElapsedRealtime;

  /// 获取具有当前UTC日期和时间的DateTime。
  static Future<DateTime> now() async {
    DateTime? localLastNetworkTime = _lastNetworkTime;
    Duration? localLastElapsedRealtime = _lastElapsedRealtime;
    if (localLastNetworkTime == null || localLastElapsedRealtime == null) {
      final response = await ScaffoldDio().get(
        "https://worldtimeapi.org/api/timezone/Etc/UTC",
        options: Options(responseType: ResponseType.json),
      );
      int secondsSinceEpoch = response.data["unixtime"];
      localLastNetworkTime = DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000, isUtc: true);
      localLastElapsedRealtime = await _elapsedRealtime();
      _lastNetworkTime = localLastNetworkTime;
      _lastElapsedRealtime = localLastElapsedRealtime;
      return localLastNetworkTime;
    } else {
      final nowElapsedRealtime = await _elapsedRealtime();
      return localLastNetworkTime.add(nowElapsedRealtime - localLastElapsedRealtime);
    }
  }

  // 返回自启动以来的时长，包括睡眠时间。
  static Future<Duration> _elapsedRealtime() {
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

  NetworkTimeHelper._();
}
