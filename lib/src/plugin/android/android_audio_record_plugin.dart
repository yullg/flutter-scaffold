import 'package:flutter/services.dart';

enum AndroidAudioRecordStatus { ready, started, stopped, released, unknown }

class AndroidAudioRecordPlugin {
  static const _eventChannel =
      EventChannel("com.yullg.flutter.scaffold/audio_record_event");
  static const _methodChannel =
      MethodChannel("com.yullg.flutter.scaffold/audio_record_method");

  static final eventStream = _eventChannel.receiveBroadcastStream();

  static final dataStream =
      eventStream.where((e) => e is Uint8List).cast<Uint8List>();

  static final statusStream = eventStream.where((e) {
    return e is Map && e["event"] == "status";
  }).map((e) => switch (e["value"]) {
        "READY" => AndroidAudioRecordStatus.ready,
        "STARTED" => AndroidAudioRecordStatus.started,
        "STOPPED" => AndroidAudioRecordStatus.stopped,
        "RELEASED" => AndroidAudioRecordStatus.released,
        _ => AndroidAudioRecordStatus.unknown,
      });

  static Future<void> resume() {
    return _methodChannel.invokeMethod("resume");
  }

  static Future<void> stop() {
    return _methodChannel.invokeMethod("stop");
  }

  static Future<void> release() {
    return _methodChannel.invokeMethod("release");
  }

  AndroidAudioRecordPlugin._();
}
