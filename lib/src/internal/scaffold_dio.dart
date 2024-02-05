import 'package:dio/dio.dart';

import 'scaffold_logger.dart';

class ScaffoldDio {
  static final Dio dio = _newDio();

  static Dio _newDio() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (log) => ScaffoldLogger.debug(log),
    ));
    return dio;
  }

  ScaffoldDio._();
}
