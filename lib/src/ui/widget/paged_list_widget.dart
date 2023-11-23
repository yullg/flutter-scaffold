import 'package:flutter/widgets.dart';

class PagedListWidget<T> extends StatelessWidget {
  final PagedListController<T> controller;
  final Widget Function(BuildContext, int, T) dataWidgetBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final WidgetBuilder? loadingWidgetBuilder;
  final WidgetBuilder? noneWidgetBuilder;
  final WidgetBuilder? finishedWidgetBuilder;
  final WidgetBuilder? failedWidgetBuilder;

  const PagedListWidget({
    super.key,
    required this.controller,
    required this.dataWidgetBuilder,
    this.separatorBuilder,
    this.loadingWidgetBuilder,
    this.noneWidgetBuilder,
    this.finishedWidgetBuilder,
    this.failedWidgetBuilder,
  });

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: controller,
        builder: (context, child) => ListView.separated(
          itemCount: controller._dataList.length + 1,
          itemBuilder: (context, index) {
            return controller._itemBuilder(
              context,
              index,
              dataWidgetBuilder: dataWidgetBuilder,
              loadingWidgetBuilder: loadingWidgetBuilder,
              noneWidgetBuilder: noneWidgetBuilder,
              finishedWidgetBuilder: finishedWidgetBuilder,
              failedWidgetBuilder: failedWidgetBuilder,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return separatorBuilder?.call(context, index) ?? const SizedBox.shrink();
          },
        ),
      );
}

class PagedSliverListWidget<T> extends StatelessWidget {
  final PagedListController<T> controller;
  final Widget Function(BuildContext, int, T) dataWidgetBuilder;
  final NullableIndexedWidgetBuilder? separatorBuilder;
  final WidgetBuilder? loadingWidgetBuilder;
  final WidgetBuilder? noneWidgetBuilder;
  final WidgetBuilder? finishedWidgetBuilder;
  final WidgetBuilder? failedWidgetBuilder;

  const PagedSliverListWidget({
    super.key,
    required this.controller,
    required this.dataWidgetBuilder,
    this.separatorBuilder,
    this.loadingWidgetBuilder,
    this.noneWidgetBuilder,
    this.finishedWidgetBuilder,
    this.failedWidgetBuilder,
  });

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: controller,
        builder: (context, child) => SliverList.separated(
          itemCount: controller._dataList.length + 1,
          itemBuilder: (context, index) {
            return controller._itemBuilder(
              context,
              index,
              dataWidgetBuilder: dataWidgetBuilder,
              loadingWidgetBuilder: loadingWidgetBuilder,
              noneWidgetBuilder: noneWidgetBuilder,
              finishedWidgetBuilder: finishedWidgetBuilder,
              failedWidgetBuilder: failedWidgetBuilder,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return separatorBuilder?.call(context, index);
          },
        ),
      );
}

enum PagedListControllerStatus { idle, loading, finished, failed }

abstract class PagedListController<T> extends ChangeNotifier {
  final List<T> _dataList;
  PagedListControllerStatus _status;

  PagedListController({
    Iterable<T>? data,
    PagedListControllerStatus? status,
  })  : _dataList = [...?data],
        _status = status ?? PagedListControllerStatus.idle;

  Widget? _itemBuilder(
    BuildContext context,
    int index, {
    required Widget Function(BuildContext, int, T) dataWidgetBuilder,
    WidgetBuilder? loadingWidgetBuilder,
    WidgetBuilder? noneWidgetBuilder,
    WidgetBuilder? finishedWidgetBuilder,
    WidgetBuilder? failedWidgetBuilder,
  }) {
    if (index < _dataList.length) {
      return dataWidgetBuilder(context, index, _dataList[index]);
    } else {
      switch (_status) {
        case PagedListControllerStatus.idle:
          _loadMoreData();
          return loadingWidgetBuilder?.call(context);
        case PagedListControllerStatus.loading:
          return loadingWidgetBuilder?.call(context);
        case PagedListControllerStatus.finished:
          if (_dataList.isEmpty) {
            return noneWidgetBuilder?.call(context);
          } else {
            return finishedWidgetBuilder?.call(context);
          }
        case PagedListControllerStatus.failed:
          return failedWidgetBuilder?.call(context);
      }
    }
  }

  Future<void> _loadMoreData() async {
    try {
      _status = PagedListControllerStatus.loading;
      final moreData = await loadMoreData(_dataList.length);
      if (moreData != null) {
        _dataList.addAll(moreData);
        _status = PagedListControllerStatus.idle;
      } else {
        _status = PagedListControllerStatus.finished;
      }
    } catch (e) {
      _status = PagedListControllerStatus.failed;
    } finally {
      notifyListeners();
    }
  }

  Future<List<T>?> loadMoreData(int offset);
}
