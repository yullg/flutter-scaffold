import 'log.dart';

abstract class LogFileUploader {
  Future<void> upload(LogFile logFile);
}
