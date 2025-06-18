import 'dart:io';

import 'package:path/path.dart' as p;

import '../../config/scaffold_logger_option.dart';
import '../../internal/scaffold_logger.dart';
import 'log_file_handler.dart';
import 'logger_messaging.dart';

/// 管理日志文件
class LogFileManager {
  static final _logFileNameRE = RegExp(r'^(.+)-(\d+)(\d{2})(\d{2}).log$');

  /// 删除过期的日志文件
  static Future<void> deleteExpiredLogFile() async {
    try {
      ScaffoldLogger().messaging(library: _kLogLibrary, what: "DeleteExpiredLogFile - begin").info();
      final logDirectory = await LogFileHandler.logDirectoryFuture;
      if (await logDirectory.exists()) {
        await for (FileSystemEntity entity in logDirectory.list(recursive: false, followLinks: false)) {
          try {
            if (entity is! File) continue;
            final fileName = p.basename(entity.path);
            final fileNameMatch = _logFileNameRE.firstMatch(fileName);
            if (fileNameMatch == null) {
              ScaffoldLogger()
                  .messaging(library: _kLogLibrary, what: "DeleteExpiredLogFile - File[$entity] not supported")
                  .warn();
              continue;
            }
            final name = fileNameMatch.group(1)!;
            final time = DateTime(
              int.parse(fileNameMatch.group(2)!),
              int.parse(fileNameMatch.group(3)!),
              int.parse(fileNameMatch.group(4)!),
            );
            final minDateTime = DateTime.now().subtract(ScaffoldLoggerOption.logFileLifetime(name));
            if (time.isBefore(minDateTime)) {
              await LogFileHandler(fileName).delete();
              ScaffoldLogger()
                  .messaging(
                    library: _kLogLibrary,
                    what: "DeleteExpiredLogFile - delete",
                    namedArgs: {"file": entity, "expiredDate": minDateTime.toIso8601String()},
                    result: "success",
                  )
                  .debug();
            }
          } catch (e, s) {
            ScaffoldLogger()
                .messaging(
                  library: _kLogLibrary,
                  what: "DeleteExpiredLogFile - delete",
                  namedArgs: {"file": entity},
                  result: "failed",
                )
                .error(e, s);
          }
        }
      }
      ScaffoldLogger().messaging(library: _kLogLibrary, what: "DeleteExpiredLogFile - end").info();
    } catch (e, s) {
      ScaffoldLogger().messaging(library: _kLogLibrary, what: "DeleteExpiredLogFile - failed").error(e, s);
      rethrow;
    }
  }

  /// 上传所有日志文件。
  static Future<void> uploadAllLogFile() async {
    try {
      ScaffoldLogger().messaging(library: _kLogLibrary, what: "UploadAllLogFile - begin").info();
      final logUploadDirectory = await LogFileHandler.logUploadDirectoryFuture;
      await _uploadAllLogFileInDirectory(logUploadDirectory);
      final logDirectory = await LogFileHandler.logDirectoryFuture;
      if (await logDirectory.exists()) {
        await for (FileSystemEntity entity in logDirectory.list(recursive: false, followLinks: false)) {
          try {
            if (entity is! File) continue;
            final fileName = p.basename(entity.path);
            final uploadFile = File(p.join(logUploadDirectory.path, fileName));
            if (await uploadFile.exists()) {
              ScaffoldLogger()
                  .messaging(
                    library: _kLogLibrary,
                    what: "UploadAllLogFile - clone",
                    namedArgs: {"file": entity},
                    result: "conflict",
                  )
                  .warn();
            } else {
              await uploadFile.parent.create(recursive: true);
              await LogFileHandler(fileName).move(uploadFile.path);
              ScaffoldLogger()
                  .messaging(
                    library: _kLogLibrary,
                    what: "UploadAllLogFile - clone",
                    namedArgs: {"file": entity},
                    result: "success",
                  )
                  .debug();
            }
          } catch (e, s) {
            ScaffoldLogger()
                .messaging(
                  library: _kLogLibrary,
                  what: "UploadAllLogFile - clone",
                  namedArgs: {"file": entity},
                  result: "failed",
                )
                .error(e, s);
          }
        }
      }
      await _uploadAllLogFileInDirectory(logUploadDirectory);
      ScaffoldLogger().messaging(library: _kLogLibrary, what: "UploadAllLogFile - end").info();
    } catch (e, s) {
      ScaffoldLogger().messaging(library: _kLogLibrary, what: "UploadAllLogFile - failed").error(e, s);
      rethrow;
    }
  }

  static Future<void> _uploadAllLogFileInDirectory(Directory directory) async {
    if (!await directory.exists()) return;
    await for (FileSystemEntity entity in directory.list(recursive: false, followLinks: false)) {
      try {
        if (entity is! File) continue;
        final fileName = p.basename(entity.path);
        final fileNameMatch = _logFileNameRE.firstMatch(fileName);
        if (fileNameMatch == null) {
          ScaffoldLogger()
              .messaging(library: _kLogLibrary, what: "UploadAllLogFile - File[$entity] not supported")
              .warn();
          continue;
        }
        final name = fileNameMatch.group(1)!;
        final uploader = ScaffoldLoggerOption.uploader(name);
        if (uploader == null) {
          ScaffoldLogger()
              .messaging(library: _kLogLibrary, what: "UploadAllLogFile - Uploader[$name] not provided")
              .warn();
          continue;
        }
        await uploader.upload(entity);
        await entity.delete();
        ScaffoldLogger()
            .messaging(
              library: _kLogLibrary,
              what: "UploadAllLogFile - upload",
              namedArgs: {"file": entity},
              result: "success",
            )
            .debug();
      } catch (e, s) {
        ScaffoldLogger()
            .messaging(
              library: _kLogLibrary,
              what: "UploadAllLogFile - upload",
              namedArgs: {"file": entity},
              result: "failed",
            )
            .error(e, s);
      }
    }
  }
}

const _kLogLibrary = "logger";
