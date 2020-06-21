class StringHelper {
  /// 空字符
  static const String EMPTY_STRING = "";

  /// 半角空格
  static const String EN_SPACE_STRING = "\u0020";

  /// 全角空格
  static const String EM_SPACE_STRING = "\u3000";

  static bool hasLength(String? str) {
    return (str != null && str.isNotEmpty);
  }

  static bool hasText(String? str) {
    return (str != null && str.trim().isNotEmpty);
  }

  StringHelper._();
}
