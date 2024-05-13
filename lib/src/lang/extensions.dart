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
  T? takeUnless(bool Function(T value) predicate) => predicate(this) ? null : this;
}

extension ExtensionList<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  T? lastWhereOrNull(bool Function(T element) test) {
    for (int i = length - 1; i >= 0; i--) {
      if (test(this[i])) {
        return this[i];
      }
    }
    return null;
  }

  void sortedBy<R extends Comparable<R>>(R Function(T element) selector) {
    sort((a, b) => Comparable.compare(selector(a), selector(b)));
  }

  void sortedByDescending<R extends Comparable<R>>(R Function(T element) selector) {
    sort((a, b) => Comparable.compare(selector(b), selector(a)));
  }
}
