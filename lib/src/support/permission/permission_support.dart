import 'package:permission_handler/permission_handler.dart' as ph;

import 'permission.dart';
import 'permission_result.dart';

/// 提供权限授权流程。
class PermissionSupport {
  /// 单权限授权检查。
  static Future<SinglePermissionResult> checkPermission(Permission permission) async {
    var status = await _toPhPermission(permission).status;
    return SinglePermissionResult(permission, status.isGranted, status.isPermanentlyDenied);
  }

  /// 单权限授权请求。
  static Future<SinglePermissionResult> requestPermission(Permission permission) async {
    var status = await _toPhPermission(permission).request();
    return SinglePermissionResult(permission, status.isGranted, status.isPermanentlyDenied);
  }

  /// 多权限授权检查。
  static Future<MultiplePermissionResult> checkPermissions(Iterable<Permission> permissions) async {
    var resultMap = <Permission, SinglePermissionResult>{};
    for (final permission in permissions) {
      var status = await _toPhPermission(permission).status;
      resultMap[permission] = SinglePermissionResult(permission, status.isGranted, status.isPermanentlyDenied);
    }
    return MultiplePermissionResult(resultMap);
  }

  /// 多权限授权请求。
  static Future<MultiplePermissionResult> requestPermissions(Iterable<Permission> permissions) async {
    var statusMap = await permissions.map((e) => _toPhPermission(e)).toList().request();
    var resultMap = <Permission, SinglePermissionResult>{};
    for (final entry in statusMap.entries) {
      var permission = _toPermission(entry.key);
      resultMap[permission] =
          SinglePermissionResult(permission, entry.value.isGranted, entry.value.isPermanentlyDenied);
    }
    return MultiplePermissionResult(resultMap);
  }

  static ph.Permission _toPhPermission(Permission permission) {
    for (final entry in _kPermissionMap.entries) {
      if (entry.key == permission) {
        return entry.value;
      }
    }
    throw UnsupportedError("The permission is not supported: $permission.");
  }

  static Permission _toPermission(ph.Permission phPermission) {
    for (final entry in _kPermissionMap.entries) {
      if (entry.value == phPermission) {
        return entry.key;
      }
    }
    throw UnsupportedError("The permission is not supported: $phPermission.");
  }

  PermissionSupport._();
}

const Map<Permission, ph.Permission> _kPermissionMap = {
  Permission.accessMediaLocation: ph.Permission.accessMediaLocation,
  Permission.accessNotificationPolicy: ph.Permission.accessNotificationPolicy,
  Permission.activityRecognition: ph.Permission.activityRecognition,
  Permission.appTrackingTransparency: ph.Permission.appTrackingTransparency,
  Permission.audio: ph.Permission.audio,
  Permission.bluetooth: ph.Permission.bluetooth,
  Permission.bluetoothAdvertise: ph.Permission.bluetoothAdvertise,
  Permission.bluetoothConnect: ph.Permission.bluetoothConnect,
  Permission.bluetoothScan: ph.Permission.bluetoothScan,
  Permission.calendarFullAccess: ph.Permission.calendarFullAccess,
  Permission.calendarWriteOnly: ph.Permission.calendarWriteOnly,
  Permission.camera: ph.Permission.camera,
  Permission.contacts: ph.Permission.contacts,
  Permission.criticalAlerts: ph.Permission.criticalAlerts,
  Permission.ignoreBatteryOptimizations: ph.Permission.ignoreBatteryOptimizations,
  Permission.location: ph.Permission.location,
  Permission.locationAlways: ph.Permission.locationAlways,
  Permission.locationWhenInUse: ph.Permission.locationWhenInUse,
  Permission.manageExternalStorage: ph.Permission.manageExternalStorage,
  Permission.mediaLibrary: ph.Permission.mediaLibrary,
  Permission.microphone: ph.Permission.microphone,
  Permission.nearbyWifiDevices: ph.Permission.nearbyWifiDevices,
  Permission.notification: ph.Permission.notification,
  Permission.phone: ph.Permission.phone,
  Permission.photos: ph.Permission.photos,
  Permission.photosAddOnly: ph.Permission.photosAddOnly,
  Permission.reminders: ph.Permission.reminders,
  Permission.requestInstallPackages: ph.Permission.requestInstallPackages,
  Permission.scheduleExactAlarm: ph.Permission.scheduleExactAlarm,
  Permission.sensors: ph.Permission.sensors,
  Permission.sensorsAlways: ph.Permission.sensorsAlways,
  Permission.sms: ph.Permission.sms,
  Permission.speech: ph.Permission.speech,
  Permission.storage: ph.Permission.storage,
  Permission.systemAlertWindow: ph.Permission.systemAlertWindow,
  Permission.videos: ph.Permission.videos,
  Permission.unknown: ph.Permission.unknown,
};
