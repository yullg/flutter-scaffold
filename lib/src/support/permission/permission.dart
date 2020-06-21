import 'package:permission_handler/permission_handler.dart' as ph;

/// 定义可以检查和请求的权限。
enum Permission {
  /// See [ph.Permission.accessMediaLocation]
  ACCESS_MEDIA_LOCATION,

  /// See [ph.Permission.accessNotificationPolicy]
  ACCESS_NOTIFICATION_POLICY,

  /// See [ph.Permission.activityRecognition]
  ACTIVITY_RECOGNITION,

  /// See [ph.Permission.appTrackingTransparency]
  APP_TRACKING_TRANSPARENCY,

  /// See [ph.Permission.audio]
  AUDIO,

  /// See [ph.Permission.bluetooth]
  BLUETOOTH,

  /// See [ph.Permission.bluetoothAdvertise]
  BLUETOOTH_ADVERTISE,

  /// See [ph.Permission.bluetoothConnect]
  BLUETOOTH_CONNECT,

  /// See [ph.Permission.bluetoothScan]
  BLUETOOTH_SCAN,

  /// See [ph.Permission.calendar]
  CALENDAR,

  /// See [ph.Permission.camera]
  CAMERA,

  /// See [ph.Permission.contacts]
  CONTACTS,

  /// See [ph.Permission.criticalAlerts]
  CRITICAL_ALERTS,

  /// See [ph.Permission.ignoreBatteryOptimizations]
  IGNORE_BATTERY_OPTIMIZATIONS,

  /// See [ph.Permission.location]
  LOCATION,

  /// See [ph.Permission.locationAlways]
  LOCATION_ALWAYS,

  /// See [ph.Permission.locationWhenInUse]
  LOCATION_WHEN_IN_USE,

  /// See [ph.Permission.manageExternalStorage]
  MANAGE_EXTERNAL_STORAGE,

  /// See [ph.Permission.mediaLibrary]
  MEDIA_LIBRARY,

  /// See [ph.Permission.microphone]
  MICROPHONE,

  /// See [ph.Permission.nearbyWifiDevices]
  NEARBY_WIFI_DEVICES,

  /// See [ph.Permission.notification]
  NOTIFICATION,

  /// See [ph.Permission.phone]
  PHONE,

  /// See [ph.Permission.photos]
  PHOTOS,

  /// See [ph.Permission.photosAddOnly]
  PHOTOS_ADD_ONLY,

  /// See [ph.Permission.reminders]
  REMINDERS,

  /// See [ph.Permission.requestInstallPackages]
  REQUEST_INSTALL_PACKAGES,

  /// See [ph.Permission.scheduleExactAlarm]
  SCHEDULE_EXACT_ALARM,

  /// See [ph.Permission.sensors]
  SENSORS,

  /// See [ph.Permission.sms]
  SMS,

  /// See [ph.Permission.speech]
  SPEECH,

  /// See [ph.Permission.storage]
  STORAGE,

  /// See [ph.Permission.systemAlertWindow]
  SYSTEM_ALERT_WINDOW,

  /// See [ph.Permission.videos]
  VIDEOS,

  /// See [ph.Permission.unknown]
  UNKNOWN,
}
