import '../internal/default_method_channel.dart';

class SystemClockPlugin {
  static Future<int> elapsedRealtime() {
    return DefaultMethodChannel.invokeMethod<int>("scElapsedRealtime").then((value) => value!);
  }

  static Future<int> uptimeMillis() {
    return DefaultMethodChannel.invokeMethod<int>("scUptimeMillis").then((value) => value!);
  }

  SystemClockPlugin._();
}
