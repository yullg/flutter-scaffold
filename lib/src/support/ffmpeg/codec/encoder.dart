/// See Also: https://www.ffmpeg.org/ffmpeg-codecs.html
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EncoderImpl &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          options == other.options;

  @override
  int get hashCode => name.hashCode ^ options.hashCode;

  @override
  String toString() {
    return 'EncoderImpl{name: $name, options: $options}';
  }
}
