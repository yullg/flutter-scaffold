import 'package:flutter/services.dart';

class DefaultMethodChannel {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/default");

  static Future<T?> invokeMethod<T>(String method, [dynamic arguments]) {
    return _methodChannel.invokeMethod<T>(method, arguments);
  }

  static Future<List<T>?> invokeListMethod<T>(String method, [dynamic arguments]) {
    return _methodChannel.invokeListMethod<T>(method, arguments);
  }

  static Future<Map<K, V>?> invokeMapMethod<K, V>(String method, [dynamic arguments]) {
    return _methodChannel.invokeMapMethod<K, V>(method, arguments);
  }

  DefaultMethodChannel._();
}
