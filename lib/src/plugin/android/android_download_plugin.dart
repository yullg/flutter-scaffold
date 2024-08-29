import 'dart:async';

import 'package:flutter/services.dart';

import '../../helper/enum_helper.dart';
import '../../helper/format_helper.dart';

class AndroidDownloadPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/download");

  static const kDestinationExternalFilesDir = "externalFilesDir";
  static const kDestinationExternalPublicDir = "externalPublicDir";

  static const kNotificationVisibilityHidden = "hidden";
  static const kNotificationVisibilityVisible = "visible";
  static const kNotificationVisibilityVisibleNotifyCompleted = "visibleNotifyCompleted";

  static Future<int> enqueue({
    required Uri uri,
    String? filename,
    Map<String, String>? requestHeader,
    String? destination,
    bool? allowedOverMetered,
    bool? allowedOverRoaming,
    bool? requiresCharging,
    bool? requiresDeviceIdle,
    String? notificationVisibility,
    String? title,
    String? description,
  }) {
    return _methodChannel.invokeMethod<int>("enqueue", {
      "uri": uri.toString(),
      "filename": filename,
      "requestHeader": requestHeader,
      "destination": destination,
      "allowedOverMetered": allowedOverMetered,
      "allowedOverRoaming": allowedOverRoaming,
      "requiresCharging": requiresCharging,
      "requiresDeviceIdle": requiresDeviceIdle,
      "notificationVisibility": notificationVisibility,
      "title": title,
      "description": description,
    }).then<int>((value) => value!);
  }

  static Future<AndroidDownloadInfo?> find(int id) {
    return _methodChannel.invokeMethod("find", id).then<AndroidDownloadInfo?>((value) {
      if (value != null) {
        return AndroidDownloadInfo(
          status: EnumHelper.fromString(AndroidDownloadStatus.values, value["status"]),
          localUri: FormatHelper.tryParseUri(value["localUri"]),
          totalSize: value["totalSize"],
          bytesSoFar: value["bytesSoFar"],
        );
      } else {
        return null;
      }
    });
  }

  static Future<void> remove(int id) {
    return _methodChannel.invokeMethod("remove", id);
  }

  static Future<AndroidDownloadInfo?> waitDownload(
    int id, {
    Duration interval = const Duration(seconds: 1),
    void Function(AndroidDownloadInfo downloadInfo)? onProgress,
  }) async {
    while (true) {
      final downloadInfo = await find(id);
      if (downloadInfo == null) {
        return null;
      }
      onProgress?.call(downloadInfo);
      switch (downloadInfo.status) {
        case AndroidDownloadStatus.successful:
          final localUri = downloadInfo.localUri;
          if (localUri != null) {
            return downloadInfo;
          } else {
            throw StateError(downloadInfo.toString());
          }
        case AndroidDownloadStatus.failed:
          throw StateError(downloadInfo.toString());
        case AndroidDownloadStatus.paused:
        case AndroidDownloadStatus.pending:
        case AndroidDownloadStatus.running:
        case AndroidDownloadStatus.unknown:
          await Future.delayed(interval);
      }
    }
  }

  AndroidDownloadPlugin._();
}

enum AndroidDownloadStatus { failed, paused, pending, running, successful, unknown }

class AndroidDownloadInfo {
  final AndroidDownloadStatus status;
  final Uri? localUri;
  final int? totalSize;
  final int? bytesSoFar;

  AndroidDownloadInfo({
    required this.status,
    this.localUri,
    this.totalSize,
    this.bytesSoFar,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AndroidDownloadInfo &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          localUri == other.localUri &&
          totalSize == other.totalSize &&
          bytesSoFar == other.bytesSoFar;

  @override
  int get hashCode => status.hashCode ^ localUri.hashCode ^ totalSize.hashCode ^ bytesSoFar.hashCode;

  @override
  String toString() {
    return 'AndroidDownloadInfo{status: $status, localUri: $localUri, totalSize: $totalSize, bytesSoFar: $bytesSoFar}';
  }
}
