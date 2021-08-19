import 'package:base/base.dart';

import '../../core/remote_server.dart';

class ComplaintRemote with RemoteServer {
  Future<Podo?> post({required String defendant, required String reason, required String summary, String? detail}) async {
    await serverPost("/infrastructure/complaint", body: {
      "defendant": defendant,
      "reason": reason,
      "summary": summary,
      if (detail != null) "detail": detail,
    });
  }
}
