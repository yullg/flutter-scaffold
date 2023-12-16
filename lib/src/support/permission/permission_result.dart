import 'permission.dart';

/// 单权限授权结果。
class SinglePermissionResult {
  final Permission permission;
  final bool granted;

  /// 是否拒绝且不再响应授权请求。
  final bool permanentlyDenied;

  const SinglePermissionResult(this.permission, this.granted, this.permanentlyDenied);
}

/// 多权限授权结果。
class MultiplePermissionResult {
  final Map<Permission, SinglePermissionResult> permissionResultMap;

  const MultiplePermissionResult(this.permissionResultMap);

  /// 是否所有权限都已经授予。
  bool get allGranted {
    for (final entry in permissionResultMap.entries) {
      if (!entry.value.granted) {
        return false;
      }
    }
    return true;
  }

  /// 是否至少有一个权限已经授予。
  bool get anyGranted {
    for (final entry in permissionResultMap.entries) {
      if (entry.value.granted) {
        return true;
      }
    }
    return false;
  }

  /// 是否所有权限都已经拒绝且不再响应授权请求。
  bool get allDeniedForever {
    for (final permissionResult in permissionResultMap.values) {
      if (!permissionResult.permanentlyDenied) {
        return false;
      }
    }
    return true;
  }

  /// 是否至少有一个权限拒绝且不再响应授权请求。
  bool get anyDeniedForever {
    for (final permissionResult in permissionResultMap.values) {
      if (permissionResult.permanentlyDenied) {
        return true;
      }
    }
    return false;
  }
}
