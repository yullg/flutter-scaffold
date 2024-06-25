import 'package:flutter/services.dart';

class AndroidPackageInstallPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/package_install");

  static Future<void> install({required Uri uri}) async {
    await _methodChannel.invokeMethod("install", {
      "uri": uri.toString(),
    });
  }

  AndroidPackageInstallPlugin._();
}
