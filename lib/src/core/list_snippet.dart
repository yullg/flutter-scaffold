class ListSnippet<T> {
  final int total;
  final List<T> list;

  ListSnippet({required this.total, required this.list});

  @override
  String toString() {
    return 'ListSnippet{total: $total, list: $list}';
  }
}
