import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 定义应用程序常用的几种存储目录。
enum StorageDirectory {
  /// 持久文件目录。
  FILES,

  /// 临时文件目录。
  CACHE;

  /// 获取存储目录的[Directory]表示形式。
  Future<Directory> get directory {
    switch (this) {
      case StorageDirectory.FILES:
        return getApplicationSupportDirectory();
      case StorageDirectory.CACHE:
        return getTemporaryDirectory();
    }
  }
}
