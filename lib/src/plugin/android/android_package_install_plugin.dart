import '../../internal/default_method_channel.dart';

class AndroidPackageInstallPlugin {
  static Future<void> install({required Uri uri}) async {
    await DefaultMethodChannel.invokeMethod("piInstall", {
      "uri": uri.toString(),
    });
  }

  AndroidPackageInstallPlugin._();
}
