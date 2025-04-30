import 'dart:io';

import 'package:flutter/services.dart';

class IosPhotoLibraryPlugin {
  static const _methodChannel =
      MethodChannel("com.yullg.flutter.scaffold/photo_library");

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
