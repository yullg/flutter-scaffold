import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../config/scaffold_logger_option.dart';
import 'log.dart';
import 'log_file_handler.dart';

class LogAppender {
  static void doAppend(Log log) {
    if (ScaffoldLoggerOption.consoleAppenderEnabled(log.name) &&
        ScaffoldLoggerOption.consoleAppenderLevel(log.name).index <=
            log.level.index) {
      _doAppendConsoleLog(log);
    }
    if (ScaffoldLoggerOption.fileAppenderEnabled(log.name) &&
        ScaffoldLoggerOption.fileAppenderLevel(log.name).index <=
            log.level.index) {
      _doAppendFileLog(log);
    }
  }

  static void _doAppendConsoleLog(Log log) {
    final sb = StringBuffer(
        "${log.name}\t${log.level.name}\t${log.time.toIso8601String()}");
    if (log.message != null) {
      sb.write("\t${log.message}");
    }
    if (log.error != null) {
      sb.write("\t${log.error}");
    }
    final message = sb.toString();
    final messageLines = message.split('\n');
    for (final messageLine in messageLines) {
      if (messageLine.length >= 800) {
        for (int i = 0, length = messageLine.length; i < length; i += 150) {
          debugPrintThrottled(messageLine.substring(i, min(i + 150, length)));
        }
      } else {
        debugPrintThrottled(messageLine);
      }
    }
    if (log.trace != null) {
      debugPrintThrottled(log.trace.toString());
    }
  }

  static void _doAppendFileLog(Log log) {
    final sb = StringBuffer(
        "${log.time.toIso8601String()}\t${log.processId}\t${log.level.name}");
    if (log.message != null) {
      sb.write("\t${log.message}");
    }
    if (log.error != null) {
      sb.write("\t${log.error}");
    }
    sb.writeln();
    if (log.trace != null) {
      sb.write(log.trace);
    }
    final logFileName = LogFileHandler.assignLogFileName(log);
    LogFileHandler(logFileName).write(sb.toString()).ignore();
  }
}
