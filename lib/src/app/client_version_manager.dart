import 'package:base/base.dart';

import '../bean/client_version.dart';

class ClientVersionManager {
  static final clientVersionUpdateRx = Rxn<ClientVersion>(null);

  static Future<void> initialize() async {}

  static Future<void> destroy() async {
    clientVersionUpdateRx.value = null;
  }

  ClientVersionManager._();
}
