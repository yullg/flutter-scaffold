import 'dart:io';

import 'package:flutter/services.dart';

class AndroidContentResolverPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/content_resolver");

  static Future<ContentUriMetadata> getMetadata(Uri contentUri) {
    return _methodChannel
        .invokeMapMethod<String, dynamic>("getMetadata", contentUri.toString())
        .then<ContentUriMetadata>((value) => ContentUriMetadata(
              mimeType: value?["mimeType"],
              displayName: value?["displayName"],
              size: value?["size"],
            ));
  }

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

  static Future<Uri> createSubTreeUri({
    required Uri treeUri,
    required String displayName,
  }) {
    return _methodChannel.invokeMethod<String>("createSubTreeUri", {
      "treeUri": treeUri.toString(),
      "displayName": displayName,
    }).then<Uri>((value) => Uri.parse(value!));
  }

  static Future<Uri> copyFileToTreeUri({
    required File file,
    required Uri treeUri,
    String? mimeType,
    String? displayName,
  }) {
    return _methodChannel.invokeMethod<String>("copyFileToTreeUri", {
      "file": file.absolute.path,
      "treeUri": treeUri.toString(),
      "mimeType": mimeType,
      "displayName": displayName,
    }).then((value) => Uri.parse(value!));
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

class ContentUriMetadata {
  final String? mimeType;
  final String? displayName;
  final int? size;

  ContentUriMetadata({
    this.mimeType,
    this.displayName,
    this.size,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentUriMetadata &&
          runtimeType == other.runtimeType &&
          mimeType == other.mimeType &&
          displayName == other.displayName &&
          size == other.size;

  @override
  int get hashCode => mimeType.hashCode ^ displayName.hashCode ^ size.hashCode;

  @override
  String toString() {
    return 'ContentUriMetadata{mimeType: $mimeType, displayName: $displayName, size: $size}';
  }
}
