enum LogLevel { trace, debug, info, warn, error, fatal }

class Log {
  final String name;
  final LogLevel level;
  final Object? message;
  final Object? error;
  final StackTrace? trace;
  final int processId;
  final DateTime time;

  const Log({
    required this.name,
    required this.level,
    this.message,
    this.error,
    this.trace,
    required this.processId,
    required this.time,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Log &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          level == other.level &&
          message == other.message &&
          error == other.error &&
          trace == other.trace &&
          processId == other.processId &&
          time == other.time;

  @override
  int get hashCode =>
      name.hashCode ^
      level.hashCode ^
      message.hashCode ^
      error.hashCode ^
      trace.hashCode ^
      processId.hashCode ^
      time.hashCode;

  @override
  String toString() {
    return 'Log{name: $name, level: $level, message: $message, error: $error, trace: $trace, processId: $processId, time: $time}';
  }
}
