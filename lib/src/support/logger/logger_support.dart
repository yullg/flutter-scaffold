import 'log.dart';
import 'log_file_manager.dart';
import 'log_file_uploader.dart';
import 'logger_config.dart';

class LoggerSupport {
  static LoggerConfig? _config;
  static final _configMap = <String, LoggerConfig>{};

  static void config(LoggerConfig? config) {
    _config = config;
  }

  static void namedConfig(String name, LoggerConfig? config) {
    if (config != null) {
      _configMap[name] = config;
    } else {
      _configMap.remove(name);
    }
  }

  static bool consoleAppenderEnabled(String name) =>
      _configMap[name]?.consoleAppenderEnabled ??
      _config?.consoleAppenderEnabled ??
      LoggerConfig.kFallbackConsoleAppenderEnabled;

  static LogLevel consoleAppenderLevel(String name) =>
      _configMap[name]?.consoleAppenderLevel ??
      _config?.consoleAppenderLevel ??
      LoggerConfig.kFallbackConsoleAppenderLevel;

  static bool fileAppenderEnabled(String name) =>
      _configMap[name]?.fileAppenderEnabled ??
      _config?.fileAppenderEnabled ??
      LoggerConfig.kFallbackFileAppenderEnabled;

  static LogLevel fileAppenderLevel(String name) =>
      _configMap[name]?.fileAppenderLevel ?? _config?.fileAppenderLevel ?? LoggerConfig.kFallbackFileAppenderLevel;

  static Duration logFileLifetime(String name) =>
      _configMap[name]?.logFileLifetime ?? _config?.logFileLifetime ?? LoggerConfig.kFallbackLogFileLifetime;

  static LogFileUploader? uploader(String name) => _configMap[name]?.uploader ?? _config?.uploader;

  static Future<void> deleteExpiredLogFile() => LogFileManager.deleteExpiredLogFile();

  static Future<void> uploadAllLogFile() => LogFileManager.uploadAllLogFile();

  LoggerSupport._();
}
