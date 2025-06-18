import 'package:dio/dio.dart';

class ScaffoldHttpOption {
  final BaseOptions? globalDioOptions;
  final Iterable<Interceptor>? globalDioInterceptors;

  const ScaffoldHttpOption({this.globalDioOptions, this.globalDioInterceptors});

  @override
  String toString() {
    return 'ScaffoldHttpOption{globalDioOptions: $globalDioOptions, globalDioInterceptors: $globalDioInterceptors}';
  }
}
