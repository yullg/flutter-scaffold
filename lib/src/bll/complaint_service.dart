import '../core/scaffold_logger.dart';
import '../dal/remote/complaint_remote.dart';

class ComplaintService {
  final _complaintRemote = ComplaintRemote();

  Future<void> post({required String defendant, required String reason, required String summary, String? detail}) async {
    try {
      await _complaintRemote.post(defendant: defendant, reason: reason, summary: summary, detail: detail);
    } catch (e, s) {
      ScaffoldLogger.error(null, e, s);
      rethrow;
    }
  }
}
