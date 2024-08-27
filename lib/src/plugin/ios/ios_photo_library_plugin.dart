import 'dart:io';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class IosPhotoLibraryPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/photo_library");

  static Future<bool> hasSavePermission() {
    return Permission.photosAddOnly.isGranted;
  }

  static Future<bool> requestSavePermission() {
    return Permission.photosAddOnly.request().then<bool>((status) => status.isGranted);
  }

  static Future<void> saveImage({required File file}) {
    return _methodChannel.invokeMethod<void>("saveImage", {
      "file": file.absolute.path,
    });
  }

  static Future<void> saveVideo({required File file}) {
    return _methodChannel.invokeMethod<void>("saveVideo", {
      "file": file.absolute.path,
    });
  }

  IosPhotoLibraryPlugin._();
}
