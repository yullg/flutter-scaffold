import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';

import 'helper/sp_helper.dart';
import 'internal/scaffold_logger.dart';
import 'scaffold_config.dart';
import 'support/logger/log_file_manager.dart';

/// 框架初始化器。
class ScaffoldInitializer {
  static Future<void> initialize(
    BuildContext context, {
    void Function(ScaffoldConfig)? configure,
  }) async {
    try {
      configure?.call(ScaffoldConfig());
      await SPHelper.initialize();
      await _initializeIntl();
      await _onInitialized();
      ScaffoldLogger.info("[ScaffoldInitializer] Initialize succeeded");
    } catch (e, s) {
      ScaffoldLogger.fatal("[ScaffoldInitializer] Initialize failed", e, s);
      rethrow;
    }
  }

  static Future<void> _initializeIntl() async {
    await findSystemLocale();
    await initializeDateFormatting();
  }

  static Future<void> _onInitialized() async {
    LogFileManager.deleteExpiredLogFile().catchError((e, s) {
      // ignore
    });
  }
}
