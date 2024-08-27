import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AndroidMediaStorePlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/media_store");

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
      return Permission.storage.request().then<bool>((status) => status.isGranted);
    }
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
