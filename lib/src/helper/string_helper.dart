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
    start = max(min(start, str.length), 0);
    if (end != null) {
      end = max(min(end, str.length), 0);
      if (end < start) {
        end = null;
      }
    }
    return str.substring(start, end);
  }

  /// 删除[str]两端的空白字符，如果删除后为空("")或[str]为null，则返回null。
  static String? trimToNull(String? str) {
    str = str?.trim();
    return str == null || str.isEmpty ? null : str;
  }

  StringHelper._();
}
