import 'dart:io';
import 'dart:math';

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
    final sb = StringBuffer("${log.processId}\t${log.name}\t${log.level.name}\t${log.time.toIso8601String()}");
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

  static Future<void> _doAppendFileLog(Log log) async {
    final sb = StringBuffer("${log.processId}\t${log.name}\t${log.level.name}\t${log.time.toIso8601String()}");
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
    await (await LogFileManager.createFileForLog(log)).writeAsString(sb.toString(), mode: FileMode.append);
  }
}
