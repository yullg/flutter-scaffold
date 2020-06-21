import 'dart:io';

import 'storage_file.dart';

/// 提供文件存储功能的支持。
class StorageSupport {
  /// 将文件[source]复制到[destination]。
  ///
  /// 如果在通往[destination]的路径上缺少一些目录，那么将创建它们。
  /// 如果[source]不存在或者[destination]已经存在，则此方法将失败。
  static Future<void> copyFromFile(File source, StorageFile destination) async {
    if (!await source.exists()) {
      throw StateError("The source file doesn't exist.");
    }
    File destinationFile = await destination.file;
    if (await destinationFile.exists()) {
      throw StateError("The destination file already exists.");
    }
    await destinationFile.create(recursive: true);
    await source.copy(destinationFile.path);
  }

  /// 将文件[source]复制到[destination]。
  ///
  /// 如果在通往[destination]的路径上缺少一些目录，那么将创建它们。
  /// 如果[source]不存在或者[destination]已经存在，则此方法将失败。
  static Future<void> copyToFile(StorageFile source, File destination) async {
    File sourceFile = await source.file;
    if (!await sourceFile.exists()) {
      throw StateError("The source file doesn't exist.");
    }
    if (await destination.exists()) {
      throw StateError("The destination file already exists.");
    }
    await destination.create(recursive: true);
    await sourceFile.copy(destination.path);
  }

  StorageSupport._();
}
