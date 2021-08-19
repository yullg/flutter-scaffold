import 'package:base/base.dart';

class ClientMessageManager {
  static SimpleChangeNotifier? _clientMessageNotifier;

  static Future<void> initialize() async {
    _clientMessageNotifier = SimpleChangeNotifier();
  }

  static SimpleChangeNotifier get clientMessageNotifier => _clientMessageNotifier!;

  static Future<void> destroy() async {
    _clientMessageNotifier?.dispose();
    _clientMessageNotifier = null;
  }

  ClientMessageManager._();
}
