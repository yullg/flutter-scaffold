import 'dart:io';

import '../app/client_configuration_manager.dart';
import '../bean/client_configuration.dart';
import '../core/scaffold_logger.dart';
import '../dal/remote/client_configuration_remote.dart';

class ClientConfigurationService {
  static final _clientConfigurationRemote = ClientConfigurationRemote();

  static Future<ClientConfiguration> loadClientConfiguration({required String name}) async {
    try {
      var clientConfiguration = await _clientConfigurationRemote.get(name: name, platform: Platform.operatingSystem);
      ClientConfigurationManager.clientConfigurationRx.value = clientConfiguration;
      return clientConfiguration;
    } catch (e, s) {
      ScaffoldLogger.error(null, e, s);
      rethrow;
    }
  }
}
