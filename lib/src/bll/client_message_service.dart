import 'dart:io';

import 'package:base/base.dart';

import '../bean/client_message.dart';
import '../core/list_snippet.dart';
import '../core/scaffold_logger.dart';
import '../dal/remote/client_message_remote.dart';

const _lastReadTimeKey = "scaffold_client_message_service_lastReadTime";

class ClientMessageService {
  static final _clientMessageRemote = ClientMessageRemote();

  static Future<ClientMessageStatistics> getStatistics() async {
    try {
      int? lastReadTimestamp = SharedPreferenceManager.instance.getInt(_lastReadTimeKey);
      DateTime? lastReadTime = lastReadTimestamp != null ? DateTime.fromMillisecondsSinceEpoch(lastReadTimestamp) : null;
      return await _clientMessageRemote.getStatistics(platform: Platform.operatingSystem, lastReadTime: lastReadTime);
    } catch (e, s) {
      ScaffoldLogger.error(null, e, s);
      rethrow;
    }
  }

  static Future<ListSnippet<ClientMessage>> getList({int? offset, int? limit}) async {
    try {
      SharedPreferenceManager.instance.setInt(_lastReadTimeKey, DateTime.now().millisecondsSinceEpoch).catchError((e, s) {
        ScaffoldLogger.error(null, e, s);
      });
      return await _clientMessageRemote.getList(platform: Platform.operatingSystem, offset: offset, limit: limit);
    } catch (e, s) {
      ScaffoldLogger.error(null, e, s);
      rethrow;
    }
  }
}
