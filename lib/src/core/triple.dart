class Triple<A, B, C> {
  final A first;
  final B second;
  final C third;

  Triple(this.first, this.second, this.third);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Triple &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second &&
          third == other.third;

  @override
  int get hashCode => first.hashCode ^ second.hashCode ^ third.hashCode;

  @override
  String toString() {
    return 'Triple{first: $first, second: $second, third: $third}';
  }
}
