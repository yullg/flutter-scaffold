import 'package:dio/io.dart';
import 'package:scaffold/scaffold_sugar.dart';

import '../../config/scaffold_config.dart';

class GlobalDio extends DioForNative {
  static GlobalDio? _instance;

  factory GlobalDio() {
    return _instance ??= GlobalDio._();
  }

  GlobalDio._() : super(ScaffoldConfig.httpOption?.globalDioOptions) {
    ScaffoldConfig.httpOption?.globalDioInterceptors?.also((it) {
      interceptors.addAll(it);
    });
  }

  @override
  void close({bool force = false}) {
    // 禁用 dispose，防止实例被销毁
    throw UnsupportedError('Singleton instances should not be closed.');
  }
}
