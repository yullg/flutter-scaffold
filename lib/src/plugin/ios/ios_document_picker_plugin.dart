import '../../internal/default_method_channel.dart';

class IosDocumentPickerPlugin {
  static Future<List<String>> importDocument({
    required List<String> allowedUTIs,
    bool asCopy = false,
    bool allowsMultipleSelection = false,
  }) {
    return DefaultMethodChannel.invokeListMethod<String>("dpImportDocument", {
      "allowedUTIs": allowedUTIs,
      "asCopy": asCopy,
      "allowsMultipleSelection": allowsMultipleSelection,
    }).then((value) => value ?? List<String>.empty());
  }

  static Future<List<String>> exportDocument({
    required List<String> urls,
    bool asCopy = true,
  }) {
    return DefaultMethodChannel.invokeListMethod<String>("dpExportDocument", {
      "urls": urls,
      "asCopy": asCopy,
    }).then((value) => value ?? List<String>.empty());
  }

  IosDocumentPickerPlugin._();
}
