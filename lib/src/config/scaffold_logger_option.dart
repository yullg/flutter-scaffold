import 'package:flutter/foundation.dart';

import '../support/logger/log.dart';
import '../support/logger/log_file_uploader.dart';
import 'scaffold_config.dart';

class ScaffoldLoggerOption {
  static const kFallbackConsoleAppenderEnabled = kDebugMode;
  static const kFallbackConsoleAppenderLevel = LogLevel.trace;
  static const kFallbackFileAppenderEnabled = true;
  static const kFallbackFileAppenderLevel = LogLevel.warn;
  static const kFallbackLogFileLifetime = Duration(days: 15);

  final ScaffoldLoggerOptionDetails? _defaultDetails;
  final Map<String, ScaffoldLoggerOptionDetails> _namedDetails;

  ScaffoldLoggerOption({
    ScaffoldLoggerOptionDetails? defaultDetails,
    Map<String, ScaffoldLoggerOptionDetails> namedDetails = const {},
  })  : _defaultDetails = defaultDetails,
        _namedDetails = Map.of(namedDetails);

  static bool consoleAppenderEnabled(String name) =>
      ScaffoldConfig.loggerOption?._namedDetails[name]?.consoleAppenderEnabled ??
      ScaffoldConfig.loggerOption?._defaultDetails?.consoleAppenderEnabled ??
      kFallbackConsoleAppenderEnabled;

  static LogLevel consoleAppenderLevel(String name) =>
      ScaffoldConfig.loggerOption?._namedDetails[name]?.consoleAppenderLevel ??
      ScaffoldConfig.loggerOption?._defaultDetails?.consoleAppenderLevel ??
      kFallbackConsoleAppenderLevel;

  static bool fileAppenderEnabled(String name) =>
      ScaffoldConfig.loggerOption?._namedDetails[name]?.fileAppenderEnabled ??
      ScaffoldConfig.loggerOption?._defaultDetails?.fileAppenderEnabled ??
      kFallbackFileAppenderEnabled;

  static LogLevel fileAppenderLevel(String name) =>
      ScaffoldConfig.loggerOption?._namedDetails[name]?.fileAppenderLevel ??
      ScaffoldConfig.loggerOption?._defaultDetails?.fileAppenderLevel ??
      kFallbackFileAppenderLevel;

  static Duration logFileLifetime(String name) =>
      ScaffoldConfig.loggerOption?._namedDetails[name]?.logFileLifetime ??
      ScaffoldConfig.loggerOption?._defaultDetails?.logFileLifetime ??
      kFallbackLogFileLifetime;

  static LogFileUploader? uploader(String name) =>
      ScaffoldConfig.loggerOption?._namedDetails[name]?.uploader ?? ScaffoldConfig.loggerOption?._defaultDetails?.uploader;

  @override
  String toString() {
    return 'ScaffoldLoggerOption{_defaultDetails: $_defaultDetails, _namedDetails: $_namedDetails}';
  }
}

class ScaffoldLoggerOptionDetails {
  final bool? consoleAppenderEnabled;
  final LogLevel? consoleAppenderLevel;
  final bool? fileAppenderEnabled;
  final LogLevel? fileAppenderLevel;
  final Duration? logFileLifetime;
  final LogFileUploader? uploader;

  ScaffoldLoggerOptionDetails({
    this.consoleAppenderEnabled,
    this.consoleAppenderLevel,
    this.fileAppenderEnabled,
    this.fileAppenderLevel,
    this.logFileLifetime,
    this.uploader,
  });

  @override
  String toString() {
    return 'ScaffoldLoggerOptionDetails{consoleAppenderEnabled: $consoleAppenderEnabled, consoleAppenderLevel: $consoleAppenderLevel, fileAppenderEnabled: $fileAppenderEnabled, fileAppenderLevel: $fileAppenderLevel, logFileLifetime: $logFileLifetime, uploader: $uploader}';
  }
}
