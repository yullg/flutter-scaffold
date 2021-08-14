import '../../bean/client_version.dart';
import '../../core/remote_server.dart';

class ClientVersionRemote with RemoteServer {
  Future<ClientVersion?> checkUpdate({required String name, required String platform, required int currentVersionCode}) async {
    var data = await serverGet("/infrastructure/client-version/checkUpdate", queryParameters: {
      "name": name,
      "platform": platform,
      "currentVersionCode": currentVersionCode,
    });
    if (data == null) return null;
    return ClientVersion(
        versionName: data["versionName"],
        versionCode: data["versionCode"],
        changelog: <String>[...?data["changelog"]?.split("\n")],
        downloadLink: data["downloadLink"],
        time: DateTime.fromMillisecondsSinceEpoch(data["time"]),
        ignorable: data["ignorable"]);
  }
}
