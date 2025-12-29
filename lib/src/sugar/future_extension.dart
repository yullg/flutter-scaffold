extension FutureExtension<T> on Future<T> {
  Future<void> asyncIgnore() => then<void>(_ignore, onError: _ignore);

  Future<T?> catchErrorToNull([void Function(Object e, StackTrace s)? onError]) => then<T?>(
    (value) => value,
    onError: (e, s) {
      onError?.call(e, s);
      return null;
    },
  );

  static void _ignore(Object? _, [Object? __]) {}
}
