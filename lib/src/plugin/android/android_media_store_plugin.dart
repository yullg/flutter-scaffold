import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AndroidMediaStorePlugin {
  static const _methodChannel =
      MethodChannel("com.yullg.flutter.scaffold/media_store");

  static Future<bool> hasInsertPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 29) {
      return true;
    } else {
      return Permission.storage.isGranted;
    }
  }

  static Future<bool> requestInsertPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 29) {
      return true;
    } else {
      return Permission.storage
          .request()
          .then<bool>((status) => status.isGranted);
    }
  }

  static Future<Uri?> insertAudio() {
    return _methodChannel
        .invokeMethod<String>("insertAudio")
        .then<Uri?>((value) => value != null ? Uri.parse(value) : null);
  }

  static Future<Uri?> insertImage() {
    return _methodChannel
        .invokeMethod<String>("insertImage")
        .then<Uri?>((value) => value != null ? Uri.parse(value) : null);
  }

  static Future<Uri?> insertVideo() {
    return _methodChannel
        .invokeMethod<String>("insertVideo")
        .then<Uri?>((value) => value != null ? Uri.parse(value) : null);
  }

  static Future<Uri> insertAudioFile({
    required File file,
    String? displayName,
    String? mimeType,
  }) {
    return _methodChannel.invokeMethod<String>("insertAudioFile", {
      "file": file.absolute.path,
      "displayName": displayName,
      "mimeType": mimeType,
    }).then<Uri>((value) => Uri.parse(value!));
  }

  static Future<Uri> insertImageFile({
    required File file,
    String? displayName,
    String? mimeType,
  }) {
    return _methodChannel.invokeMethod<String>("insertImageFile", {
      "file": file.absolute.path,
      "displayName": displayName,
      "mimeType": mimeType,
    }).then<Uri>((value) => Uri.parse(value!));
  }

  static Future<Uri> insertVideoFile({
    required File file,
    String? displayName,
    String? mimeType,
  }) {
    return _methodChannel.invokeMethod<String>("insertVideoFile", {
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
    return _methodChannel.invokeMethod<String>("insertDownloadFile", {
      "file": file.absolute.path,
      "displayName": displayName,
      "mimeType": mimeType,
    }).then<Uri>((value) => Uri.parse(value!));
  }

  AndroidMediaStorePlugin._();
}
