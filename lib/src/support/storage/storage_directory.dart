import 'dart:io';

import 'package:path/path.dart' as p;

import '../../helper/enum_helper.dart';
import 'storage_type.dart';

/// 表示存储在由[StorageType]定义的存储目录中的文件夹，
/// 并且提供与`String`表示形式的互相转换来避免依赖绝对路径。
class StorageDirectory {
  final StorageType storageType;
  final String relativePath;

  const StorageDirectory(this.storageType, this.relativePath);

  /// 获取存储文件的[Directory]表示形式。
  Future<Directory> get directory async => Directory(p.join((await storageType.directory).path, relativePath));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StorageDirectory &&
          runtimeType == other.runtimeType &&
          storageType == other.storageType &&
          relativePath == other.relativePath;

  @override
  int get hashCode => storageType.hashCode ^ relativePath.hashCode;

  /// 返回这个[StorageDirectory]实例的`String`表示形式，如下所示：
  ///
  /// `storageType.name + ":" + relativePath`
  @override
  String toString() {
    return '${storageType.name}:$relativePath';
  }

  /// 从`String`值创建[StorageDirectory]实例。
  static StorageDirectory from(String source) {
    int index = source.indexOf(':');
    if (index < 0) {
      throw ArgumentError('Source is not a string of StorageDirectory: $source');
    }
    return StorageDirectory(
        EnumHelper.fromString(StorageType.values, source.substring(0, index)), source.substring(index + 1));
  }
}
