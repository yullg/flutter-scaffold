import '../../bean/client_configuration.dart';
import '../../core/remote_server.dart';

class ClientConfigurationRemote with RemoteServer {
  Future<ClientConfiguration> get({required String clientName, required String clientPlatform}) async {
    var data = await serverGet("/infrastructure/client-configuration", queryParameters: {
      "name": clientName,
      "platform": clientPlatform,
    });
    return ClientConfiguration(
      data,
      forceLeastClientVersionCode: data?["forceLeastClientVersionCode"],
      welcomeImage: data?["welcomeImage"],
    );
  }
}
