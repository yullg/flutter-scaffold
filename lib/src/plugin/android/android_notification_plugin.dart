import 'package:flutter/services.dart';

class AndroidNotificationPlugin {
  static const _methodChannel =
      MethodChannel("com.yullg.flutter.scaffold/notification");

  /// 创建通知通道
  ///
  /// 参数说明请参考[官方文档](https://developer.android.com/reference/kotlin/androidx/core/app/NotificationChannelCompat.Builder)
  static Future<void> createNotificationChannel({
    required String id,
    required int importance,
    required String name,
    String? description,
    bool? vibrationEnabled,
    bool? lightsEnabled,
    bool? showBadge,
  }) {
    return _methodChannel.invokeMethod<void>("createNotificationChannel", {
      "id": id,
      "importance": importance,
      "name": name,
      "description": description,
      "vibrationEnabled": vibrationEnabled,
      "lightsEnabled": lightsEnabled,
      "showBadge": showBadge,
    });
  }
}
