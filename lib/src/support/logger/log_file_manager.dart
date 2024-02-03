import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../../internal/scaffold_logger.dart';
import '../../scaffold_constants.dart';
import '../../scaffold_module.dart';
import '../storage/storage_type.dart';
import 'log.dart';
import 'logger.dart';

/// 管理本地日志文件
class LogFileManager {
  static final _logFileNameTimeFormat = DateFormat("yyyyMMdd", "en_US");
  static final _logFileNameRegExp = RegExp(r'^(.+)-(\d{4})(\d{2})(\d{2}).log$');

  static Future<File> createFileForLog(Log log) async {
    final logFile = File(p.join((await StorageType.cache.directory).absolute.path, ScaffoldConstants.kLoggerDirectory,
        "${log.name}-${_logFileNameTimeFormat.format(log.time)}.log"));
    await logFile.create(recursive: true);
    return logFile;
  }

  static Future<void> deleteExpiredLogFile() async {
    try {
      ScaffoldLogger.info(
          Logger.message(library: "logger", part: "LogFileManager", what: "Start deleting expired log files"));
      await _eachLogFile((logFile) async {
        final minDateTime =
            DateTime.now().subtract(Duration(days: ScaffoldModule.config.findLoggerLogFileMaxLife(logFile.name)));
        if (logFile.time.isBefore(minDateTime)) {
          await logFile.file.delete();
          ScaffoldLogger.debug(Logger.message(
            library: "logger",
            part: "LogFileManager",
            what: "Delete expired log file",
            namedArgs: {
              "file": logFile.file,
              "expiredDate": minDateTime.toIso8601String(),
            },
          ));
        }
      });
      ScaffoldLogger.info(
          Logger.message(library: "logger", part: "LogFileManager", what: "All expired log files have been deleted"));
    } catch (e, s) {
      ScaffoldLogger.error(
          Logger.message(library: "logger", part: "LogFileManager", what: "Failed to delete expired log files"), e, s);
      rethrow;
    }
  }

  static Future<void> uploadAllLogFile() async {
    try {
      ScaffoldLogger.info(Logger.message(library: "logger", part: "LogFileManager", what: "Start uploading log files"));
      final uploader = ScaffoldModule.config.loggerUploader;
      if (uploader == null) {
        ScaffoldLogger.warn(
            Logger.message(library: "logger", part: "LogFileManager", what: "Uploader is not provided"));
        return;
      }
      await _eachUploadLogFile((logFile) async {
        try {
          await uploader.upload(logFile);
          await logFile.file.delete();
          ScaffoldLogger.debug(Logger.message(
              library: "logger", part: "LogFileManager", what: "Log file has been uploaded", args: [logFile.file]));
        } catch (e, s) {
          ScaffoldLogger.error(
              Logger.message(
                  library: "logger", part: "LogFileManager", what: "Failed to upload log file", args: [logFile.file]),
              e,
              s);
        }
      });
      await _eachLogFile((logFile) async {
        final uploadFile = File(p.join((await StorageType.cache.directory).absolute.path,
            ScaffoldConstants.kLoggerDirectoryUpload, p.basename(logFile.file.path)));
        if (await uploadFile.exists()) {
          ScaffoldLogger.debug(Logger.message(
            library: "logger",
            part: "LogFileManager",
            what: "Mark the file to upload",
            args: [logFile.file],
            result: "conflict",
          ));
        } else {
          await uploadFile.parent.create(recursive: true);
          await logFile.file.copy(uploadFile.path);
          await logFile.file.delete();
          ScaffoldLogger.debug(Logger.message(
            library: "logger",
            part: "LogFileManager",
            what: "Mark the file to upload",
            args: [logFile.file],
            result: "success",
          ));
        }
      });
      await _eachUploadLogFile((logFile) async {
        try {
          await uploader.upload(logFile);
          await logFile.file.delete();
          ScaffoldLogger.debug(Logger.message(
              library: "logger", part: "LogFileManager", what: "Log file has been uploaded", args: [logFile.file]));
        } catch (e, s) {
          ScaffoldLogger.error(
              Logger.message(
                  library: "logger", part: "LogFileManager", what: "Failed to upload log file", args: [logFile.file]),
              e,
              s);
        }
      });
      ScaffoldLogger.info(
          Logger.message(library: "logger", part: "LogFileManager", what: "Completed uploading log files"));
    } catch (e, s) {
      ScaffoldLogger.error(
          Logger.message(library: "logger", part: "LogFileManager", what: "Failed to upload log files"), e, s);
      rethrow;
    }
  }

  static Future<void> _eachLogFile(Future<void> Function(LogFile) block) async {
    final logDirectory =
        Directory(p.join((await StorageType.cache.directory).absolute.path, ScaffoldConstants.kLoggerDirectory));
    if (await logDirectory.exists()) {
      await for (FileSystemEntity entity in logDirectory.list(recursive: false, followLinks: false)) {
        if (entity is! File) continue;
        final fileName = p.basename(entity.path);
        final fileNameMatch = _logFileNameRegExp.firstMatch(fileName);
        if (fileNameMatch == null) continue;
        final name = fileNameMatch.group(1)!;
        final time = DateTime(
            int.parse(fileNameMatch.group(2)!), int.parse(fileNameMatch.group(3)!), int.parse(fileNameMatch.group(4)!));
        final logFile = LogFile(name, time, entity);
        await block(logFile);
      }
    }
  }

  static Future<void> _eachUploadLogFile(Future<void> Function(LogFile) block) async {
    final logDirectory =
        Directory(p.join((await StorageType.cache.directory).absolute.path, ScaffoldConstants.kLoggerDirectoryUpload));
    if (await logDirectory.exists()) {
      await for (FileSystemEntity entity in logDirectory.list(recursive: false, followLinks: false)) {
        if (entity is! File) continue;
        final fileName = p.basename(entity.path);
        final fileNameMatch = _logFileNameRegExp.firstMatch(fileName);
        if (fileNameMatch == null) continue;
        final name = fileNameMatch.group(1)!;
        final time = DateTime(
            int.parse(fileNameMatch.group(2)!), int.parse(fileNameMatch.group(3)!), int.parse(fileNameMatch.group(4)!));
        final logFile = LogFile(name, time, entity);
        await block(logFile);
      }
    }
  }
}
