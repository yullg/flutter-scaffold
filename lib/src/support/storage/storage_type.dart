import 'dart:io';

import 'package:path_provider/path_provider.dart';

enum StorageType {
  /// 持久存储类型
  FILES,

  /// 临时存储类型
  CACHE;

  /// 获取存储类型的[Directory]表示形式
  Future<Directory> get directory {
    switch (this) {
      case StorageType.FILES:
        return getApplicationSupportDirectory();
      case StorageType.CACHE:
        return getTemporaryDirectory();
    }
  }
}
