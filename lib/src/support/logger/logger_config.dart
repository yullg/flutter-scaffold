import 'package:flutter/foundation.dart';

import 'log.dart';
import 'log_file_uploader.dart';

class LoggerConfig {
  final bool consoleAppenderEnabled;
  final LogLevel consoleAppenderLevel;
  final bool fileAppenderEnabled;
  final LogLevel fileAppenderLevel;
  final Duration logFileLifetime;
  final Map<String, LoggerConfigOption> _optionMap;
  final LogFileUploader? uploader;

  LoggerConfig({
    this.consoleAppenderEnabled = kDebugMode,
    this.consoleAppenderLevel = LogLevel.trace,
    this.fileAppenderEnabled = true,
    this.fileAppenderLevel = LogLevel.warn,
    this.logFileLifetime = const Duration(days: 15),
    Map<String, LoggerConfigOption>? optionMap,
    this.uploader,
  }) : _optionMap = {...?optionMap};

  bool findConsoleAppenderEnabled(String name) {
    return _optionMap[name]?.consoleAppenderEnabled ?? consoleAppenderEnabled;
  }

  LogLevel findConsoleAppenderLevel(String name) {
    return _optionMap[name]?.consoleAppenderLevel ?? consoleAppenderLevel;
  }

  bool findFileAppenderEnabled(String name) {
    return _optionMap[name]?.fileAppenderEnabled ?? fileAppenderEnabled;
  }

  LogLevel findFileAppenderLevel(String name) {
    return _optionMap[name]?.fileAppenderLevel ?? fileAppenderLevel;
  }

  Duration findLogFileLifetime(String name) {
    return _optionMap[name]?.logFileLifetime ?? logFileLifetime;
  }

  @override
  String toString() {
    return 'LoggerConfig{consoleAppenderEnabled: $consoleAppenderEnabled, consoleAppenderLevel: $consoleAppenderLevel, fileAppenderEnabled: $fileAppenderEnabled, fileAppenderLevel: $fileAppenderLevel, logFileLifetime: $logFileLifetime, _optionMap: $_optionMap, uploader: $uploader}';
  }
}

class LoggerConfigOption {
  final bool? consoleAppenderEnabled;
  final LogLevel? consoleAppenderLevel;
  final bool? fileAppenderEnabled;
  final LogLevel? fileAppenderLevel;
  final Duration? logFileLifetime;

  LoggerConfigOption({
    this.consoleAppenderEnabled,
    this.consoleAppenderLevel,
    this.fileAppenderEnabled,
    this.fileAppenderLevel,
    this.logFileLifetime,
  });

  @override
  String toString() {
    return 'LoggerConfigOption{consoleAppenderEnabled: $consoleAppenderEnabled, consoleAppenderLevel: $consoleAppenderLevel, fileAppenderEnabled: $fileAppenderEnabled, fileAppenderLevel: $fileAppenderLevel, logFileLifetime: $logFileLifetime}';
  }
}
