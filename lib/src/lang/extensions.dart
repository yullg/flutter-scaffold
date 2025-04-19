extension ExtensionLet<T> on T {
  R let<R>(R Function(T it) block) => block(this);
}

extension ExtensionAlso<T> on T {
  void also(void Function(T it) block) => block(this);
}

extension ExtensionTakeIf<T> on T {
  T? takeIf(bool Function(T value) predicate) => predicate(this) ? this : null;
}

extension ExtensionTakeUnless<T> on T {
  T? takeUnless(bool Function(T value) predicate) =>
      predicate(this) ? null : this;
}

extension ExtensionFuture<T> on Future<T> {
  Future<void> asyncIgnore() => then<void>(_ignore, onError: _ignore);

  Future<T?> catchErrorToNull() =>
      then<T?>((value) => value, onError: (_) => null);

  static void _ignore(Object? _, [Object? __]) {}
}
