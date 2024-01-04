import 'dart:io';

import 'package:path_provider/path_provider.dart';

enum StorageType {
  /// 持久存储类型
  files,

  /// 临时存储类型
  cache;

  /// 获取存储类型的[Directory]表示形式
  Future<Directory> get directory {
    switch (this) {
      case StorageType.files:
        return getApplicationSupportDirectory();
      case StorageType.cache:
        return getApplicationCacheDirectory();
    }
  }
}
