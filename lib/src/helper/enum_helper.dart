class EnumHelper {
  static T fromString<T extends Enum>(Iterable<T> enumValues, String value) {
    return enumValues.firstWhere((element) => element.name == value);
  }

  static T fromInt<T extends Enum>(Iterable<T> enumValues, int value) {
    return enumValues.elementAt(value);
  }

  EnumHelper._();
}
