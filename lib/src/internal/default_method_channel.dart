import 'package:flutter/services.dart';

import '../scaffold_constants.dart';

class DefaultMethodChannel {
  static const _methodChannel =
      MethodChannel(ScaffoldConstants.CHANNEL_NAME_DEFAULT);

  static Future<T?> invokeMethod<T>(String method, [dynamic arguments]) {
    return _methodChannel.invokeMethod(method, arguments);
  }

  static Future<List<T>?> invokeListMethod<T>(String method,
      [dynamic arguments]) {
    return _methodChannel.invokeListMethod(method, arguments);
  }

  static Future<Map<K, V>?> invokeMapMethod<K, V>(String method,
      [dynamic arguments]) {
    return _methodChannel.invokeMapMethod(method, arguments);
  }

  DefaultMethodChannel._();
}
