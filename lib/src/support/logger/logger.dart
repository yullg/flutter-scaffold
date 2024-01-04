import 'dart:io';

import '../../scaffold_module.dart';
import 'log.dart';
import 'log_appender.dart';

/// 日志记录器
class Logger {
  final String name;

  const Logger(this.name);

  void trace(Object? message, [Object? error, StackTrace? trace]) =>
      log(Log(name, LogLevel.trace, message, error, trace, pid, DateTime.now()));

  void debug(Object? message, [Object? error, StackTrace? trace]) =>
      log(Log(name, LogLevel.debug, message, error, trace, pid, DateTime.now()));

  void info(Object? message, [Object? error, StackTrace? trace]) =>
      log(Log(name, LogLevel.info, message, error, trace, pid, DateTime.now()));

  void warn(Object? message, [Object? error, StackTrace? trace]) =>
      log(Log(name, LogLevel.warn, message, error, trace, pid, DateTime.now()));

  void error(Object? message, [Object? error, StackTrace? trace]) =>
      log(Log(name, LogLevel.error, message, error, trace, pid, DateTime.now()));

  void fatal(Object? message, [Object? error, StackTrace? trace]) =>
      log(Log(name, LogLevel.fatal, message, error, trace, pid, DateTime.now()));

  bool isTraceEnabled() => isEnabled(LogLevel.trace);

  bool isDebugEnabled() => isEnabled(LogLevel.debug);

  bool isInfoEnabled() => isEnabled(LogLevel.info);

  bool isWarnEnabled() => isEnabled(LogLevel.warn);

  bool isErrorEnabled() => isEnabled(LogLevel.error);

  bool isFatalEnabled() => isEnabled(LogLevel.fatal);

  /// 记录日志。
  void log(Log log) {
    LogAppender.doAppend(log).catchError((e, s) {
      // ignore
    });
  }

  /// 检查指定的日志级别是否启用。
  bool isEnabled(LogLevel logLevel) {
    try {
      return (ScaffoldModule.config.findLoggerConsoleAppenderEnabled(name) &&
              ScaffoldModule.config.findLoggerConsoleAppenderLevel(name).index <= logLevel.index) ||
          (ScaffoldModule.config.findLoggerFileAppenderEnabled(name) &&
              ScaffoldModule.config.findLoggerFileAppenderLevel(name).index <= logLevel.index);
    } catch (e) {
      return false;
    }
  }
}
