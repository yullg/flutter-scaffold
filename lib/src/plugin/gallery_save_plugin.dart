import 'dart:io';

import 'android/android_media_store_plugin.dart';
import 'ios/ios_photo_library_plugin.dart';

class GallerySavePlugin {
  static Future<void> saveImage(
    File file, {
    String? displayName,
  }) {
    if (Platform.isAndroid) {
      return AndroidMediaStorePlugin.insertImageFile(
          file: file, displayName: displayName);
    } else {
      return IosPhotoLibraryPlugin.saveImage(file: file);
    }
  }

  static Future<void> saveVideo(
    File file, {
    String? displayName,
  }) {
    if (Platform.isAndroid) {
      return AndroidMediaStorePlugin.insertVideoFile(
          file: file, displayName: displayName);
    } else {
      return IosPhotoLibraryPlugin.saveVideo(file: file);
    }
  }

  GallerySavePlugin._();
}
