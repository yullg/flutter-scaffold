import 'dart:io';

import 'package:path/path.dart' as p;

import '../../helper/enum_helper.dart';
import 'storage_type.dart';

/// 表示存储在由[StorageType]定义的存储目录中的文件，
/// 并且提供与`String`表示形式的互相转换来避免依赖绝对路径。
class StorageFile {
  final StorageType storageType;
  final String relativePath;

  const StorageFile(this.storageType, this.relativePath);

  /// 获取存储文件的[File]表示形式。
  Future<File> get file async => File(p.join((await storageType.directory).path, relativePath));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StorageFile &&
          runtimeType == other.runtimeType &&
          storageType == other.storageType &&
          relativePath == other.relativePath;

  @override
  int get hashCode => storageType.hashCode ^ relativePath.hashCode;

  /// 返回这个[StorageFile]实例的`String`表示形式，如下所示：
  ///
  /// `storageType.name + ":" + relativePath`
  @override
  String toString() {
    return '${storageType.name}:$relativePath';
  }

  /// 从`String`值创建[StorageFile]实例。
  static StorageFile from(String source) {
    int index = source.indexOf(':');
    if (index < 0) {
      throw ArgumentError('Source is not a string of StorageFile: $source');
    }
    return StorageFile(
        EnumHelper.fromString(StorageType.values, source.substring(0, index)), source.substring(index + 1));
  }
}
