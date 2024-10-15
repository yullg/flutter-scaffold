abstract interface class Encoder {
  String get name;

  Iterable<String>? get options;
}

final class EncoderImpl implements Encoder {
  @override
  final String name;
  @override
  final Iterable<String>? options;

  const EncoderImpl(this.name, [this.options]);
}
