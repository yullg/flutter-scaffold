/// See Also: https://www.ffmpeg.org/ffmpeg-filters.html
abstract interface class Filter {
  String get name;

  String? get options;
}

final class FilterImpl implements Filter {
  @override
  final String name;
  @override
  final String? options;

  const FilterImpl(this.name, [this.options]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterImpl &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          options == other.options;

  @override
  int get hashCode => name.hashCode ^ options.hashCode;

  @override
  String toString() {
    return 'FilterImpl{name: $name, options: $options}';
  }
}
