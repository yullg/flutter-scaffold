import 'dart:io';

import 'package:path/path.dart' as p;

import '../../internal/scaffold_logger.dart';
import '../../scaffold_constants.dart';
import '../storage/storage_type.dart';
import 'log.dart';
import 'logger.dart';
import 'logger_support.dart';

/// 管理本地日志文件
class LogFileManager {
  static final _logFileNameRegExp = RegExp(r'^(.+)-(\d+)(\d{2})(\d{2}).log$');

  static Future<File> createFileForLog(Log log) async {
    final cacheDirectory = await StorageType.cache.directory;
    final fileName =
        "${log.name}-${log.time.year}${log.time.month.toString().padLeft(2, '0')}${log.time.day.toString().padLeft(2, '0')}.log";
    return File(p.join(cacheDirectory.absolute.path, ScaffoldConstants.kLoggerDirectory, fileName));
  }

  static Future<void> deleteExpiredLogFile() async {
    try {
      ScaffoldLogger.info(
          Logger.message(library: _kLogLibrary, part: _kLogPart, what: "Start deleting expired log files"));
      await _eachLogFile((logFile) async {
        final minDateTime = DateTime.now().subtract(LoggerSupport.logFileLifetime(logFile.name));
        if (logFile.time.isBefore(minDateTime)) {
          await logFile.file.delete();
          ScaffoldLogger.debug(Logger.message(
            library: _kLogLibrary,
            part: _kLogPart,
            what: "Delete expired log file",
            namedArgs: {
              "file": logFile.file,
              "expiredDate": minDateTime.toIso8601String(),
            },
          ));
        }
      });
      ScaffoldLogger.info(
          Logger.message(library: _kLogLibrary, part: _kLogPart, what: "All expired log files have been deleted"));
    } catch (e, s) {
      ScaffoldLogger.error(
          Logger.message(library: _kLogLibrary, part: _kLogPart, what: "Failed to delete expired log files"), e, s);
      rethrow;
    }
  }

  static Future<void> uploadAllLogFile() async {
    try {
      ScaffoldLogger.info(Logger.message(library: _kLogLibrary, part: _kLogPart, what: "Start uploading log files"));
      await _eachUploadLogFile((logFile) async {
        try {
          final uploader = LoggerSupport.uploader(logFile.name);
          if (uploader == null) {
            ScaffoldLogger.warn(Logger.message(
                library: _kLogLibrary, part: _kLogPart, what: "Uploader(${logFile.name}) is not provided"));
            return;
          }
          await uploader.upload(logFile);
          await logFile.file.delete();
          ScaffoldLogger.debug(Logger.message(
              library: _kLogLibrary, part: _kLogPart, what: "Log file has been uploaded", args: [logFile.file]));
        } catch (e, s) {
          ScaffoldLogger.error(
              Logger.message(
                  library: _kLogLibrary, part: _kLogPart, what: "Failed to upload log file", args: [logFile.file]),
              e,
              s);
        }
      });
      await _eachLogFile((logFile) async {
        final uploadFile = File(p.join((await StorageType.cache.directory).absolute.path,
            ScaffoldConstants.kLoggerDirectoryUpload, p.basename(logFile.file.path)));
        if (await uploadFile.exists()) {
          ScaffoldLogger.debug(Logger.message(
            library: _kLogLibrary,
            part: _kLogPart,
            what: "Mark the file to upload",
            args: [logFile.file],
            result: "conflict",
          ));
        } else {
          await uploadFile.parent.create(recursive: true);
          await logFile.file.copy(uploadFile.path);
          await logFile.file.delete();
          ScaffoldLogger.debug(Logger.message(
            library: _kLogLibrary,
            part: _kLogPart,
            what: "Mark the file to upload",
            args: [logFile.file],
            result: "success",
          ));
        }
      });
      await _eachUploadLogFile((logFile) async {
        try {
          final uploader = LoggerSupport.uploader(logFile.name);
          if (uploader == null) {
            ScaffoldLogger.warn(Logger.message(
                library: _kLogLibrary, part: _kLogPart, what: "Uploader(${logFile.name}) is not provided"));
            return;
          }
          await uploader.upload(logFile);
          await logFile.file.delete();
          ScaffoldLogger.debug(Logger.message(
              library: _kLogLibrary, part: _kLogPart, what: "Log file has been uploaded", args: [logFile.file]));
        } catch (e, s) {
          ScaffoldLogger.error(
              Logger.message(
                  library: _kLogLibrary, part: _kLogPart, what: "Failed to upload log file", args: [logFile.file]),
              e,
              s);
        }
      });
      ScaffoldLogger.info(
          Logger.message(library: _kLogLibrary, part: _kLogPart, what: "Completed uploading log files"));
    } catch (e, s) {
      ScaffoldLogger.error(
          Logger.message(library: _kLogLibrary, part: _kLogPart, what: "Failed to upload log files"), e, s);
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

const _kLogLibrary = "logger";
const _kLogPart = "LogFileManager";
