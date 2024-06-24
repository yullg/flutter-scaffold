import 'dart:async';

import 'package:flutter/widgets.dart';

enum PagedControllerStatus { idle, loading, finished, failed }

abstract class PagedController<T> extends ChangeNotifier {
  final List<T> _data;
  PagedControllerStatus _status;

  List<T> get data => _data; // 目前直接将内部集合传递给调用方是高效的且不会影响此类的功能。

  PagedControllerStatus get status => _status;

  PagedController({
    Iterable<T>? initialData,
    PagedControllerStatus? initialStatus,
  })  : _data = [...?initialData],
        _status = initialStatus ?? PagedControllerStatus.idle;

  /// 修改已加载的数据并通知监听器更新
  void changeData(void Function(List<T> data) block) {
    block(_data);
    notifyListeners();
  }

  void loadMoreData() {
    try {
      switch (_status) {
        case PagedControllerStatus.idle:
        case PagedControllerStatus.failed:
          _status = PagedControllerStatus.loading;
          notifyListeners();
          doLoadMoreData(_data.length).then((moreData) {
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
