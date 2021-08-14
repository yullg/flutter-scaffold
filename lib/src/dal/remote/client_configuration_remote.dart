import '../../bean/client_configuration.dart';
import '../../core/remote_server.dart';

class ClientConfigurationRemote with RemoteServer {
  Future<ClientConfiguration> get({required String name, required String platform}) async {
    var data = await serverGet("/infrastructure/client-configuration", queryParameters: {
      "name": name,
      "platform": platform,
    });
    return ClientConfiguration(
      data,
      welcomeImage: data?["welcomeImage"],
    );
  }
}
