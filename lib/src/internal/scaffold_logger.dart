import '../config/scaffold_logger_option.dart';
import '../support/logger/logger.dart';

final class ScaffoldLogger extends LoggerForward {
  static ScaffoldLogger? _instance;

  factory ScaffoldLogger() {
    return _instance ??= ScaffoldLogger._();
  }

  ScaffoldLogger._()
      : super(const Logger(ScaffoldLoggerOption.kLoggerNameScaffold));
}
