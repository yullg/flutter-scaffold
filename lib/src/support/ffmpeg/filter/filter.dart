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
}
