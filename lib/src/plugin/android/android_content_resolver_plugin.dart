import '../../internal/default_method_channel.dart';

class AndroidContentResolverPlugin {
  static Future<void> writeFromFile({
    required String atFilePath,
    required String toContentUri,
  }) async {
    await DefaultMethodChannel.invokeMethod("crWriteFromFile", {
      "atFilePath": atFilePath,
      "toContentUri": toContentUri,
    });
  }

  static Future<void> readToFile({
    required String atContentUri,
    required String toFilePath,
  }) async {
    await DefaultMethodChannel.invokeMethod("crReadToFile", {
      "atContentUri": atContentUri,
      "toFilePath": toFilePath,
    });
  }

  static Future<String?> getExtensionFromContentUri({
    required String contentUri,
  }) {
    return DefaultMethodChannel.invokeMethod(
      "crGetExtensionFromContentUri",
      contentUri,
    );
  }

  AndroidContentResolverPlugin._();
}
