import 'dart:io';

import 'package:base/base.dart';

import '../app/client_version_manager.dart';
import '../bean/client_version.dart';
import '../core/scaffold_logger.dart';
import '../dal/remote/client_version_remote.dart';

class ClientVersionService {
  static final _clientVersionRemote = ClientVersionRemote();

  static Future<ClientVersion?> checkUpdate({required String name}) async {
    try {
      var clientVersion = await _clientVersionRemote.checkUpdate(
          name: name, platform: Platform.operatingSystem, currentVersionCode: int.parse(PackageInfoManager.versionCode));
      ClientVersionManager.clientVersionUpdateRx.value = clientVersion;
      return clientVersion;
    } catch (e, s) {
      ScaffoldLogger.error(null, e, s);
      rethrow;
    }
  }
}
