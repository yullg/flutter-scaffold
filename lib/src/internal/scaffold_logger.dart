import '../scaffold_constants.dart';
import '../support/logger/log.dart';
import '../support/logger/logger.dart';

class ScaffoldLogger {
  static const _logger = Logger(ScaffoldConstants.kLoggerNameScaffold);

  static String get name => _logger.name;

  static void trace(Object? message, [Object? error, StackTrace? trace]) => _logger.trace(message, error, trace);

  static void debug(Object? message, [Object? error, StackTrace? trace]) => _logger.debug(message, error, trace);

  static void info(Object? message, [Object? error, StackTrace? trace]) => _logger.info(message, error, trace);

  static void warn(Object? message, [Object? error, StackTrace? trace]) => _logger.warn(message, error, trace);

  static void error(Object? message, [Object? error, StackTrace? trace]) => _logger.error(message, error, trace);

  static void fatal(Object? message, [Object? error, StackTrace? trace]) => _logger.fatal(message, error, trace);

  static bool isTraceEnabled() => _logger.isTraceEnabled();

  static bool isDebugEnabled() => _logger.isDebugEnabled();

  static bool isInfoEnabled() => _logger.isInfoEnabled();

  static bool isWarnEnabled() => _logger.isWarnEnabled();

  static bool isErrorEnabled() => _logger.isErrorEnabled();

  static bool isFatalEnabled() => _logger.isFatalEnabled();

  static void log(Log log) => _logger.log(log);

  static bool isEnabled(LogLevel logLevel) => _logger.isEnabled(logLevel);
}
