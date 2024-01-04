import 'package:permission_handler/permission_handler.dart' as ph;

/// 定义可以检查和请求的权限。
enum Permission {
  /// See [ph.Permission.accessMediaLocation]
  accessMediaLocation,

  /// See [ph.Permission.accessNotificationPolicy]
  accessNotificationPolicy,

  /// See [ph.Permission.activityRecognition]
  activityRecognition,

  /// See [ph.Permission.appTrackingTransparency]
  appTrackingTransparency,

  /// See [ph.Permission.audio]
  audio,

  /// See [ph.Permission.bluetooth]
  bluetooth,

  /// See [ph.Permission.bluetoothAdvertise]
  bluetoothAdvertise,

  /// See [ph.Permission.bluetoothConnect]
  bluetoothConnect,

  /// See [ph.Permission.bluetoothScan]
  bluetoothScan,

  /// See [ph.Permission.calendarFullAccess]
  calendarFullAccess,

  /// See [ph.Permission.calendarWriteOnly]
  calendarWriteOnly,

  /// See [ph.Permission.camera]
  camera,

  /// See [ph.Permission.contacts]
  contacts,

  /// See [ph.Permission.criticalAlerts]
  criticalAlerts,

  /// See [ph.Permission.ignoreBatteryOptimizations]
  ignoreBatteryOptimizations,

  /// See [ph.Permission.location]
  location,

  /// See [ph.Permission.locationAlways]
  locationAlways,

  /// See [ph.Permission.locationWhenInUse]
  locationWhenInUse,

  /// See [ph.Permission.manageExternalStorage]
  manageExternalStorage,

  /// See [ph.Permission.mediaLibrary]
  mediaLibrary,

  /// See [ph.Permission.microphone]
  microphone,

  /// See [ph.Permission.nearbyWifiDevices]
  nearbyWifiDevices,

  /// See [ph.Permission.notification]
  notification,

  /// See [ph.Permission.phone]
  phone,

  /// See [ph.Permission.photos]
  photos,

  /// See [ph.Permission.photosAddOnly]
  photosAddOnly,

  /// See [ph.Permission.reminders]
  reminders,

  /// See [ph.Permission.requestInstallPackages]
  requestInstallPackages,

  /// See [ph.Permission.scheduleExactAlarm]
  scheduleExactAlarm,

  /// See [ph.Permission.sensors]
  sensors,

  /// See [ph.Permission.sensorsAlways]
  sensorsAlways,

  /// See [ph.Permission.sms]
  sms,

  /// See [ph.Permission.speech]
  speech,

  /// See [ph.Permission.storage]
  storage,

  /// See [ph.Permission.systemAlertWindow]
  systemAlertWindow,

  /// See [ph.Permission.videos]
  videos,

  /// See [ph.Permission.unknown]
  unknown,
}
