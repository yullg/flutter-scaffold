import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../bean/client_message.dart';
import '../../bll/client_message_service.dart';
import '../../core/list_snippet.dart';
import '../widget/easy_future_paged_list_widget.dart';

class ClientMessagePage extends StatelessWidget {
  ClientMessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<_ClientMessageController>(
      init: _ClientMessageController(),
      builder: (controller) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("系统消息"),
        ),
        body: EasyFuturePagedListWidget<ClientMessage>(
          loadMoreData: controller.loadMoreData,
          dataToWidget: buildMessageWidget,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        ),
      ),
    );
  }

  Widget buildMessageWidget(BuildContext context, int index, ClientMessage message) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(DateTimeHelper.smartFormat(message.time) ?? "", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 10),
          InkWell(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Html(data: message.content),
            ),
            onTap: message.link != null
                ? () {
                    Get.to(WebViewPage(initialUrl: message.link));
                  }
                : null,
          )
        ],
      );
}

class _ClientMessageController extends GetxController {
  Future<ListSnippet<ClientMessage>> loadMoreData(int offset) {
    return ClientMessageService.getList(offset: offset, limit: 10);
  }
}
