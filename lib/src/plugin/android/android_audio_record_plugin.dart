import 'package:flutter/services.dart';

class AndroidAudioRecordPlugin {
  static const _eventChannel =
      EventChannel("com.yullg.flutter.scaffold/audio_record_event");
  static const _methodChannel =
      MethodChannel("com.yullg.flutter.scaffold/audio_record_method");

  static final eventStream = _eventChannel.receiveBroadcastStream();

  static Future<void> startAudioPlaybackCapture({
    required int notificationId,
    required String notificationChannelId,
    String? notificationContentTitle,
    String? notificationContentText,
  }) {
    return _methodChannel.invokeMethod("startAudioPlaybackCapture", {
      "notificationId": notificationId,
      "notificationChannelId": notificationChannelId,
      "notificationContentTitle": notificationContentTitle,
      "notificationContentText": notificationContentText,
    });
  }

  static Future<void> resume() {
    return _methodChannel.invokeMethod("resume");
  }

  static Future<void> stop() {
    return _methodChannel.invokeMethod("stop");
  }

  static Future<void> release() {
    return _methodChannel.invokeMethod("release");
  }
}
