extension ScopeFunctionsExtension<T> on T {
  R let<R>(R Function(T it) block) => block(this);

  void also(void Function(T it) block) => block(this);

  T? takeIf(bool Function(T value) predicate) => predicate(this) ? this : null;

  T? takeUnless(bool Function(T value) predicate) => predicate(this) ? null : this;
}
