import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import 'android_file_provider_plugin.dart';

class AndroidPackageInstallPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/package_install");

  static Future<bool> canRequestPackageInstalls() {
    return _methodChannel.invokeMethod<bool>("canRequestPackageInstalls").then<bool>((value) => value!);
  }

  static Future<void> requestPackageInstallsPermission() async {
    await _methodChannel.invokeMethod("requestPackageInstallsPermission");
  }

  static Future<void> install({required Uri contentUri}) async {
    await _methodChannel.invokeMethod("install", {
      "contentUri": contentUri.toString(),
    });
  }

  static Future<void> installFile({required File file, String? shareFileName}) async {
    final shareDirectory = await AndroidFileProviderPlugin.externalCache;
    final shareFile = File(p.join(shareDirectory.path, shareFileName ?? p.basename(file.path)));
    await shareFile.parent.create(recursive: true);
    await file.copy(shareFile.path);
    final contentUri = await AndroidFileProviderPlugin.getUriForFile(file: shareFile);
    await install(contentUri: contentUri);
  }

  static Future<void> classicalInstall({required Uri contentUri}) async {
    await _methodChannel.invokeMethod("classicalInstall", {
      "contentUri": contentUri.toString(),
    });
  }

  static Future<void> classicalInstallFile({required File file, String? shareFileName}) async {
    final shareDirectory = await AndroidFileProviderPlugin.externalCache;
    final shareFile = File(p.join(shareDirectory.path, shareFileName ?? p.basename(file.path)));
    await shareFile.parent.create(recursive: true);
    await file.copy(shareFile.path);
    final contentUri = await AndroidFileProviderPlugin.getUriForFile(file: shareFile);
    await classicalInstall(contentUri: contentUri);
  }

  AndroidPackageInstallPlugin._();
}
