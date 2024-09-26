import 'package:dio/dio.dart';

class ScaffoldDioOption {
  final BaseOptions? globalDioOptions;
  final Iterable<Interceptor>? globalDioInterceptors;

  const ScaffoldDioOption({
    this.globalDioOptions,
    this.globalDioInterceptors,
  });

  @override
  String toString() {
    return 'ScaffoldDioOption{globalDioOptions: $globalDioOptions, globalDioInterceptors: $globalDioInterceptors}';
  }
}
