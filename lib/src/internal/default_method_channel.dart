import 'package:flutter/services.dart';

import '../scaffold_constants.dart';

class DefaultMethodChannel {
  static const _methodChannel = MethodChannel(ScaffoldConstants.kChannelNameDefault);

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
