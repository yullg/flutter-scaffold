import 'dart:io';

import 'package:flutter/services.dart';

class AndroidMediaStorePlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/media_store");

  static Future<bool> hasInsertPermission() {
    return _methodChannel.invokeMethod<bool>("hasInsertPermission").then<bool>((value) => value!);
  }

  static Future<Uri> insertAudio({
    required File file,
    String? displayName,
    String? mimeType,
  }) {
    return _methodChannel.invokeMethod<String>("insertAudio", {
      "file": file.absolute.path,
      "displayName": displayName,
      "mimeType": mimeType,
    }).then<Uri>((value) => Uri.parse(value!));
  }

  static Future<Uri> insertImage({
    required File file,
    String? displayName,
    String? mimeType,
  }) {
    return _methodChannel.invokeMethod<String>("insertImage", {
      "file": file.absolute.path,
      "displayName": displayName,
      "mimeType": mimeType,
    }).then<Uri>((value) => Uri.parse(value!));
  }

  static Future<Uri> insertVideo({
    required File file,
    String? displayName,
    String? mimeType,
  }) {
    return _methodChannel.invokeMethod<String>("insertVideo", {
      "file": file.absolute.path,
      "displayName": displayName,
      "mimeType": mimeType,
    }).then<Uri>((value) => Uri.parse(value!));
  }

  static Future<Uri> insertDownload({
    required File file,
    String? displayName,
    String? mimeType,
  }) {
    return _methodChannel.invokeMethod<String>("insertDownload", {
      "file": file.absolute.path,
      "displayName": displayName,
      "mimeType": mimeType,
    }).then<Uri>((value) => Uri.parse(value!));
  }

  AndroidMediaStorePlugin._();
}
