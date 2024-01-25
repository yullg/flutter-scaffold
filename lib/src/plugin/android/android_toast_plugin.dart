import '../../internal/default_method_channel.dart';

class AndroidToastPlugin {
  static Future<void> show({
    required String text,
    bool longTime = false,
  }) async {
    await DefaultMethodChannel.invokeMethod("toastShow", {
      "text": text,
      "longTime": longTime,
    });
  }

  AndroidToastPlugin._();
}
