class ScopeFunction {
  static R let<T, R>(T obj, R Function(T it) block) => block(obj);

  static R? letIf<T, R>(T obj, bool Function(T value) predicate, R Function(T it) block) =>
      predicate(obj) ? block(obj) : null;

  static R? letUnless<T, R>(T obj, bool Function(T value) predicate, R Function(T it) block) =>
      predicate(obj) ? null : block(obj);

  static R? letIfNotNull<T, R>(T? obj, R Function(T it) block) => obj != null ? block(obj) : null;

  static void also<T>(T obj, void Function(T it) block) => block(obj);

  static T? takeIf<T>(T obj, bool Function(T value) predicate) => predicate(obj) ? obj : null;

  static T? takeUnless<T>(T obj, bool Function(T value) predicate) => predicate(obj) ? null : obj;

  ScopeFunction._();
}
