import 'package:flutter/services.dart';

class IosUrlPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/url");

  static Future<Uri> createFileURL({
    required String fileURLWithPath,
    bool? isDirectory,
    Uri? relativeTo,
  }) {
    return _methodChannel.invokeMethod<String>("createFileURL", {
      "fileURLWithPath": fileURLWithPath,
      "isDirectory": isDirectory,
      "relativeTo": relativeTo?.toString(),
    }).then((value) => Uri.parse(value!));
  }

  static Future<bool> startAccessingSecurityScopedResource(Uri uri) {
    return _methodChannel.invokeMethod<bool>("startAccessingSecurityScopedResource", {
      "url": uri.toString(),
    }).then<bool>((value) => value!);
  }

  static Future<void> stopAccessingSecurityScopedResource(Uri uri) {
    return _methodChannel.invokeMethod<void>("stopAccessingSecurityScopedResource", {
      "url": uri.toString(),
    });
  }

  IosUrlPlugin._();
}
