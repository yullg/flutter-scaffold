import 'package:scaffold/scaffold_lang.dart';

import '../../helper/string_helper.dart';
import 'logger.dart';

/// 为日志消息约定一致的格式。
extension LoggerMessagings on ILogger {
  LoggerMessaging messaging({
    String? library,
    String? what,
    List<Object?>? args,
    Map<String, Object?>? namedArgs,
    Object? result = const _NoValueGiven(),
  }) {
    final sb = StringBuffer();
    library?.also((it) {
      sb.write("$it\t");
    });
    what?.also((it) {
      sb.write("$it ");
    });
    final argStringList = <String>[];
    args?.forEach((e) {
      argStringList.add(_safeToString(e));
    });
    namedArgs?.forEach((key, value) {
      argStringList.add("$key: ${_safeToString(value)}");
    });
    if (argStringList.isNotEmpty) {
      sb.write("( ");
      sb.writeAll(argStringList, ", ");
      sb.write(" ) ");
    }
    if (result is! _NoValueGiven) {
      sb.write("> ${_safeToString(result)}");
    }
    final message = StringHelper.trimToNull(sb.toString());
    return LoggerMessaging(this, message);
  }
}

final class LoggerMessaging {
  final ILogger _logger;
  final String? _message;

  LoggerMessaging(this._logger, this._message);

  void trace([Object? error, StackTrace? trace]) => _logger.trace(_message, error, trace);

  void debug([Object? error, StackTrace? trace]) => _logger.debug(_message, error, trace);

  void info([Object? error, StackTrace? trace]) => _logger.info(_message, error, trace);

  void warn([Object? error, StackTrace? trace]) => _logger.warn(_message, error, trace);

  void error([Object? error, StackTrace? trace]) => _logger.error(_message, error, trace);

  void fatal([Object? error, StackTrace? trace]) => _logger.fatal(_message, error, trace);
}

final class _NoValueGiven {
  const _NoValueGiven();
}

/// 防止toString()出错
String _safeToString(Object? obj) {
  try {
    return obj.toString();
  } catch (e) {
    return "(${obj.runtimeType})";
  }
}
