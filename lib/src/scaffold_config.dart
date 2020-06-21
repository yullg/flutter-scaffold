import 'core/core_config.dart';
import 'support/logger/logger_config.dart';

class ScaffoldConfig {
  static final MutableCoreConfig _mutableCoreConfig = MutableCoreConfig();
  static final MutableLoggerConfig _mutableLoggerConfig = MutableLoggerConfig();

  static CoreConfig get core => _mutableCoreConfig;

  static LoggerConfig get logger => _mutableLoggerConfig;

  ScaffoldConfig doCoreConfig(void Function(MutableCoreConfig) block) {
    block(_mutableCoreConfig);
    return this;
  }

  ScaffoldConfig doLoggerConfig(void Function(MutableLoggerConfig) block) {
    block(_mutableLoggerConfig);
    return this;
  }

  @Deprecated(
      "This constructor is forced to be exposed because of syntax restrictions,"
      " but you should never use it.")
  ScaffoldConfig();
}
