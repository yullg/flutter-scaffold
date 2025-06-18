import 'package:dio/dio.dart';

import '../logger/default_logger.dart';
import '../logger/log.dart';
import '../logger/logger.dart';

class DioLogInterceptor extends LogInterceptor {
  final DioLogPrinter? _logPrinter;

  DioLogInterceptor({
    super.request,
    super.requestHeader,
    super.requestBody,
    super.responseHeader,
    super.responseBody,
    super.error,
    DioLogPrinter? logPrinter,
  }) : _logPrinter = logPrinter {
    logPrint = _doLogPrint;
  }

  void _doLogPrint(Object object) => _logPrinter?.print(object);
}

abstract interface class DioLogPrinter {
  void print(Object object);
}

class LoggerDioLogPrinter implements DioLogPrinter {
  final ILogger _logger;
  final LogLevel _level;

  LoggerDioLogPrinter({String? name, LogLevel level = LogLevel.debug})
    : _logger = name != null ? Logger(name) : DefaultLogger(),
      _level = level;

  @override
  void print(Object object) => switch (_level) {
    LogLevel.trace => _logger.trace(object),
    LogLevel.debug => _logger.debug(object),
    LogLevel.info => _logger.info(object),
    LogLevel.warn => _logger.warn(object),
    LogLevel.error => _logger.error(object),
    LogLevel.fatal => _logger.fatal(object),
  };
}
