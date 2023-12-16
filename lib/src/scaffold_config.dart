import 'support/logger/log.dart';
import 'support/logger/log_file_uploader.dart';

class ScaffoldConfig {
  final int globalCacheManagerStalePeriod;
  final int globalCacheManagerMaxNrOfCacheObjects;
  final bool loggerConsoleAppenderEnabled;
  final LogLevel loggerConsoleAppenderLevel;
  final bool loggerFileAppenderEnabled;
  final LogLevel loggerFileAppenderLevel;
  final int loggerLogFileMaxLife;
  final LogFileUploader? loggerUploader;

  final Map<String, LoggerConfigOption>? _loggerConfigOptionMap;

  ScaffoldConfig({
    this.globalCacheManagerStalePeriod = 30,
    this.globalCacheManagerMaxNrOfCacheObjects = 99999,
    this.loggerConsoleAppenderEnabled = false,
    this.loggerConsoleAppenderLevel = LogLevel.TRACE,
    this.loggerFileAppenderEnabled = true,
    this.loggerFileAppenderLevel = LogLevel.WARN,
    this.loggerLogFileMaxLife = 15,
    this.loggerUploader,
    Map<String, LoggerConfigOption>? loggerConfigOptionMap,
  }) : _loggerConfigOptionMap = loggerConfigOptionMap;

  bool findLoggerConsoleAppenderEnabled(String name) {
    return _loggerConfigOptionMap?[name]?.consoleAppenderEnabled ?? loggerConsoleAppenderEnabled;
  }

  LogLevel findLoggerConsoleAppenderLevel(String name) {
    return _loggerConfigOptionMap?[name]?.consoleAppenderLevel ?? loggerConsoleAppenderLevel;
  }

  bool findLoggerFileAppenderEnabled(String name) {
    return _loggerConfigOptionMap?[name]?.fileAppenderEnabled ?? loggerFileAppenderEnabled;
  }

  LogLevel findLoggerFileAppenderLevel(String name) {
    return _loggerConfigOptionMap?[name]?.fileAppenderLevel ?? loggerFileAppenderLevel;
  }

  int findLoggerLogFileMaxLife(String name) {
    return _loggerConfigOptionMap?[name]?.logFileMaxLife ?? loggerLogFileMaxLife;
  }

  @override
  String toString() {
    return 'ScaffoldConfig{globalCacheManagerStalePeriod: $globalCacheManagerStalePeriod, globalCacheManagerMaxNrOfCacheObjects: $globalCacheManagerMaxNrOfCacheObjects, loggerConsoleAppenderEnabled: $loggerConsoleAppenderEnabled, loggerConsoleAppenderLevel: $loggerConsoleAppenderLevel, loggerFileAppenderEnabled: $loggerFileAppenderEnabled, loggerFileAppenderLevel: $loggerFileAppenderLevel, loggerLogFileMaxLife: $loggerLogFileMaxLife, loggerUploader: $loggerUploader, _loggerConfigOptionMap: $_loggerConfigOptionMap}';
  }
}

class LoggerConfigOption {
  bool? consoleAppenderEnabled;
  LogLevel? consoleAppenderLevel;
  bool? fileAppenderEnabled;
  LogLevel? fileAppenderLevel;
  int? logFileMaxLife;

  @override
  String toString() {
    return 'LoggerConfigOption{consoleAppenderEnabled: $consoleAppenderEnabled, consoleAppenderLevel: $consoleAppenderLevel, fileAppenderEnabled: $fileAppenderEnabled, fileAppenderLevel: $fileAppenderLevel, logFileMaxLife: $logFileMaxLife}';
  }
}
