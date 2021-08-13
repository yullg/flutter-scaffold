import 'package:base/base.dart';

import '../bean/client_configuration.dart';

class ClientConfigurationManager {
  static final clientConfigurationRx = Rxn<ClientConfiguration>(null);

  static Future<void> initialize() async {}

  static Future<void> destroy() async {
    clientConfigurationRx.value = null;
  }

  ClientConfigurationManager._();
}
