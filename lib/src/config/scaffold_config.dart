import 'scaffold_cache_option.dart';
import 'scaffold_database_option.dart';
import 'scaffold_developer_option.dart';
import 'scaffold_dio_option.dart';
import 'scaffold_logger_option.dart';
import 'scaffold_messenger_option.dart';

class ScaffoldConfig {
  static const kCacheManagerKeyGlobal = "yullg_cache_manager_global";
  static const kDocumentManagerDirectory = "yullg/document";
  static const kSendCodeNameDefault = "yullg_send_code_default";

  static ScaffoldDeveloperOption? _developerOption;
  static ScaffoldCacheOption? _cacheOption;
  static ScaffoldDatabaseOption? _databaseOption;
  static ScaffoldMessengerOption? _messengerOption;
  static ScaffoldLoggerOption? _loggerOption;
  static ScaffoldDioOption? _dioOption;

  static ScaffoldDeveloperOption? get developerOption => _developerOption;

  static ScaffoldCacheOption? get cacheOption => _cacheOption;

  static ScaffoldDatabaseOption? get databaseOption => _databaseOption;

  static ScaffoldMessengerOption? get messengerOption => _messengerOption;

  static ScaffoldLoggerOption? get loggerOption => _loggerOption;

  static ScaffoldDioOption? get dioOption => _dioOption;

  static void apply({
    ScaffoldDeveloperOption? developerOption,
    ScaffoldCacheOption? cacheOption,
    ScaffoldDatabaseOption? databaseOption,
    ScaffoldMessengerOption? messengerOption,
    ScaffoldLoggerOption? loggerOption,
    ScaffoldDioOption? dioOption,
  }) {
    _developerOption = developerOption;
    _cacheOption = cacheOption;
    _databaseOption = databaseOption;
    _messengerOption = messengerOption;
    _loggerOption = loggerOption;
    _dioOption = dioOption;
  }

  static void reset() {
    _developerOption = null;
    _cacheOption = null;
    _databaseOption = null;
    _messengerOption = null;
    _loggerOption = null;
    _dioOption = null;
  }

  ScaffoldConfig._();
}
