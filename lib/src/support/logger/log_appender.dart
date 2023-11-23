import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../scaffold_module.dart';
import 'log.dart';
import 'log_file_manager.dart';

class LogAppender {
  static Future<void> doAppend(Log log) async {
    if (ScaffoldModule.config.findLoggerConsoleAppenderEnabled(log.name) &&
        ScaffoldModule.config.findLoggerConsoleAppenderLevel(log.name).index <= log.level.index) {
      _doAppendConsoleLog(log);
    }
    if (ScaffoldModule.config.findLoggerFileAppenderEnabled(log.name) &&
        ScaffoldModule.config.findLoggerFileAppenderLevel(log.name).index <= log.level.index) {
      await _doAppendFileLog(log);
    }
  }

  static void _doAppendConsoleLog(Log log) {
    StringBuffer sb = StringBuffer(
        "${log.processId}\t${log.name}\t${log.level.name}\t${log.time.toIso8601String()}\t${log.message ?? '---'}");
    if (log.error != null) {
      sb.write("\t${log.error}");
    }
    if (log.trace != null) {
      sb.writeln();
      sb.write(log.trace);
    }
    debugPrintThrottled(sb.toString().trim());
  }

  static Future<void> _doAppendFileLog(Log log) async {
    StringBuffer sb = StringBuffer(
        "${log.processId}\t${log.name}\t${log.level.name}\t${log.time.toIso8601String()}\t${log.message ?? '---'}");
    if (log.error != null) {
      sb.write("\t${log.error}");
    }
    sb.writeln();
    if (log.trace != null) {
      sb.write(log.trace);
    }
    await (await LogFileManager.createFileForLog(log)).writeAsString(sb.toString(), mode: FileMode.append);
  }
}
