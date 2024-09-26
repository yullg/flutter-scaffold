import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'scaffold_logger.dart';

class ScaffoldDio extends DioForNative {
  static ScaffoldDio? _instance;

  factory ScaffoldDio() {
    return _instance ??= ScaffoldDio._();
  }

  ScaffoldDio._()
      : super(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (log) => ScaffoldLogger.debug(log),
    ));
  }

  @override
  void close({bool force = false}) {
    // 禁用 dispose，防止实例被销毁
    throw UnsupportedError('Singleton instances should not be closed.');
  }
}
