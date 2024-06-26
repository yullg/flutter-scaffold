import 'package:flutter/services.dart';

class IosDocumentPickerPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/document_picker");

  static Future<List<Uri>> import({
    required List<String> forOpeningContentTypes,
    required bool asCopy,
    Uri? directoryURL,
    bool? allowsMultipleSelection,
    bool? shouldShowFileExtensions,
  }) {
    return _methodChannel.invokeListMethod<String>("import", {
      "forOpeningContentTypes": forOpeningContentTypes,
      "asCopy": asCopy,
      "directoryURL": directoryURL?.toString(),
      "allowsMultipleSelection": allowsMultipleSelection,
      "shouldShowFileExtensions": shouldShowFileExtensions,
    }).then<List<Uri>>((value) => value != null ? value.map((e) => Uri.parse(e)).toList() : List<Uri>.empty());
  }

  static Future<List<Uri>> export({
    required List<Uri> forExporting,
    required bool asCopy,
    Uri? directoryURL,
    bool? shouldShowFileExtensions,
  }) {
    return _methodChannel.invokeListMethod<String>("export", {
      "forExporting": forExporting.map((e) => e.toString()).toList(growable: false),
      "asCopy": asCopy,
      "directoryURL": directoryURL?.toString(),
      "shouldShowFileExtensions": shouldShowFileExtensions,
    }).then<List<Uri>>((value) => value != null ? value.map((e) => Uri.parse(e)).toList() : List<Uri>.empty());
  }

  IosDocumentPickerPlugin._();
}
