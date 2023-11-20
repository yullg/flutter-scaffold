import 'dart:io';

import '../../scaffold_config.dart';
import 'log.dart';
import 'log_appender.dart';

/// 日志记录器
class Logger {
  final String name;

  const Logger(this.name);

  void trace(Object? message, [Object? error, StackTrace? trace]) =>
      log(Log(name, LogLevel.TRACE, message, error, trace, pid, DateTime.now()));

  void debug(Object? message, [Object? error, StackTrace? trace]) =>
      log(Log(name, LogLevel.DEBUG, message, error, trace, pid, DateTime.now()));

  void info(Object? message, [Object? error, StackTrace? trace]) =>
      log(Log(name, LogLevel.INFO, message, error, trace, pid, DateTime.now()));

  void warn(Object? message, [Object? error, StackTrace? trace]) =>
      log(Log(name, LogLevel.WARN, message, error, trace, pid, DateTime.now()));

  void error(Object? message, [Object? error, StackTrace? trace]) =>
      log(Log(name, LogLevel.ERROR, message, error, trace, pid, DateTime.now()));

  void fatal(Object? message, [Object? error, StackTrace? trace]) =>
      log(Log(name, LogLevel.FATAL, message, error, trace, pid, DateTime.now()));

  bool isTraceEnabled() => isEnabled(LogLevel.TRACE);

  bool isDebugEnabled() => isEnabled(LogLevel.DEBUG);

  bool isInfoEnabled() => isEnabled(LogLevel.INFO);

  bool isWarnEnabled() => isEnabled(LogLevel.WARN);

  bool isErrorEnabled() => isEnabled(LogLevel.ERROR);

  bool isFatalEnabled() => isEnabled(LogLevel.FATAL);

  /// 记录日志。
  void log(Log log) {
    LogAppender.doAppend(log).catchError((e, s) {
      // ignore
    });
  }

  /// 检查指定的日志级别是否启用。
  bool isEnabled(LogLevel logLevel) {
    try {
      return (ScaffoldConfig.logger.findConsoleAppenderEnabled(name) &&
              ScaffoldConfig.logger.findConsoleAppenderLevel(name).index <= logLevel.index) ||
          (ScaffoldConfig.logger.findFileAppenderEnabled(name) &&
              ScaffoldConfig.logger.findFileAppenderLevel(name).index <= logLevel.index);
    } catch (e) {
      return false;
    }
  }
}
