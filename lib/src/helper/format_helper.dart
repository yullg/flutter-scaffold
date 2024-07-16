import 'dart:io';
import 'dart:math';

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
    Object httpDate = const _NoValueGiven(),
    Object millisecondsSinceEpoch = const _NoValueGiven(),
    Object microsecondsSinceEpoch = const _NoValueGiven(),
    Object year = const _NoValueGiven(),
    Object? month,
    Object? day,
    Object? hour,
    Object? minute,
    Object? second,
    Object? millisecond,
    Object? microsecond,
    bool isUtc = false,
  }) {
    if (httpDate is! _NoValueGiven) {
      if (httpDate is DateTime) return httpDate;
      return HttpDate.parse(httpDate.toString());
    } else if (millisecondsSinceEpoch is! _NoValueGiven) {
      return DateTime.fromMillisecondsSinceEpoch(parseInt(millisecondsSinceEpoch), isUtc: isUtc);
    } else if (microsecondsSinceEpoch is! _NoValueGiven) {
      return DateTime.fromMicrosecondsSinceEpoch(parseInt(microsecondsSinceEpoch), isUtc: isUtc);
    } else if (year is! _NoValueGiven) {
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
        httpDate: httpDate ?? const _NoValueGiven(),
        millisecondsSinceEpoch: millisecondsSinceEpoch ?? const _NoValueGiven(),
        microsecondsSinceEpoch: microsecondsSinceEpoch ?? const _NoValueGiven(),
        year: year ?? const _NoValueGiven(),
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

  static String printNum(num number, {int minFractionDigits = 0, int maxFractionDigits = 3, bool round = true}) {
    if (number.isFinite && number is double) {
      maxFractionDigits = min(round ? 20 : 19, max(0, maxFractionDigits));
      minFractionDigits = min(maxFractionDigits, max(0, minFractionDigits));
      String result = number.toStringAsFixed(round ? maxFractionDigits : maxFractionDigits + 1);
      if (!round && result.isNotEmpty) {
        result = result.substring(0, result.length - 1);
      }
      final dotIndex = result.indexOf(".");
      if (dotIndex >= 0) {
        // 去掉多余的0
        while (result.endsWith("0")) {
          result = result.substring(0, result.length - 1);
        }
        // 如果小数点后位数小于最小值，则补0
        while (result.length - 1 - dotIndex < minFractionDigits) {
          result += "0";
        }
        // 在没有小数位时去掉末尾的小数点
        while (result.endsWith(".")) {
          result = result.substring(0, result.length - 1);
        }
      }
      return result;
    } else {
      return number.toString();
    }
  }

  FormatHelper._();
}

final class _NoValueGiven {
  const _NoValueGiven();
}
