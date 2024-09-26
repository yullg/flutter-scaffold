import 'package:dio/dio.dart';

import '../internal/scaffold_dio.dart';
import '../plugin/system_clock_plugin.dart';

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
        options: Options(
          responseType: ResponseType.json,
        ),
      );
      int secondsSinceEpoch = response.data["unixtime"];
      localLastNetworkTime = DateTime.fromMillisecondsSinceEpoch(
          secondsSinceEpoch * 1000,
          isUtc: true);
      localLastElapsedRealtime = await SystemClockPlugin.elapsedRealtime();
      _lastNetworkTime = localLastNetworkTime;
      _lastElapsedRealtime = localLastElapsedRealtime;
      return localLastNetworkTime;
    } else {
      final nowElapsedRealtime = await SystemClockPlugin.elapsedRealtime();
      return localLastNetworkTime
          .add(nowElapsedRealtime - localLastElapsedRealtime);
    }
  }

  NetworkTimeHelper._();
}
