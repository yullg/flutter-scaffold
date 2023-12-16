import 'package:permission_handler/permission_handler.dart';

class SettingsHelper {
  static Future<void> openMyApplicationDetail() async {
    await openAppSettings();
  }

  SettingsHelper._();
}
