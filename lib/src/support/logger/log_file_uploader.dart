import 'log.dart';

abstract interface class LogFileUploader {
  Future<void> upload(LogFile logFile);
}
