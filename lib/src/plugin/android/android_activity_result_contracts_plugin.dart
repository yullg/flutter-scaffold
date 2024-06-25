import 'package:flutter/services.dart';

class AndroidActivityResultContractsPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/activity_result_contracts");

  static Future<Uri?> createDocument({
    required String mimeType,
    required String name,
  }) {
    return _methodChannel.invokeMethod<String>("createDocument", {
      "mimeType": mimeType,
      "name": name,
    }).then((value) => value != null ? Uri.parse(value) : null);
  }

  static Future<Uri?> openDocument({
    required List<String> mimeTypes,
  }) {
    return _methodChannel.invokeMethod<String>("openDocument", {
      "mimeTypes": mimeTypes,
    }).then((value) => value != null ? Uri.parse(value) : null);
  }

  static Future<Uri?> openDocumentTree({
    Uri? initialLocation,
  }) {
    return _methodChannel.invokeMethod<String>("openDocumentTree", {
      "initialLocation": initialLocation?.toString(),
    }).then((value) => value != null ? Uri.parse(value) : null);
  }

  static Future<List<Uri>> openMultipleDocuments({
    required List<String> mimeTypes,
  }) {
    return _methodChannel.invokeListMethod<String>("openMultipleDocuments", {
      "mimeTypes": mimeTypes,
    }).then((value) => value != null ? value.map((e) => Uri.parse(e)).toList() : List<Uri>.empty());
  }

  AndroidActivityResultContractsPlugin._();
}
