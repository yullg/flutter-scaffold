import 'dart:io';

import 'package:path/path.dart' as p;

import '../../config/scaffold_logger_option.dart';
import '../../internal/scaffold_logger.dart';
import 'log_file_handler.dart';
import 'logger.dart';

/// 管理日志文件
class LogFileManager {
  static final _logFileNameRE = RegExp(r'^(.+)-(\d+)(\d{2})(\d{2}).log$');

  /// 删除过期的日志文件
  static Future<void> deleteExpiredLogFile() async {
    try {
      ScaffoldLogger.info(Logger.message(
          library: _kLogLibrary, part: "DeleteExpiredLogFile", what: "begin"));
      final logDirectory = await LogFileHandler.logDirectoryFuture;
      if (await logDirectory.exists()) {
        await for (FileSystemEntity entity
            in logDirectory.list(recursive: false, followLinks: false)) {
          try {
            if (entity is! File) continue;
            final fileName = p.basename(entity.path);
            final fileNameMatch = _logFileNameRE.firstMatch(fileName);
            if (fileNameMatch == null) {
              ScaffoldLogger.warn(Logger.message(
                  library: _kLogLibrary,
                  part: "DeleteExpiredLogFile",
                  what: "File[$entity] not supported"));
              continue;
            }
            final name = fileNameMatch.group(1)!;
            final time = DateTime(
                int.parse(fileNameMatch.group(2)!),
                int.parse(fileNameMatch.group(3)!),
                int.parse(fileNameMatch.group(4)!));
            final minDateTime = DateTime.now()
                .subtract(ScaffoldLoggerOption.logFileLifetime(name));
            if (time.isBefore(minDateTime)) {
              await LogFileHandler(fileName).delete();
              ScaffoldLogger.debug(Logger.message(
                library: _kLogLibrary,
                part: "DeleteExpiredLogFile",
                what: "delete",
                namedArgs: {
                  "file": entity,
                  "expiredDate": minDateTime.toIso8601String(),
                },
                result: "success",
              ));
            }
          } catch (e, s) {
            ScaffoldLogger.error(
                Logger.message(
                  library: _kLogLibrary,
                  part: "DeleteExpiredLogFile",
                  what: "delete",
                  namedArgs: {
                    "file": entity,
                  },
                  result: "failed",
                ),
                e,
                s);
          }
        }
      }
      ScaffoldLogger.info(Logger.message(
          library: _kLogLibrary, part: "DeleteExpiredLogFile", what: "end"));
    } catch (e, s) {
      ScaffoldLogger.error(
          Logger.message(
              library: _kLogLibrary,
              part: "DeleteExpiredLogFile",
              what: "failed"),
          e,
          s);
      rethrow;
    }
  }

  /// 上传所有日志文件。
  static Future<void> uploadAllLogFile() async {
    try {
      ScaffoldLogger.info(Logger.message(
          library: _kLogLibrary, part: "UploadAllLogFile", what: "begin"));
      final logUploadDirectory = await LogFileHandler.logUploadDirectoryFuture;
      await _uploadAllLogFileInDirectory(logUploadDirectory);
      final logDirectory = await LogFileHandler.logDirectoryFuture;
      if (await logDirectory.exists()) {
        await for (FileSystemEntity entity
            in logDirectory.list(recursive: false, followLinks: false)) {
          try {
            if (entity is! File) continue;
            final fileName = p.basename(entity.path);
            final uploadFile = File(p.join(logUploadDirectory.path, fileName));
            if (await uploadFile.exists()) {
              ScaffoldLogger.warn(Logger.message(
                library: _kLogLibrary,
                part: "UploadAllLogFile",
                what: "clone",
                namedArgs: {
                  "file": entity,
                },
                result: "conflict",
              ));
            } else {
              await uploadFile.parent.create(recursive: true);
              await LogFileHandler(fileName).move(uploadFile.path);
              ScaffoldLogger.debug(Logger.message(
                library: _kLogLibrary,
                part: "UploadAllLogFile",
                what: "clone",
                namedArgs: {
                  "file": entity,
                },
                result: "success",
              ));
            }
          } catch (e, s) {
            ScaffoldLogger.error(
                Logger.message(
                  library: _kLogLibrary,
                  part: "UploadAllLogFile",
                  what: "clone",
                  namedArgs: {
                    "file": entity,
                  },
                  result: "failed",
                ),
                e,
                s);
          }
        }
      }
      await _uploadAllLogFileInDirectory(logUploadDirectory);
      ScaffoldLogger.info(Logger.message(
          library: _kLogLibrary, part: "UploadAllLogFile", what: "end"));
    } catch (e, s) {
      ScaffoldLogger.error(
          Logger.message(
              library: _kLogLibrary, part: "UploadAllLogFile", what: "failed"),
          e,
          s);
      rethrow;
    }
  }

  static Future<void> _uploadAllLogFileInDirectory(Directory directory) async {
    if (!await directory.exists()) return;
    await for (FileSystemEntity entity
        in directory.list(recursive: false, followLinks: false)) {
      try {
        if (entity is! File) continue;
        final fileName = p.basename(entity.path);
        final fileNameMatch = _logFileNameRE.firstMatch(fileName);
        if (fileNameMatch == null) {
          ScaffoldLogger.warn(Logger.message(
              library: _kLogLibrary,
              part: "UploadAllLogFile",
              what: "File[$entity] not supported"));
          continue;
        }
        final name = fileNameMatch.group(1)!;
        final uploader = ScaffoldLoggerOption.uploader(name);
        if (uploader == null) {
          ScaffoldLogger.warn(Logger.message(
              library: _kLogLibrary,
              part: "UploadAllLogFile",
              what: "Uploader[$name] not provided"));
          continue;
        }
        await uploader.upload(entity);
        await entity.delete();
        ScaffoldLogger.debug(Logger.message(
          library: _kLogLibrary,
          part: "UploadAllLogFile",
          what: "upload",
          namedArgs: {
            "file": entity,
          },
          result: "success",
        ));
      } catch (e, s) {
        ScaffoldLogger.error(
            Logger.message(
              library: _kLogLibrary,
              part: "UploadAllLogFile",
              what: "upload",
              namedArgs: {
                "file": entity,
              },
              result: "failed",
            ),
            e,
            s);
      }
    }
  }
}

const _kLogLibrary = "logger";
