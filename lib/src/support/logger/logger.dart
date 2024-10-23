import 'dart:io';

import 'package:meta/meta.dart';

import '../../config/scaffold_logger_option.dart';
import 'log.dart';
import 'log_appender.dart';

abstract interface class ILogger {
  String get name;

  void trace(Object? message, [Object? error, StackTrace? trace]);

  void debug(Object? message, [Object? error, StackTrace? trace]);

  void info(Object? message, [Object? error, StackTrace? trace]);

  void warn(Object? message, [Object? error, StackTrace? trace]);

  void error(Object? message, [Object? error, StackTrace? trace]);

  void fatal(Object? message, [Object? error, StackTrace? trace]);

  void log(Log log);

  bool isTraceEnabled();

  bool isDebugEnabled();

  bool isInfoEnabled();

  bool isWarnEnabled();

  bool isErrorEnabled();

  bool isFatalEnabled();

  bool isEnabled(LogLevel logLevel);
}

class Logger implements ILogger {
  @override
  final String name;

  const Logger(this.name);

  @override
  void trace(Object? message, [Object? error, StackTrace? trace]) => log(Log(
        name: name,
        level: LogLevel.trace,
        message: message,
        error: error,
        trace: trace,
        processId: pid,
        time: DateTime.now(),
      ));

  @override
  void debug(Object? message, [Object? error, StackTrace? trace]) => log(Log(
        name: name,
        level: LogLevel.debug,
        message: message,
        error: error,
        trace: trace,
        processId: pid,
        time: DateTime.now(),
      ));

  @override
  void info(Object? message, [Object? error, StackTrace? trace]) => log(Log(
        name: name,
        level: LogLevel.info,
        message: message,
        error: error,
        trace: trace,
        processId: pid,
        time: DateTime.now(),
      ));

  @override
  void warn(Object? message, [Object? error, StackTrace? trace]) => log(Log(
        name: name,
        level: LogLevel.warn,
        message: message,
        error: error,
        trace: trace,
        processId: pid,
        time: DateTime.now(),
      ));

  @override
  void error(Object? message, [Object? error, StackTrace? trace]) => log(Log(
        name: name,
        level: LogLevel.error,
        message: message,
        error: error,
        trace: trace,
        processId: pid,
        time: DateTime.now(),
      ));

  @override
  void fatal(Object? message, [Object? error, StackTrace? trace]) => log(Log(
        name: name,
        level: LogLevel.fatal,
        message: message,
        error: error,
        trace: trace,
        processId: pid,
        time: DateTime.now(),
      ));

  @override
  void log(Log log) => LogAppender.doAppend(log);

  @override
  bool isTraceEnabled() => isEnabled(LogLevel.trace);

  @override
  bool isDebugEnabled() => isEnabled(LogLevel.debug);

  @override
  bool isInfoEnabled() => isEnabled(LogLevel.info);

  @override
  bool isWarnEnabled() => isEnabled(LogLevel.warn);

  @override
  bool isErrorEnabled() => isEnabled(LogLevel.error);

  @override
  bool isFatalEnabled() => isEnabled(LogLevel.fatal);

  @override
  bool isEnabled(LogLevel logLevel) {
    try {
      return (ScaffoldLoggerOption.consoleAppenderEnabled(name) &&
              ScaffoldLoggerOption.consoleAppenderLevel(name).index <=
                  logLevel.index) ||
          (ScaffoldLoggerOption.fileAppenderEnabled(name) &&
              ScaffoldLoggerOption.fileAppenderLevel(name).index <=
                  logLevel.index);
    } catch (e) {
      return false;
    }
  }
}

base class LoggerForward implements ILogger {
  @protected
  final ILogger logger;

  const LoggerForward(this.logger);

  @override
  String get name => logger.name;

  @override
  void trace(Object? message, [Object? error, StackTrace? trace]) =>
      logger.trace(message, error, trace);

  @override
  void debug(Object? message, [Object? error, StackTrace? trace]) =>
      logger.debug(message, error, trace);

  @override
  void info(Object? message, [Object? error, StackTrace? trace]) =>
      logger.info(message, error, trace);

  @override
  void warn(Object? message, [Object? error, StackTrace? trace]) =>
      logger.warn(message, error, trace);

  @override
  void error(Object? message, [Object? error, StackTrace? trace]) =>
      logger.error(message, error, trace);

  @override
  void fatal(Object? message, [Object? error, StackTrace? trace]) =>
      logger.fatal(message, error, trace);

  @override
  void log(Log log) => logger.log(log);

  @override
  bool isTraceEnabled() => logger.isTraceEnabled();

  @override
  bool isDebugEnabled() => logger.isDebugEnabled();

  @override
  bool isInfoEnabled() => logger.isInfoEnabled();

  @override
  bool isWarnEnabled() => logger.isWarnEnabled();

  @override
  bool isErrorEnabled() => logger.isErrorEnabled();

  @override
  bool isFatalEnabled() => logger.isFatalEnabled();

  @override
  bool isEnabled(LogLevel logLevel) => logger.isEnabled(logLevel);
}
