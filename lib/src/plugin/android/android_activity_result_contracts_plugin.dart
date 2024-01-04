import '../../internal/default_method_channel.dart';

class AndroidActivityResultContractsPlugin {
  static Future<String?> createDocument({
    required String mimeType,
    required String name,
  }) {
    return DefaultMethodChannel.invokeMethod("arcCreateDocument", {
      "mimeType": mimeType,
      "name": name,
    });
  }

  static Future<List<String>> openDocument({
    required List<String> mimeTypes,
    bool allowsMultipleSelection = false,
  }) {
    return DefaultMethodChannel.invokeListMethod<String>("arcOpenDocument", {
      "mimeTypes": mimeTypes,
      "allowsMultipleSelection": allowsMultipleSelection,
    }).then((value) => value ?? List<String>.empty());
  }

  AndroidActivityResultContractsPlugin._();
}
