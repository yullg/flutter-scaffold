import 'package:flutter/services.dart';

class AndroidIntentPlugin {
  static const _methodChannel =
      MethodChannel("com.yullg.flutter.scaffold/intent");

  static const kActionPickTypeAudio = "audio";
  static const kActionPickTypeImage = "image";
  static const kActionPickTypeVideo = "video";

  static Future<bool> imageCapture({
    required Uri outputContentUri,
    bool forcingChooser = false,
    String? chooserTitle,
  }) {
    return _methodChannel.invokeMethod<bool>("imageCapture", {
      "outputContentUri": outputContentUri.toString(),
      "forcingChooser": forcingChooser,
      "chooserTitle": chooserTitle,
    }).then<bool>((value) => value!);
  }

  static Future<bool> videoCapture({
    required Uri outputContentUri,
    bool forcingChooser = false,
    String? chooserTitle,
  }) {
    return _methodChannel.invokeMethod<bool>("videoCapture", {
      "outputContentUri": outputContentUri.toString(),
      "forcingChooser": forcingChooser,
      "chooserTitle": chooserTitle,
    }).then<bool>((value) => value!);
  }

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
    }).then((value) => value != null
        ? value.map((e) => Uri.parse(e)).toList()
        : List<Uri>.empty());
  }

  static Future<Uri?> actionPick({
    required String type,
  }) {
    return _methodChannel.invokeMethod("actionPick", {
      "type": type,
    }).then<Uri?>((value) => value != null ? Uri.parse(value) : null);
  }

  AndroidIntentPlugin._();
}
