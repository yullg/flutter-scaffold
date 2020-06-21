import 'log.dart';
import 'log_file_uploader.dart';

/// 日志配置（只读版本）。
abstract class LoggerConfig {
  bool get consoleAppenderEnabled;

  LogLevel get consoleAppenderLevel;

  bool get fileAppenderEnabled;

  LogLevel get fileAppenderLevel;

  int get logFileMaxLife;

  LogFileUploader? get uploader;

  bool findConsoleAppenderEnabled(String name);

  LogLevel findConsoleAppenderLevel(String name);

  bool findFileAppenderEnabled(String name);

  LogLevel findFileAppenderLevel(String name);

  int findLogFileMaxLife(String name);
}

/// 日志配置（读写版本）。
class MutableLoggerConfig implements LoggerConfig {
  @override
  bool consoleAppenderEnabled = true;

  @override
  LogLevel consoleAppenderLevel = LogLevel.TRACE;

  @override
  bool fileAppenderEnabled = true;

  @override
  LogLevel fileAppenderLevel = LogLevel.WARN;

  @override
  int logFileMaxLife = 15;

  @override
  LogFileUploader? uploader = null;

  final loggerConfigOptionMap = <String, LoggerConfigOption>{};

  void logger(String name, void Function(LoggerConfigOption) block) {
    var option = loggerConfigOptionMap[name] ?? LoggerConfigOption();
    block(option);
    loggerConfigOptionMap[name] = option;
  }

  @override
  bool findConsoleAppenderEnabled(String name) {
    return loggerConfigOptionMap[name]?.consoleAppenderEnabled ??
        consoleAppenderEnabled;
  }

  @override
  LogLevel findConsoleAppenderLevel(String name) {
    return loggerConfigOptionMap[name]?.consoleAppenderLevel ??
        consoleAppenderLevel;
  }

  @override
  bool findFileAppenderEnabled(String name) {
    return loggerConfigOptionMap[name]?.fileAppenderEnabled ??
        fileAppenderEnabled;
  }

  @override
  LogLevel findFileAppenderLevel(String name) {
    return loggerConfigOptionMap[name]?.fileAppenderLevel ?? fileAppenderLevel;
  }

  @override
  int findLogFileMaxLife(String name) {
    return loggerConfigOptionMap[name]?.logFileMaxLife ?? logFileMaxLife;
  }
}

class LoggerConfigOption {
  bool? consoleAppenderEnabled;
  LogLevel? consoleAppenderLevel;
  bool? fileAppenderEnabled;
  LogLevel? fileAppenderLevel;
  int? logFileMaxLife;
}
