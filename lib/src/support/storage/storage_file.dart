import 'dart:io';

import 'package:path/path.dart' as p;

import '../../helper/enum_helper.dart';
import 'storage_directory.dart';

/// 表示存储在由[StorageDirectory]定义的存储目录中的文件，
/// 并且提供与`String`表示形式的互相转换来避免依赖绝对路径。
class StorageFile {
  final StorageDirectory storageDirectory;
  final String relativePath;

  const StorageFile(this.storageDirectory, this.relativePath);

  /// 获取存储文件的[File]表示形式。
  Future<File> get file async => File(p.join((await storageDirectory.directory).path, relativePath));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StorageFile &&
          runtimeType == other.runtimeType &&
          storageDirectory == other.storageDirectory &&
          relativePath == other.relativePath;

  @override
  int get hashCode => storageDirectory.hashCode ^ relativePath.hashCode;

  /// 返回这个[StorageFile]实例的`String`表示形式，如下所示：
  ///
  /// `storageDirectory.name + ":" + relativePath`
  @override
  String toString() {
    return '${storageDirectory.name}:$relativePath';
  }

  static StorageFile from(String source) {
    int index = source.indexOf(':');
    if (index < 0) {
      throw ArgumentError('Source is not a string of StorageFile: $source');
    }
    return StorageFile(
        EnumHelper.fromString(StorageDirectory.values, source.substring(0, index)), source.substring(index + 1));
  }
}
