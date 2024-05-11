import 'dart:io';
import 'dart:math';

import 'package:intl/intl.dart';

import '../core/no_value_given.dart';

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

  static Duration parseDuration({
    Object? days,
    Object? hours,
    Object? minutes,
    Object? seconds,
    Object? milliseconds,
    Object? microseconds,
  }) {
    return Duration(
      days: days != null ? parseInt(days) : 0,
      hours: hours != null ? parseInt(hours) : 0,
      minutes: minutes != null ? parseInt(minutes) : 0,
      seconds: seconds != null ? parseInt(seconds) : 0,
      milliseconds: milliseconds != null ? parseInt(milliseconds) : 0,
      microseconds: microseconds != null ? parseInt(microseconds) : 0,
    );
  }

  static Duration? tryParseDuration({
    Object? days,
    Object? hours,
    Object? minutes,
    Object? seconds,
    Object? milliseconds,
    Object? microseconds,
  }) {
    try {
      return parseDuration(
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds,
      );
    } catch (e) {
      return null;
    }
  }

  static DateTime parseDateTime({
    Object httpDate = const NoValueGiven(),
    Object millisecondsSinceEpoch = const NoValueGiven(),
    Object microsecondsSinceEpoch = const NoValueGiven(),
    Object year = const NoValueGiven(),
    Object? month,
    Object? day,
    Object? hour,
    Object? minute,
    Object? second,
    Object? millisecond,
    Object? microsecond,
    bool isUtc = false,
  }) {
    if (httpDate is! NoValueGiven) {
      if (httpDate is DateTime) return httpDate;
      return HttpDate.parse(httpDate.toString());
    } else if (millisecondsSinceEpoch is! NoValueGiven) {
      return DateTime.fromMillisecondsSinceEpoch(parseInt(millisecondsSinceEpoch), isUtc: isUtc);
    } else if (microsecondsSinceEpoch is! NoValueGiven) {
      return DateTime.fromMicrosecondsSinceEpoch(parseInt(microsecondsSinceEpoch), isUtc: isUtc);
    } else if (year is! NoValueGiven) {
      if (isUtc) {
        return DateTime.utc(
          parseInt(year),
          month != null ? parseInt(month) : 1,
          day != null ? parseInt(day) : 1,
          hour != null ? parseInt(hour) : 0,
          minute != null ? parseInt(minute) : 0,
          second != null ? parseInt(second) : 0,
          millisecond != null ? parseInt(millisecond) : 0,
          microsecond != null ? parseInt(microsecond) : 0,
        );
      } else {
        return DateTime(
          parseInt(year),
          month != null ? parseInt(month) : 1,
          day != null ? parseInt(day) : 1,
          hour != null ? parseInt(hour) : 0,
          minute != null ? parseInt(minute) : 0,
          second != null ? parseInt(second) : 0,
          millisecond != null ? parseInt(millisecond) : 0,
          microsecond != null ? parseInt(microsecond) : 0,
        );
      }
    }
    throw ArgumentError("millisecondsSinceEpoch, microsecondsSinceEpoch and year must not all be null");
  }

  static DateTime? tryParseDateTime({
    Object? httpDate,
    Object? millisecondsSinceEpoch,
    Object? microsecondsSinceEpoch,
    Object? year,
    Object? month,
    Object? day,
    Object? hour,
    Object? minute,
    Object? second,
    Object? millisecond,
    Object? microsecond,
    bool isUtc = false,
  }) {
    if (httpDate == null && millisecondsSinceEpoch == null && microsecondsSinceEpoch == null && year == null) {
      return null;
    }
    try {
      return parseDateTime(
        httpDate: httpDate ?? const NoValueGiven(),
        millisecondsSinceEpoch: millisecondsSinceEpoch ?? const NoValueGiven(),
        microsecondsSinceEpoch: microsecondsSinceEpoch ?? const NoValueGiven(),
        year: year ?? const NoValueGiven(),
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second,
        millisecond: millisecond,
        microsecond: microsecond,
        isUtc: isUtc,
      );
    } catch (e) {
      return null;
    }
  }

  static String printNum(num number, {int minFractionDigits = 0, int maxFractionDigits = 3, String? locale}) {
    final subtractNumber = 1 / pow(10, maxFractionDigits + 1) * 5;
    final pattern = "0.${'0' * minFractionDigits}${'#' * (maxFractionDigits - minFractionDigits)}";
    return NumberFormat(pattern, locale).format(number - subtractNumber);
  }

  FormatHelper._();
}
