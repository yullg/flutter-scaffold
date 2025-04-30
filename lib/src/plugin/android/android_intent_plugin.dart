import 'package:flutter/services.dart';

class AndroidIntentPlugin {
  static const _methodChannel =
      MethodChannel("com.yullg.flutter.scaffold/intent");

  static const int kActionPickTypeAudio = 1;
  static const int kActionPickTypeImage = 2;
  static const int kActionPickTypeVideo = 3;

  static Future<Uri?> actionPick({
    required int type,
    bool forcingChooser = false,
    String? chooserTitle,
  }) {
    return _methodChannel.invokeMethod("actionPick", {
      "type": type,
      "forcingChooser": forcingChooser,
      "chooserTitle": chooserTitle,
    }).then<Uri?>((value) => value != null ? Uri.parse(value) : null);
  }

  static Future<bool> takePicture({
    required Uri outputContentUri,
    bool forcingChooser = false,
    String? chooserTitle,
  }) {
    return _methodChannel.invokeMethod<bool>("takePicture", {
      "outputContentUri": outputContentUri.toString(),
      "forcingChooser": forcingChooser,
      "chooserTitle": chooserTitle,
    }).then<bool>((value) => value!);
  }

  static Future<bool> captureVideo({
    required Uri outputContentUri,
    bool forcingChooser = false,
    String? chooserTitle,
  }) {
    return _methodChannel.invokeMethod<bool>("captureVideo", {
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

  AndroidIntentPlugin._();
}
