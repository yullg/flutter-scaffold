import '../../config/scaffold_logger_option.dart';
import 'logger.dart';

final class DefaultLogger extends LoggerForward {
  static DefaultLogger? _instance;

  factory DefaultLogger() {
    return _instance ??= DefaultLogger._();
  }

  DefaultLogger._()
      : super(const Logger(ScaffoldLoggerOption.kLoggerNameDefault));
}
