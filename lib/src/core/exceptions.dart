import 'package:base/base.dart';

void showException(dynamic exception, {String? message, String defaultMessage = "操作失败"}) {
  ToastLayer.show(message ?? extractMessage(exception) ?? defaultMessage);
}

String? extractMessage(dynamic exception) {
  if (exception is ShowableException) {
    return exception.message;
  } else if (exception is RemoteException) {
    return exception.message;
  }
  return null;
}

class ShowableException implements Exception {
  final String? message;
  final dynamic detail;

  const ShowableException(this.message, [this.detail]);

  @override
  String toString() {
    return 'ShowableException{message: $message, detail: $detail}';
  }
}

class RemoteException implements Exception {
  final int? code;
  final String? message;
  final dynamic detail;

  const RemoteException(this.code, this.message, [this.detail]);

  String toString() {
    return 'RemoteException{code: $code, message: $message, detail: $detail}';
  }
}
