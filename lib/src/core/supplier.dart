abstract interface class Supplier<P, R> {
  R get(P p);
}

class FunctionSupplier<P, R> implements Supplier<P, R> {
  final R Function(P) _getter;

  const FunctionSupplier(this._getter);

  @override
  R get(P p) => _getter(p);
}

class ValueSupplier<P, R> implements Supplier<P, R> {
  final R _value;

  const ValueSupplier(this._value);

  @override
  R get(P p) => _value;
}
