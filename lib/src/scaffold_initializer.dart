import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart'
    if (dart.library.html) 'package:intl/intl_browser.dart';

import 'internal/fallback_logger.dart';
import 'internal/scaffold_logger.dart';
import 'scaffold_config.dart';
import 'support/logger/log_file_manager.dart';

/// 框架初始化器。
class ScaffoldInitializer {
  Future<void> initialize() async {
    try {
      await configure(ScaffoldConfig());
      await initializeIntl();
      await onInitialized();
      ScaffoldLogger.info("[ScaffoldInitializer] Initialize succeeded");
    } catch (e, s) {
      ScaffoldLogger.fatal("[ScaffoldInitializer] Initialize failed", e, s);
      rethrow;
    }
  }

  Future<void> initializeIntl() async {
    await findSystemLocale();
    await initializeDateFormatting();
  }

  Future<void> configure(ScaffoldConfig config) async {}

  Future<void> onInitialized() async {
    LogFileManager.deleteExpiredLogFile().catchError((e, s) {
      FallbackLogger.log("[Logger] Failed to delete log", e, s);
    });
  }
}
