import 'dart:io';

import 'android/android_media_store_plugin.dart';
import 'ios/ios_photo_library_plugin.dart';

class GallerySavePlugin {
  static Future<bool> hasSavePermission() {
    if (Platform.isAndroid) {
      return AndroidMediaStorePlugin.hasInsertPermission();
    } else {
      return IosPhotoLibraryPlugin.hasSavePermission();
    }
  }

  static Future<bool> requestSavePermission() {
    if (Platform.isAndroid) {
      return AndroidMediaStorePlugin.requestInsertPermission();
    } else {
      return IosPhotoLibraryPlugin.requestSavePermission();
    }
  }

  static Future<void> saveImage(
    File file, {
    String? displayName,
    String? mimeType,
  }) {
    if (Platform.isAndroid) {
      return AndroidMediaStorePlugin.insertImageFile(file: file, displayName: displayName, mimeType: mimeType);
    } else {
      return IosPhotoLibraryPlugin.saveImage(file: file);
    }
  }

  static Future<void> saveVideo(
    File file, {
    String? displayName,
    String? mimeType,
  }) {
    if (Platform.isAndroid) {
      return AndroidMediaStorePlugin.insertVideoFile(file: file, displayName: displayName, mimeType: mimeType);
    } else {
      return IosPhotoLibraryPlugin.saveVideo(file: file);
    }
  }

  GallerySavePlugin._();
}
