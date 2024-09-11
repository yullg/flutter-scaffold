import 'dart:io';

abstract interface class LogFileUploader {
  Future<void> upload(File file);
}
