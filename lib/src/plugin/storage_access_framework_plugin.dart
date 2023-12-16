import '../internal/default_method_channel.dart';

class StorageAccessFrameworkPlugin {
  static Future<String?> openDocument(List<String> mimeTypes) {
    return DefaultMethodChannel.invokeMethod("safOpenDocument", mimeTypes);
  }

  StorageAccessFrameworkPlugin._();
}
