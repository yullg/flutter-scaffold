import 'package:flutter/services.dart';

class IsoBasicPlugin {
  static const _methodChannel = MethodChannel("com.yullg.flutter.scaffold/basic");

  static Future<T?> invoke<T>(IosBasicMethod<T> method) {
    return _methodChannel.invokeMethod<T>(method.method, method.arguments);
  }

  IsoBasicPlugin._();
}

sealed class IosBasicMethod<T> {
  final String method;
  final dynamic arguments;

  const IosBasicMethod(this.method, [this.arguments]);
}

class ProcessInfoIBM<T> extends IosBasicMethod<T> {
  /// 自上次重启以来，系统已保持唤醒状态的时间。
  static const kSystemUptime = ProcessInfoIBM<double>._("ProcessInfoIBM.systemUptime");

  const ProcessInfoIBM._(super.method, [super.arguments]);
}
