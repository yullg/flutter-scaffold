import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../../internal/scaffold_logger.dart';
import '../../scaffold_config.dart';
import '../../scaffold_constants.dart';
import '../storage/storage_directory.dart';
import 'log.dart';

/// 管理本地日志文件
class LogFileManager {
  static final _logFileNameTimeFormat = DateFormat("yyyyMMdd", "en_US");
  static final _logFileNameRegExp = RegExp(r'^(.+)-(\d{4})(\d{2})(\d{2}).log$');

  static Future<File> createFileForLog(Log log) async {
    final logFile = File(p.join(
        (await StorageDirectory.CACHE.directory).absolute.path,
        ScaffoldConstants.LOGGER_DIRECTORY,
        "${log.name}-${_logFileNameTimeFormat.format(log.time)}.log"));
    await logFile.create(recursive: true);
    return logFile;
  }

  static Future<void> deleteExpiredLogFile() async {
    try {
      ScaffoldLogger.info("[Logger - delete] Begin");
      await _eachLogFile((logFile) async {
        final minDateTime = DateTime.now().subtract(Duration(
            days: ScaffoldConfig.logger.findLogFileMaxLife(logFile.name)));
        if (logFile.time.isBefore(minDateTime)) {
          await logFile.file.delete();
          ScaffoldLogger.debug(
              "[Logger - delete] Delete the expired log file: file = ${logFile.file}, expiredDate = ${minDateTime.toIso8601String()}");
        }
      });
      ScaffoldLogger.info("[Logger - delete] End");
    } catch (e, s) {
      ScaffoldLogger.error("[Logger - delete] Failed", e, s);
      rethrow;
    }
  }

  static Future<void> uploadAllLogFile() async {
    try {
      ScaffoldLogger.info("[Logger - upload] Begin");
      final uploader = ScaffoldConfig.logger.uploader;
      if (uploader == null) {
        ScaffoldLogger.warn("[Logger - upload] Uploader is not provided");
        return;
      }
      await _eachUploadLogFile((logFile) async {
        try {
          await uploader.upload(logFile);
          await logFile.file.delete();
          ScaffoldLogger.debug(
              "[Logger - upload] Log file has been uploaded: ${logFile.file}");
        } catch (e, s) {
          ScaffoldLogger.error(
              "[Logger - upload] Failed to upload log file: ${logFile.file}",
              e,
              s);
        }
      });
      await _eachLogFile((logFile) async {
        final uploadFile = File(p.join(
            (await StorageDirectory.CACHE.directory).absolute.path,
            ScaffoldConstants.LOGGER_DIRECTORY_UPLOAD,
            p.basename(logFile.file.path)));
        if (await uploadFile.exists()) {
          ScaffoldLogger.debug(
              "[Logger - upload] Mark the file to upload: file = ${logFile.file}, result = conflict");
        } else {
          await uploadFile.parent.create(recursive: true);
          await logFile.file.copy(uploadFile.path);
          await logFile.file.delete();
          ScaffoldLogger.debug(
              "[Logger - upload] Mark the file to upload: file = ${logFile.file}, result = success");
        }
      });
      await _eachUploadLogFile((logFile) async {
        try {
          await uploader.upload(logFile);
          await logFile.file.delete();
          ScaffoldLogger.debug(
              "[Logger - upload] Log file has been uploaded: ${logFile.file}");
        } catch (e, s) {
          ScaffoldLogger.error(
              "[Logger - upload] Failed to upload log file: ${logFile.file}",
              e,
              s);
        }
      });
      ScaffoldLogger.info("[Logger - upload] End");
    } catch (e, s) {
      ScaffoldLogger.error("[Logger - upload] Failed", e, s);
      rethrow;
    }
  }

  static Future<void> _eachLogFile(Future<void> Function(LogFile) block) async {
    final logDirectory = Directory(p.join(
        (await StorageDirectory.CACHE.directory).absolute.path,
        ScaffoldConstants.LOGGER_DIRECTORY));
    if (await logDirectory.exists()) {
      await for (FileSystemEntity entity
          in logDirectory.list(recursive: false, followLinks: false)) {
        if (entity is! File) continue;
        final fileName = p.basename(entity.path);
        final fileNameMatch = _logFileNameRegExp.firstMatch(fileName);
        if (fileNameMatch == null) continue;
        final name = fileNameMatch.group(1)!;
        final time = DateTime(
            int.parse(fileNameMatch.group(2)!),
            int.parse(fileNameMatch.group(3)!),
            int.parse(fileNameMatch.group(4)!));
        final logFile = LogFile(name, time, entity);
        await block(logFile);
      }
    }
  }

  static Future<void> _eachUploadLogFile(
      Future<void> Function(LogFile) block) async {
    final logDirectory = Directory(p.join(
        (await StorageDirectory.CACHE.directory).absolute.path,
        ScaffoldConstants.LOGGER_DIRECTORY_UPLOAD));
    if (await logDirectory.exists()) {
      await for (FileSystemEntity entity
          in logDirectory.list(recursive: false, followLinks: false)) {
        if (entity is! File) continue;
        final fileName = p.basename(entity.path);
        final fileNameMatch = _logFileNameRegExp.firstMatch(fileName);
        if (fileNameMatch == null) continue;
        final name = fileNameMatch.group(1)!;
        final time = DateTime(
            int.parse(fileNameMatch.group(2)!),
            int.parse(fileNameMatch.group(3)!),
            int.parse(fileNameMatch.group(4)!));
        final logFile = LogFile(name, time, entity);
        await block(logFile);
      }
    }
  }
}
