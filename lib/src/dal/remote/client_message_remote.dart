import 'package:base/base.dart';

import '../../bean/client_message.dart';
import '../../core/remote_server.dart';
import '../../core/list_snippet.dart';

class ClientMessageRemote with RemoteServer {
  Future<ClientMessageStatistics> getStatistics({required String platform, required DateTime? lastReadTime}) async {
    var data = await serverGet("/infrastructure/client-message/statistics", queryParameters: {
      "platform": platform,
      if (lastReadTime != null) "lastReadTime": lastReadTime.millisecondsSinceEpoch,
    });
    return ClientMessageStatistics(
      unreadCount: data["unreadCount"],
      latestMessage: NullHelper.safeFunction<Map, ClientMessage?>(
          data["latestMessage"],
          (map) => ClientMessage(
                id: map["id"],
                title: map["title"],
                summary: map["summary"],
                content: "",
                link: null,
                time: DateTime.fromMillisecondsSinceEpoch(map["time"]),
              ),
          null),
    );
  }

  Future<ListSnippet<ClientMessage>> getList({required String platform, int? offset, int? limit}) async {
    var data = await serverGet("/infrastructure/client-message/list", queryParameters: {
      "platform": platform,
      if (offset != null) "offset": offset,
      if (limit != null) "limit": limit,
    });
    return ListSnippet<ClientMessage>(
      total: data["total"],
      list: data["list"]
          .map<ClientMessage>((e) => ClientMessage(
                id: e["id"],
                title: e["title"],
                summary: e["summary"],
                content: e["content"],
                link: e["link"],
                time: DateTime.fromMillisecondsSinceEpoch(e["time"]),
              ))
          .toList(),
    );
  }
}
