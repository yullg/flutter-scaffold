import 'package:flutter/foundation.dart';

class PaginatedData<T> extends ChangeNotifier {
  final List<T> _items;
  bool _hasMore;

  PaginatedData({required Iterable<T> items, required bool hasMore}) : _items = List.of(items), _hasMore = hasMore;

  int get length => _items.length;

  Iterable<T> get items => _items;

  bool get hasMore => _hasMore;

  set hasMore(bool value) {
    if (_hasMore != value) {
      _hasMore = value;
      notifyListeners();
    }
  }

  void add(T item, {bool? hasMore}) {
    _items.add(item);
    if (hasMore != null) {
      _hasMore = hasMore;
    }
    notifyListeners();
  }

  void addAll(Iterable<T> items, {bool? hasMore}) {
    _items.addAll(items);
    if (hasMore != null) {
      _hasMore = hasMore;
    }
    notifyListeners();
  }

  void insert(int index, T item, {bool? hasMore}) {
    _items.insert(index, item);
    if (hasMore != null) {
      _hasMore = hasMore;
    }
    notifyListeners();
  }

  void insertAll(int index, Iterable<T> items, {bool? hasMore}) {
    _items.insertAll(index, items);
    if (hasMore != null) {
      _hasMore = hasMore;
    }
    notifyListeners();
  }

  void remove(T item, {bool? hasMore}) {
    _items.remove(item);
    if (hasMore != null) {
      _hasMore = hasMore;
    }
    notifyListeners();
  }

  void removeWhere(bool Function(T item) test, {bool? hasMore}) {
    _items.removeWhere(test);
    if (hasMore != null) {
      _hasMore = hasMore;
    }
    notifyListeners();
  }

  void replaceAll(Iterable<T> items, {bool? hasMore}) {
    _items.clear();
    _items.addAll(items);
    if (hasMore != null) {
      _hasMore = hasMore;
    }
    notifyListeners();
  }

  void replaceFirstWhere(bool Function(T item) test, T item, {bool? hasMore}) {
    bool hasUpdated = false;
    for (int index = 0, length = _items.length; index < length; index++) {
      if (test(_items[index])) {
        _items.removeAt(index);
        _items.insert(index, item);
        hasUpdated = true;
        break;
      }
    }
    if (hasMore != null && _hasMore != hasMore) {
      _hasMore = hasMore;
      hasUpdated = true;
    }
    if (hasUpdated) {
      notifyListeners();
    }
  }

  void replaceAllWhere(bool Function(T item) test, T item, {bool? hasMore}) {
    bool hasUpdated = false;
    for (int index = 0, length = _items.length; index < length; index++) {
      if (test(_items[index])) {
        _items.removeAt(index);
        _items.insert(index, item);
        hasUpdated = true;
      }
    }
    if (hasMore != null && _hasMore != hasMore) {
      _hasMore = hasMore;
      hasUpdated = true;
    }
    if (hasUpdated) {
      notifyListeners();
    }
  }

  void mutate(bool Function(List<T> items) action, {bool? hasMore}) {
    bool hasUpdated = action(_items);
    if (hasMore != null && _hasMore != hasMore) {
      _hasMore = hasMore;
      hasUpdated = true;
    }
    if (hasUpdated) {
      notifyListeners();
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginatedData &&
          runtimeType == other.runtimeType &&
          _items == other._items &&
          _hasMore == other._hasMore;

  @override
  int get hashCode => _items.hashCode ^ _hasMore.hashCode;

  @override
  String toString() {
    return 'PaginatedData{_items: $_items, _hasMore: $_hasMore}';
  }
}

mixin PaginatedMixin<T> {
  PaginatedData<T> get paginatedData;

  Future<void> refresh() async {
    final items = await fetch(0);
    paginatedData.replaceAll(items, hasMore: items.isNotEmpty);
  }

  Future<void> loadMore() async {
    final moreItems = await fetch(paginatedData.length);
    if (moreItems.isNotEmpty) {
      paginatedData.addAll(moreItems, hasMore: true);
    } else {
      paginatedData.hasMore = false;
    }
  }

  @protected
  Future<Iterable<T>> fetch(int offset);
}
