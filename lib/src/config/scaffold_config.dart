import 'scaffold_cache_option.dart';
import 'scaffold_database_option.dart';
import 'scaffold_developer_option.dart';
import 'scaffold_http_option.dart';
import 'scaffold_logger_option.dart';
import 'scaffold_messenger_option.dart';

class ScaffoldConfig {
  static const kCacheManagerKeyGlobal = "yullg_cache_manager_global";
  static const kDocumentManagerDirectory = "yullg/document";
  static const kSendCodeNameDefault = "yullg_send_code_default";

  static ScaffoldLoggerOption? _loggerOption;
  static ScaffoldHttpOption? _httpOption;
  static ScaffoldDatabaseOption? _databaseOption;
  static ScaffoldMessengerOption? _messengerOption;
  static ScaffoldCacheOption? _cacheOption;
  static ScaffoldDeveloperOption? _developerOption;

  static ScaffoldLoggerOption? get loggerOption => _loggerOption;

  static ScaffoldHttpOption? get httpOption => _httpOption;

  static ScaffoldDatabaseOption? get databaseOption => _databaseOption;

  static ScaffoldMessengerOption? get messengerOption => _messengerOption;

  static ScaffoldCacheOption? get cacheOption => _cacheOption;

  static ScaffoldDeveloperOption? get developerOption => _developerOption;

  static void apply({
    ScaffoldLoggerOption? loggerOption,
    ScaffoldHttpOption? httpOption,
    ScaffoldDatabaseOption? databaseOption,
    ScaffoldMessengerOption? messengerOption,
    ScaffoldCacheOption? cacheOption,
    ScaffoldDeveloperOption? developerOption,
  }) {
    _loggerOption = loggerOption;
    _httpOption = httpOption;
    _databaseOption = databaseOption;
    _messengerOption = messengerOption;
    _cacheOption = cacheOption;
    _developerOption = developerOption;
  }

  static void reset() {
    _loggerOption = null;
    _httpOption = null;
    _databaseOption = null;
    _messengerOption = null;
    _cacheOption = null;
    _developerOption = null;
  }

  ScaffoldConfig._();
}
