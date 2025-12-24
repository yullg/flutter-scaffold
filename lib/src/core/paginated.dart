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

  void add(T item) {
    _items.add(item);
    notifyListeners();
  }

  void addAll(Iterable<T> items) {
    _items.addAll(items);
    notifyListeners();
  }

  void insert(int index, T item) {
    _items.insert(index, item);
    notifyListeners();
  }

  void insertAll(int index, Iterable<T> items) {
    _items.insertAll(index, items);
    notifyListeners();
  }

  void remove(T item) {
    _items.remove(item);
    notifyListeners();
  }

  void removeWhere(bool Function(T item) test) {
    _items.removeWhere(test);
    notifyListeners();
  }

  void replaceAll(Iterable<T> items) {
    _items.clear();
    _items.addAll(items);
    notifyListeners();
  }

  void replaceFirstWhere(bool Function(T item) test, T item) {
    bool hasReplaced = false;
    for (int index = 0, length = _items.length; index < length; index++) {
      if (test(_items[index])) {
        _items.removeAt(index);
        _items.insert(index, item);
        hasReplaced = true;
        break;
      }
    }
    if (hasReplaced) {
      notifyListeners();
    }
  }

  void replaceAllWhere(bool Function(T item) test, T item) {
    bool hasReplaced = false;
    for (int index = 0, length = _items.length; index < length; index++) {
      if (test(_items[index])) {
        _items.removeAt(index);
        _items.insert(index, item);
        hasReplaced = true;
      }
    }
    if (hasReplaced) {
      notifyListeners();
    }
  }

  void mutateItems(bool Function(List<T> items) action) {
    if (action(_items)) {
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
