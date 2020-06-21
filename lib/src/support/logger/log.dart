import 'dart:io';

enum LogLevel { TRACE, DEBUG, INFO, WARN, ERROR, FATAL }

class Log {
  final String name;
  final LogLevel level;
  final Object? message;
  final Object? error;
  final StackTrace? trace;
  final int processId;
  final DateTime time;

  const Log(this.name, this.level, this.message, this.error, this.trace,
      this.processId, this.time);

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

class LogFile {
  final String name;
  final DateTime time;
  final File file;

  const LogFile(this.name, this.time, this.file);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogFile &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          time == other.time &&
          file == other.file;

  @override
  int get hashCode => name.hashCode ^ time.hashCode ^ file.hashCode;

  @override
  String toString() {
    return 'LogFile{name: $name, time: $time, file: $file}';
  }
}
