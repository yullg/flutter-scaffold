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
    for (final entry in _PERMISSION_MAP.entries) {
      if (entry.key == permission) {
        return entry.value;
      }
    }
    throw UnsupportedError("The permission is not supported: $permission.");
  }

  static Permission _toPermission(ph.Permission phPermission) {
    for (final entry in _PERMISSION_MAP.entries) {
      if (entry.value == phPermission) {
        return entry.key;
      }
    }
    throw UnsupportedError("The permission is not supported: $phPermission.");
  }

  PermissionSupport._();
}

const Map<Permission, ph.Permission> _PERMISSION_MAP = {
  Permission.ACCESS_MEDIA_LOCATION: ph.Permission.accessMediaLocation,
  Permission.ACCESS_NOTIFICATION_POLICY: ph.Permission.accessNotificationPolicy,
  Permission.ACTIVITY_RECOGNITION: ph.Permission.activityRecognition,
  Permission.APP_TRACKING_TRANSPARENCY: ph.Permission.appTrackingTransparency,
  Permission.AUDIO: ph.Permission.audio,
  Permission.BLUETOOTH: ph.Permission.bluetooth,
  Permission.BLUETOOTH_ADVERTISE: ph.Permission.bluetoothAdvertise,
  Permission.BLUETOOTH_CONNECT: ph.Permission.bluetoothConnect,
  Permission.BLUETOOTH_SCAN: ph.Permission.bluetoothScan,
  Permission.CALENDAR_FULL_ACCESS: ph.Permission.calendarFullAccess,
  Permission.CALENDAR_WRITE_ONLY: ph.Permission.calendarWriteOnly,
  Permission.CAMERA: ph.Permission.camera,
  Permission.CONTACTS: ph.Permission.contacts,
  Permission.CRITICAL_ALERTS: ph.Permission.criticalAlerts,
  Permission.IGNORE_BATTERY_OPTIMIZATIONS: ph.Permission.ignoreBatteryOptimizations,
  Permission.LOCATION: ph.Permission.location,
  Permission.LOCATION_ALWAYS: ph.Permission.locationAlways,
  Permission.LOCATION_WHEN_IN_USE: ph.Permission.locationWhenInUse,
  Permission.MANAGE_EXTERNAL_STORAGE: ph.Permission.manageExternalStorage,
  Permission.MEDIA_LIBRARY: ph.Permission.mediaLibrary,
  Permission.MICROPHONE: ph.Permission.microphone,
  Permission.NEARBY_WIFI_DEVICES: ph.Permission.nearbyWifiDevices,
  Permission.NOTIFICATION: ph.Permission.notification,
  Permission.PHONE: ph.Permission.phone,
  Permission.PHOTOS: ph.Permission.photos,
  Permission.PHOTOS_ADD_ONLY: ph.Permission.photosAddOnly,
  Permission.REMINDERS: ph.Permission.reminders,
  Permission.REQUEST_INSTALL_PACKAGES: ph.Permission.requestInstallPackages,
  Permission.SCHEDULE_EXACT_ALARM: ph.Permission.scheduleExactAlarm,
  Permission.SENSORS: ph.Permission.sensors,
  Permission.SENSORS_ALWAYS: ph.Permission.sensorsAlways,
  Permission.SMS: ph.Permission.sms,
  Permission.SPEECH: ph.Permission.speech,
  Permission.STORAGE: ph.Permission.storage,
  Permission.SYSTEM_ALERT_WINDOW: ph.Permission.systemAlertWindow,
  Permission.VIDEOS: ph.Permission.videos,
  Permission.UNKNOWN: ph.Permission.unknown,
};
