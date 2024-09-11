import 'dart:io';

import '../../config/scaffold_logger_option.dart';
import 'log.dart';
import 'log_appender.dart';

class Logger {
  final String name;

  const Logger(this.name);

  void trace(Object? message, [Object? error, StackTrace? trace]) => log(Log(
        name: name,
        level: LogLevel.trace,
        message: message,
        error: error,
        trace: trace,
        processId: pid,
        time: DateTime.now(),
      ));

  void debug(Object? message, [Object? error, StackTrace? trace]) => log(Log(
        name: name,
        level: LogLevel.debug,
        message: message,
        error: error,
        trace: trace,
        processId: pid,
        time: DateTime.now(),
      ));

  void info(Object? message, [Object? error, StackTrace? trace]) => log(Log(
        name: name,
        level: LogLevel.info,
        message: message,
        error: error,
        trace: trace,
        processId: pid,
        time: DateTime.now(),
      ));

  void warn(Object? message, [Object? error, StackTrace? trace]) => log(Log(
        name: name,
        level: LogLevel.warn,
        message: message,
        error: error,
        trace: trace,
        processId: pid,
        time: DateTime.now(),
      ));

  void error(Object? message, [Object? error, StackTrace? trace]) => log(Log(
        name: name,
        level: LogLevel.error,
        message: message,
        error: error,
        trace: trace,
        processId: pid,
        time: DateTime.now(),
      ));

  void fatal(Object? message, [Object? error, StackTrace? trace]) => log(Log(
        name: name,
        level: LogLevel.fatal,
        message: message,
        error: error,
        trace: trace,
        processId: pid,
        time: DateTime.now(),
      ));

  void log(Log log) => LogAppender.doAppend(log);

  bool isTraceEnabled() => isEnabled(LogLevel.trace);

  bool isDebugEnabled() => isEnabled(LogLevel.debug);

  bool isInfoEnabled() => isEnabled(LogLevel.info);

  bool isWarnEnabled() => isEnabled(LogLevel.warn);

  bool isErrorEnabled() => isEnabled(LogLevel.error);

  bool isFatalEnabled() => isEnabled(LogLevel.fatal);

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

  /// 为日志消息约定一致的格式。
  static String message({
    String library = "undefined",
    String? part,
    String? what,
    List<Object?>? args,
    Map<String, Object?>? namedArgs,
    Object? result = const _NoValueGiven(),
  }) {
    final sb = StringBuffer("[$library]");

    if (part != null) {
      sb.write(" $part");
    }

    if (what != null) {
      sb.write(" - $what");
    }

    final argStringList = <String>[];
    args?.forEach((element) {
      argStringList.add(_safeToString(element));
    });
    namedArgs?.forEach((key, value) {
      argStringList.add("$key: ${_safeToString(value)}");
    });
    if (argStringList.isNotEmpty) {
      sb.write(" < ");
      sb.writeAll(argStringList, ", ");
    }

    if (result is! _NoValueGiven) {
      sb.write(" > ${_safeToString(result)}");
    }

    return sb.toString();
  }

  /// 防止toString()出错
  static String _safeToString(Object? obj) {
    try {
      return obj.toString();
    } catch (e) {
      return "*${obj.runtimeType}*";
    }
  }
}

final class _NoValueGiven {
  const _NoValueGiven();
}
