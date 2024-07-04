import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';

import 'internal/scaffold_logger.dart';
import 'scaffold_config.dart';
import 'scaffold_constants.dart';
import 'support/logger/log_file_manager.dart';
import 'support/logger/logger.dart';

/// 框架初始化器。
class ScaffoldModule {
  static late ScaffoldConfig _config;

  static ScaffoldConfig get config => _config;

  static Future<void> initialize(
    BuildContext context, {
    ScaffoldConfig? config,
  }) async {
    try {
      ScaffoldLogger.info(Logger.message(library: _kLogLibrary, part: "Initialize", what: "begin"));
      _config = config ?? ScaffoldConfig();
      await GetStorage.init(ScaffoldConstants.kGetStorageNameScaffold);
      await GetStorage.init(ScaffoldConstants.kGetStorageNameSP);
      await _initializeIntl();
      await _onInitialized();
      ScaffoldLogger.info(Logger.message(library: _kLogLibrary, part: "Initialize", what: "end"));
    } catch (e, s) {
      ScaffoldLogger.fatal(Logger.message(library: _kLogLibrary, part: "Initialize", what: "failed"), e, s);
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

const _kLogLibrary = "scaffold_module";
