import 'package:base/base.dart';
import 'package:flutter/material.dart';

import '../../app/client_message_manager.dart';
import '../../bean/client_message.dart';
import '../../bll/client_message_service.dart';
import '../page/client_message_page.dart';

class ClientMessageStatisticsWidget extends StatelessWidget {
  ClientMessageStatisticsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<_ClientMessageStatisticsController>(
        init: _ClientMessageStatisticsController(),
        builder: (controller) => FutureWidget<ClientMessageStatistics>(
          asyncValueGetter: controller.getStatistics,
          valueWidgetBuilder: (context, statistics, child) => _statisticsWidget(controller, statistics),
          waitingWidgetBuilder: (context) => _statisticsWidget(controller, null),
          failedWidgetBuilder: (context, error, child) => _statisticsWidget(controller, null),
          noneWidgetBuilder: (context) => _statisticsWidget(controller, null),
        ),
      );

  Widget _statisticsWidget(_ClientMessageStatisticsController controller, ClientMessageStatistics? statistics) => ListTile(
        tileColor: Colors.white,
        leading: Container(
          width: 45,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.notifications, color: Colors.white, size: 30),
        ),
        title: Row(
          children: <Widget>[
            Expanded(child: Text("系统消息", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 46.sp))),
            SizedBox(width: 10),
            Text(
              DateTimeHelper.smartFormat(statistics?.latestMessage?.time) ?? "",
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                statistics?.latestMessage?.summary ?? "暂时没有新消息",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            SizedBox(width: 10),
            if ((statistics?.unreadCount ?? 0) > 0) BadgeWidget.num(count: statistics!.unreadCount),
          ],
        ),
        onTap: () {
          Get.to(ClientMessagePage())?.whenComplete(() => controller.update());
        },
      );
}

class _ClientMessageStatisticsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    ClientMessageManager.clientMessageNotifier.addListener(onClientMessageNotify);
  }

  void onClientMessageNotify() => update();

  Future<ClientMessageStatistics> getStatistics() {
    return ClientMessageService.getStatistics();
  }

  @override
  void onClose() {
    ClientMessageManager.clientMessageNotifier.removeListener(onClientMessageNotify);
    super.onClose();
  }
}
