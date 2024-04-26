class Pair<A, B> {
  final A first;
  final B second;

  Pair(this.first, this.second);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair && runtimeType == other.runtimeType && first == other.first && second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }
}
