import 'package:flutter/foundation.dart';

import 'log.dart';
import 'log_file_uploader.dart';

class LoggerConfig {
  static const kFallbackConsoleAppenderEnabled = kDebugMode;
  static const kFallbackConsoleAppenderLevel = LogLevel.trace;
  static const kFallbackFileAppenderEnabled = true;
  static const kFallbackFileAppenderLevel = LogLevel.warn;
  static const kFallbackLogFileLifetime = Duration(days: 15);

  final bool? consoleAppenderEnabled;
  final LogLevel? consoleAppenderLevel;
  final bool? fileAppenderEnabled;
  final LogLevel? fileAppenderLevel;
  final Duration? logFileLifetime;
  final LogFileUploader? uploader;

  LoggerConfig({
    this.consoleAppenderEnabled,
    this.consoleAppenderLevel,
    this.fileAppenderEnabled,
    this.fileAppenderLevel,
    this.logFileLifetime,
    this.uploader,
  });

  @override
  String toString() {
    return 'LoggerConfig{consoleAppenderEnabled: $consoleAppenderEnabled, consoleAppenderLevel: $consoleAppenderLevel, fileAppenderEnabled: $fileAppenderEnabled, fileAppenderLevel: $fileAppenderLevel, logFileLifetime: $logFileLifetime, uploader: $uploader}';
  }
}
