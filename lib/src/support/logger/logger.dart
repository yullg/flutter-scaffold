import 'dart:io';

import '../../config/scaffold_logger_option.dart';
import 'log.dart';
import 'log_appender.dart';

/// 日志记录器
class Logger {
  final String name;

  const Logger(this.name);

  void trace(Object? message, [Object? error, StackTrace? trace]) => log(Log(name, LogLevel.trace, message, error, trace, pid, DateTime.now()));

  void debug(Object? message, [Object? error, StackTrace? trace]) => log(Log(name, LogLevel.debug, message, error, trace, pid, DateTime.now()));

  void info(Object? message, [Object? error, StackTrace? trace]) => log(Log(name, LogLevel.info, message, error, trace, pid, DateTime.now()));

  void warn(Object? message, [Object? error, StackTrace? trace]) => log(Log(name, LogLevel.warn, message, error, trace, pid, DateTime.now()));

  void error(Object? message, [Object? error, StackTrace? trace]) => log(Log(name, LogLevel.error, message, error, trace, pid, DateTime.now()));

  void fatal(Object? message, [Object? error, StackTrace? trace]) => log(Log(name, LogLevel.fatal, message, error, trace, pid, DateTime.now()));

  bool isTraceEnabled() => isEnabled(LogLevel.trace);

  bool isDebugEnabled() => isEnabled(LogLevel.debug);

  bool isInfoEnabled() => isEnabled(LogLevel.info);

  bool isWarnEnabled() => isEnabled(LogLevel.warn);

  bool isErrorEnabled() => isEnabled(LogLevel.error);

  bool isFatalEnabled() => isEnabled(LogLevel.fatal);

  /// 记录日志。
  void log(Log log) {
    LogAppender.doAppend(log).ignore();
  }

  /// 检查指定的日志级别是否启用。
  bool isEnabled(LogLevel logLevel) {
    try {
      return (ScaffoldLoggerOption.consoleAppenderEnabled(name) && ScaffoldLoggerOption.consoleAppenderLevel(name).index <= logLevel.index) ||
          (ScaffoldLoggerOption.fileAppenderEnabled(name) && ScaffoldLoggerOption.fileAppenderLevel(name).index <= logLevel.index);
    } catch (e) {
      return false;
    }
  }

  /// 生成日志消息的便捷方法，同时也为日志消息约定一致的格式。
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

  /// 防止toString()抛出异常
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
