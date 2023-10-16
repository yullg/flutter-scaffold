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

  StringHelper._();
}
