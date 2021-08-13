import 'package:base/base.dart';

class ScaffoldLogger {
  static const _logger = Logger("scaffold", "scaffold");

  static void trace(dynamic message, [dynamic error, StackTrace? trace]) {
    _logger.trace(message, error, trace);
  }

  static void debug(dynamic message, [dynamic error, StackTrace? trace]) {
    _logger.debug(message, error, trace);
  }

  static void info(dynamic message, [dynamic error, StackTrace? trace]) {
    _logger.info(message, error, trace);
  }

  static void warn(dynamic message, [dynamic error, StackTrace? trace]) {
    _logger.warn(message, error, trace);
  }

  static void error(dynamic message, [dynamic error, StackTrace? trace]) {
    _logger.error(message, error, trace);
  }

  static void fatal(dynamic message, [dynamic error, StackTrace? trace]) {
    _logger.fatal(message, error, trace);
  }

  ScaffoldLogger._();
}
