import 'dart:io';

import 'package:flutter/services.dart';

class AndroidContentResolverPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/content_resolver");

  static Future<void> copyFileToContentUri({
    required File file,
    required Uri contentUri,
  }) async {
    await _methodChannel.invokeMethod("copyFileToContentUri", {
      "file": file.absolute.path,
      "contentUri": contentUri.toString(),
    });
  }

  static Future<void> copyContentUriToFile({
    required Uri contentUri,
    required File file,
  }) async {
    await _methodChannel.invokeMethod("copyContentUriToFile", {
      "contentUri": contentUri.toString(),
      "file": file.absolute.path,
    });
  }

  static Future<String?> getType({
    required Uri contentUri,
  }) {
    return _methodChannel.invokeMethod<String>("getType", contentUri.toString());
  }

  static Future<Uri> createSubTreeUri({
    required Uri treeUri,
    required String displayName,
  }) {
    return _methodChannel.invokeMethod<String>("createSubTreeUri", {
      "treeUri": treeUri.toString(),
      "displayName": displayName,
    }).then<Uri>((value) => Uri.parse(value!));
  }

  static Future<void> copyFileToTreeUri({
    required File file,
    required Uri treeUri,
    String? mimeType,
    String? displayName,
  }) async {
    await _methodChannel.invokeMethod("copyFileToTreeUri", {
      "file": file.absolute.path,
      "treeUri": treeUri.toString(),
      "mimeType": mimeType,
      "displayName": displayName,
    });
  }

  static Future<void> copyDirectoryToTreeUri({
    required Directory directory,
    required Uri treeUri,
  }) async {
    await _methodChannel.invokeMethod("copyDirectoryToTreeUri", {
      "directory": directory.absolute.path,
      "treeUri": treeUri.toString(),
    });
  }

  AndroidContentResolverPlugin._();
}
