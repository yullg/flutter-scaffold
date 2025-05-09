import 'dart:convert';

import 'package:flutter/services.dart';

class AndroidMediaProjectionPlugin {
  static const _methodChannel =
      MethodChannel("com.yullg.flutter.scaffold/media_projection");

  static Future<void> authorize() {
    return _methodChannel.invokeMethod<void>("authorize");
  }

  static Future<void> startAudioPlaybackCapture({
    required int notificationId,
    required String notificationChannelId,
    String? notificationContentTitle,
    String? notificationContentText,
    int sampleRate = 44100,
    bool stereo = true,
  }) {
    return _methodChannel.invokeMethod<void>("startAudioPlaybackCapture", {
      "notification": jsonEncode({
        "id": notificationId,
        "channelId": notificationChannelId,
        "contentTitle": notificationContentTitle,
        "contentText": notificationContentText,
      }),
      "recorder": jsonEncode({
        "sampleRate": sampleRate,
        "stereo": stereo,
      }),
    });
  }

  AndroidMediaProjectionPlugin._();
}
