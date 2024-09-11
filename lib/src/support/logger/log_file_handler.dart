import 'dart:async';
import 'dart:io';

import '../../config/scaffold_logger_option.dart';
import '../storage/storage_directory.dart';
import '../storage/storage_file.dart';
import '../storage/storage_type.dart';
import 'log.dart';

class LogFileHandler {
  static Future<Directory> get logDirectoryFuture => const StorageDirectory(
        StorageType.cache,
        ScaffoldLoggerOption.kLogDirectory,
      ).directory;

  static Future<Directory> get logUploadDirectoryFuture =>
      const StorageDirectory(
        StorageType.cache,
        ScaffoldLoggerOption.kLogUploadDirectory,
      ).directory;

  static String assignLogFileName(Log log) =>
      "${log.name}-${log.time.year}${log.time.month.toString().padLeft(2, '0')}${log.time.day.toString().padLeft(2, '0')}.log";

  static Future<File> assignLogFile(String logFileName) => StorageFile(
        StorageType.cache,
        "${ScaffoldLoggerOption.kLogDirectory}/$logFileName",
      ).file;

  final String _logFileName;

  LogFileHandler._(this._logFileName);

  static final _cache = <String, LogFileHandler>{};

  factory LogFileHandler(String logFileName) {
    return _cache.putIfAbsent(logFileName, () => LogFileHandler._(logFileName));
  }

  Future<void>? _locker;

  IOSink? _ioSink;

  Future<void> write(String content) async {
    await _locker;
    final completer = Completer<void>();
    try {
      _locker = completer.future;
      IOSink? localIoSink = _ioSink;
      if (localIoSink != null) {
        localIoSink.write(content);
      } else {
        final logFile = await assignLogFile(_logFileName);
        await logFile.create(recursive: true);
        localIoSink = logFile.openWrite(mode: FileMode.append);
        localIoSink.write(content);
        _ioSink = localIoSink;
      }
    } finally {
      completer.complete();
      _locker = null;
    }
  }

  Future<void> delete() async {
    await _locker;
    final completer = Completer<void>();
    try {
      _locker = completer.future;
      IOSink? localIoSink = _ioSink;
      if (localIoSink != null) {
        localIoSink.close().ignore();
        _ioSink = null;
      }
      final logFile = await assignLogFile(_logFileName);
      await logFile.delete();
    } finally {
      completer.complete();
      _locker = null;
    }
  }

  Future<void> move(String newPath) async {
    await _locker;
    final completer = Completer<void>();
    try {
      _locker = completer.future;
      IOSink? localIoSink = _ioSink;
      if (localIoSink != null) {
        localIoSink.close().ignore();
        _ioSink = null;
      }
      final logFile = await assignLogFile(_logFileName);
      await logFile.copy(newPath);
      await logFile.delete();
    } finally {
      completer.complete();
      _locker = null;
    }
  }
}
