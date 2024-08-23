import 'dart:io';

import 'package:flutter/services.dart';

class AndroidFileProviderPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/file_provider");

  static const int kFlagGrantReadUriPermission = 1;
  static const int kFlatGrantWriteUriPermission = 2;
  static const int kFlagGrantPersistableUriPermission = 64;
  static const int kFlagGrantPrefixUriPermission = 128;

  static Future<Directory> get files => _methodChannel.invokeMethod<String>("filesPath").then<Directory>((value) => Directory(value!));

  static Future<Directory> get cache => _methodChannel.invokeMethod<String>("cachePath").then<Directory>((value) => Directory(value!));

  static Future<Directory> get externalFiles =>
      _methodChannel.invokeMethod<String>("externalFilesPath").then<Directory>((value) => Directory(value!));

  static Future<Directory> get externalCache =>
      _methodChannel.invokeMethod<String>("externalCachePath").then<Directory>((value) => Directory(value!));

  static Future<Uri> getUriForFile({required File file, String? displayName}) {
    return _methodChannel.invokeMethod<String>("getUriForFile", {
      "file": file.absolute.path,
      "displayName": displayName,
    }).then<Uri>((value) => Uri.parse(value!));
  }

  static Future<void> grantUriPermission({
    required String toPackage,
    required Uri contentUri,
    required int modeFlags,
  }) async {
    await _methodChannel.invokeMethod("grantUriPermission", {
      "toPackage": toPackage,
      "contentUri": contentUri.toString(),
      "modeFlags": modeFlags,
    });
  }

  static Future<void> revokeUriPermission({
    required Uri contentUri,
    required int modeFlags,
  }) async {
    await _methodChannel.invokeMethod("revokeUriPermission", {
      "contentUri": contentUri.toString(),
      "modeFlags": modeFlags,
    });
  }

  AndroidFileProviderPlugin._();
}
