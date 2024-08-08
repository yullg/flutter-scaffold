import 'scaffold_cache_option.dart';
import 'scaffold_database_option.dart';
import 'scaffold_error_print_option.dart';
import 'scaffold_logger_option.dart';

class ScaffoldConfig {
  static ScaffoldCacheOption? _cacheOption;
  static ScaffoldDatabaseOption? _databaseOption;
  static ScaffoldErrorPrintOption? _errorPrintOption;
  static ScaffoldLoggerOption? _loggerOption;

  static ScaffoldCacheOption? get cacheOption => _cacheOption;

  static ScaffoldDatabaseOption? get databaseOption => _databaseOption;

  static ScaffoldErrorPrintOption? get errorPrintOption => _errorPrintOption;

  static ScaffoldLoggerOption? get loggerOption => _loggerOption;

  static void apply({
    ScaffoldCacheOption? cacheOption,
    ScaffoldDatabaseOption? databaseOption,
    ScaffoldErrorPrintOption? errorPrintOption,
    ScaffoldLoggerOption? loggerOption,
  }) {
    _cacheOption = cacheOption;
    _databaseOption = databaseOption;
    _errorPrintOption = errorPrintOption;
    _loggerOption = loggerOption;
  }

  static void reset() {
    _cacheOption = null;
    _databaseOption = null;
    _errorPrintOption = null;
    _loggerOption = null;
  }

  ScaffoldConfig._();
}
