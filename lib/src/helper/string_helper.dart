import 'dart:math';

/// [String]工具类
class StringHelper {
  /// 检查[str]是否为null或空("")。
  static bool isEmpty(String? str) {
    return str == null || str.isEmpty;
  }

  /// 检查[str]是否不为null且不为空("")。
  static bool isNotEmpty(String? str) {
    return !isEmpty(str);
  }

  /// 检查[str]是否为null，空("")或仅包含空白字符。
  static bool isBlank(String? str) {
    return str == null || str.trim().isEmpty;
  }

  /// 检查[str]是否不为null，不为空("")，也不仅包含空白字符。
  static bool isNotBlank(String? str) {
    return !isBlank(str);
  }

  /// 截取[str]从[start]（包含）到[end]（排除）的部分。
  /// 当[start]和[end]参数值超出有效范围时会被自动纠正。
  static String trySubstring(String str, int start, [int? end]) {
    start = min(start, str.length);
    if (end != null) {
      end = min(end, str.length);
      if (end < start) {
        end = null;
      }
    }
    return str.substring(start, end);
  }

  StringHelper._();
}
