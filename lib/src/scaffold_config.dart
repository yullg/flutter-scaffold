import 'core/error_printer.dart';
import 'support/database/database_schema.dart';
import 'support/logger/logger_config.dart';

class ScaffoldConfig {
  final int globalCacheManagerStalePeriod;
  final int globalCacheManagerMaxNrOfCacheObjects;
  final LoggerConfig loggerConfig;
  final DatabaseSchema? globalDatabaseSchema;
  final Iterable<ErrorPrinter>? errorPrinters;

  ScaffoldConfig({
    this.globalCacheManagerStalePeriod = 30,
    this.globalCacheManagerMaxNrOfCacheObjects = 99999,
    LoggerConfig? loggerConfig,
    this.globalDatabaseSchema,
    this.errorPrinters,
  }) : loggerConfig = loggerConfig ?? LoggerConfig();

  @override
  String toString() {
    return 'ScaffoldConfig{globalCacheManagerStalePeriod: $globalCacheManagerStalePeriod, globalCacheManagerMaxNrOfCacheObjects: $globalCacheManagerMaxNrOfCacheObjects, loggerConfig: $loggerConfig, globalDatabaseSchema: $globalDatabaseSchema, errorPrinters: $errorPrinters}';
  }
}
