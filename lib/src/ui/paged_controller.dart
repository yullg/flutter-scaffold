import 'dart:async';

import 'package:flutter/widgets.dart';

enum PagedControllerStatus { idle, loading, finished, failed }

abstract class PagedController<T> extends ChangeNotifier {
  int _resetId = 1;
  final List<T> _data;
  PagedControllerStatus _status;

  Iterable<T> get data => _data;

  PagedControllerStatus get status => _status;

  PagedController()
      : _data = <T>[],
        _status = PagedControllerStatus.idle;

  /// 修改已加载的数据并通知监听器更新
  void changeData(void Function(List<T> data) block) {
    block(_data);
    notifyListeners();
  }

  void reset() {
    _resetId++;
    _data.clear();
    _status = PagedControllerStatus.idle;
    notifyListeners();
  }

  void loadMoreData() {
    try {
      switch (_status) {
        case PagedControllerStatus.idle:
        case PagedControllerStatus.failed:
          _status = PagedControllerStatus.loading;
          notifyListeners();
          final resetId = _resetId;
          doLoadMoreData(_data.length).then((moreData) {
            if (resetId != _resetId) return;
            try {
              if (moreData != null) {
                _data.addAll(moreData);
                _status = PagedControllerStatus.idle;
              } else {
                _status = PagedControllerStatus.finished;
              }
              notifyListeners();
            } catch (e) {
              _status = PagedControllerStatus.failed;
              notifyListeners();
            }
          }, onError: (e) {
            if (resetId != _resetId) return;
            _status = PagedControllerStatus.failed;
            notifyListeners();
          });
        case PagedControllerStatus.loading:
        case PagedControllerStatus.finished:
          break;
      }
    } catch (e) {
      _status = PagedControllerStatus.failed;
      notifyListeners();
    }
  }

  /// 从给定的偏移量[offset]处开始加载数据，当没有更多数据时返回`null`。
  @protected
  Future<List<T>?> doLoadMoreData(int offset);

  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
  }
}

class DefaultPagedController<T> extends PagedController<T> {
  final Future<List<T>?> Function(int offset) doLoadMoreDataFunc;

  DefaultPagedController({required this.doLoadMoreDataFunc});

  @override
  Future<List<T>?> doLoadMoreData(int offset) => doLoadMoreDataFunc(offset);
}
