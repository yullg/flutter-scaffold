import 'dart:math';

import 'package:intl/intl.dart';

class FormatHelper {
  static int parseInt(Object source, {int? radix}) {
    if (source is num) return source.toInt();
    return int.parse(source.toString(), radix: radix);
  }

  static int? tryParseInt(Object? source, {int? radix}) {
    if (source == null) return null;
    try {
      return parseInt(source, radix: radix);
    } catch (e) {
      return null;
    }
  }

  static double parseDouble(Object source) {
    if (source is num) return source.toDouble();
    return double.parse(source.toString());
  }

  static double? tryParseDouble(Object? source) {
    if (source == null) return null;
    try {
      return parseDouble(source);
    } catch (e) {
      return null;
    }
  }

  static bool parseBool(Object source) {
    if (source is bool) return source;
    return bool.parse(source.toString(), caseSensitive: false);
  }

  static bool? tryParseBool(Object? source) {
    if (source == null) return null;
    try {
      return parseBool(source);
    } catch (e) {
      return null;
    }
  }

  static String parseString(Object source) {
    if (source is String) return source;
    return source.toString();
  }

  static String? tryParseString(Object? source) {
    if (source == null) return null;
    try {
      return parseString(source);
    } catch (e) {
      return null;
    }
  }

  static Uri parseUri(Object source) {
    if (source is Uri) return source;
    return Uri.parse(source.toString());
  }

  static Uri? tryParseUri(Object? source) {
    if (source == null) return null;
    try {
      return parseUri(source);
    } catch (e) {
      return null;
    }
  }

  static Duration parseDuration(
          {Object days = 0,
          Object hours = 0,
          Object minutes = 0,
          Object seconds = 0,
          Object milliseconds = 0,
          Object microseconds = 0}) =>
      Duration(
        days: parseInt(days),
        hours: parseInt(hours),
        minutes: parseInt(minutes),
        seconds: parseInt(seconds),
        milliseconds: parseInt(milliseconds),
        microseconds: parseInt(microseconds),
      );

  static Duration? tryParseDuration(
      {Object? days, Object? hours, Object? minutes, Object? seconds, Object? milliseconds, Object? microseconds}) {
    if (days == null &&
        hours == null &&
        minutes == null &&
        seconds == null &&
        milliseconds == null &&
        microseconds == null) return null;
    return Duration(
      days: tryParseInt(days) ?? 0,
      hours: tryParseInt(hours) ?? 0,
      minutes: tryParseInt(minutes) ?? 0,
      seconds: tryParseInt(seconds) ?? 0,
      milliseconds: tryParseInt(milliseconds) ?? 0,
      microseconds: tryParseInt(microseconds) ?? 0,
    );
  }

  static String printNum(num number, {int minFractionDigits = 0, int maxFractionDigits = 3, String? locale}) {
    final subtractNumber = 1 / pow(10, maxFractionDigits + 1) * 5;
    final pattern = "0.${'0' * minFractionDigits}${'#' * (maxFractionDigits - minFractionDigits)}";
    return NumberFormat(pattern, locale).format(number - subtractNumber);
  }

  FormatHelper._();
}
