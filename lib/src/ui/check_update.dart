import 'package:base/base.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bean/client_version.dart';
import '../bll/client_version_service.dart';

Future<void> checkUpdate({required String clientName, bool showLoadingDialog = true}) async {
  ClientVersion? clientVersion;
  if (showLoadingDialog) {
    try {
      DialogLayer.showLoadingDialog(title: "正在检查更新...");
      clientVersion = await ClientVersionService.checkUpdate(name: clientName);
    } finally {
      DialogLayer.close();
    }
  } else {
    clientVersion = await ClientVersionService.checkUpdate(name: clientName);
  }
  if (clientVersion != null) {
    await DialogLayer.showAlertDialog(
      title: "发现新版本 ${clientVersion.versionName}",
      content: clientVersion.changelog,
      implicitClose: false,
      autoClose: false,
      actions: [
        if (clientVersion.ignorable) AlertDialogAction(name: "以后再说", onPressed: () => DialogLayer.close()),
        AlertDialogAction(
          name: "立即更新",
          color: Get.theme.primaryColor,
          onPressed: () {
            if (clientVersion!.ignorable) DialogLayer.close();
            if (clientVersion.downloadLink != null) {
              launch(clientVersion.downloadLink!).catchError((e) {
                ToastLayer.show("请在应用市场中下载更新", durable: true);
              });
            } else {
              ToastLayer.show("请在应用市场中下载更新", durable: true);
            }
          },
        ),
      ],
    );
    if (!clientVersion.ignorable) {
      // 理论上不会执行到这里，但还是预防一下Dialog异常关闭
      throw AbortException(clientVersion);
    }
  }
}
