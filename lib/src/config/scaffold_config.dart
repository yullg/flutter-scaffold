import 'scaffold_cache_option.dart';
import 'scaffold_database_option.dart';
import 'scaffold_developer_option.dart';
import 'scaffold_error_print_option.dart';
import 'scaffold_logger_option.dart';

class ScaffoldConfig {
  static const kCacheManagerKeyGlobal = "yullg_cache_manager_global";
  static const kDocumentManagerDirectory = "yullg/document";
  static const kSendCodeNameDefault = "yullg_send_code_default";

  static ScaffoldDeveloperOption? _developerOption;
  static ScaffoldCacheOption? _cacheOption;
  static ScaffoldDatabaseOption? _databaseOption;
  static ScaffoldErrorPrintOption? _errorPrintOption;
  static ScaffoldLoggerOption? _loggerOption;

  static ScaffoldDeveloperOption? get developerOption => _developerOption;

  static ScaffoldCacheOption? get cacheOption => _cacheOption;

  static ScaffoldDatabaseOption? get databaseOption => _databaseOption;

  static ScaffoldErrorPrintOption? get errorPrintOption => _errorPrintOption;

  static ScaffoldLoggerOption? get loggerOption => _loggerOption;

  static void apply({
    ScaffoldDeveloperOption? developerOption,
    ScaffoldCacheOption? cacheOption,
    ScaffoldDatabaseOption? databaseOption,
    ScaffoldErrorPrintOption? errorPrintOption,
    ScaffoldLoggerOption? loggerOption,
  }) {
    _developerOption = developerOption;
    _cacheOption = cacheOption;
    _databaseOption = databaseOption;
    _errorPrintOption = errorPrintOption;
    _loggerOption = loggerOption;
  }

  static void reset() {
    _developerOption = null;
    _cacheOption = null;
    _databaseOption = null;
    _errorPrintOption = null;
    _loggerOption = null;
  }

  ScaffoldConfig._();
}
