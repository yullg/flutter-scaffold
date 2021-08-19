import 'package:base/base.dart';
import 'package:flutter/material.dart';

import '../../core/list_snippet.dart';

typedef _LoadMoreData<T> = Future<ListSnippet<T>> Function(int offset);

typedef _DataToWidget<T> = Widget Function(BuildContext context, int index, T data);

class EasyPagedListWidget<T> extends StatelessWidget {
  final PagedListControllerAttribute<T>? controllerAttribute;
  final _LoadMoreData<T> loadMoreData;
  final _DataToWidget<T> dataToWidget;
  final IndexedWidgetBuilder? separatorBuilder;

  EasyPagedListWidget({Key? key, this.controllerAttribute, required this.loadMoreData, required this.dataToWidget, this.separatorBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) => PagedListWidget(
        controllerBuilder: () => _EasyPagedListController<T>(controllerAttribute, loadMoreData, dataToWidget, separatorBuilder),
      );
}

class EasyPagedSliverListWidget<T> extends StatelessWidget {
  final PagedListControllerAttribute<T>? controllerAttribute;
  final _LoadMoreData<T> loadMoreData;
  final _DataToWidget<T> dataToWidget;

  EasyPagedSliverListWidget({Key? key, this.controllerAttribute, required this.loadMoreData, required this.dataToWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) => PagedSliverListWidget(
        controllerBuilder: () => _EasyPagedListController<T>(controllerAttribute, loadMoreData, dataToWidget, null),
      );
}

class _EasyPagedListController<T> extends PagedListController<T> {
  final _LoadMoreData<T> loadMoreDataFunction;
  final _DataToWidget<T> dataToWidgetFunction;
  final IndexedWidgetBuilder? separatorBuilderFunction;

  _EasyPagedListController(
      PagedListControllerAttribute<T>? controllerAttribute, this.loadMoreDataFunction, this.dataToWidgetFunction, this.separatorBuilderFunction)
      : super(attribute: controllerAttribute);

  @override
  Widget dataToWidget(BuildContext context, int index, T data) => dataToWidgetFunction(context, index, data);

  @override
  Future<List<T>?> loadMoreData(int offset) async {
    ListSnippet<T> listSnippet = await loadMoreDataFunction(offset);
    return listSnippet.list.isNotEmpty ? listSnippet.list : null;
  }

  Widget separatorWidgetBuilder(BuildContext context, int index) {
    if (separatorBuilderFunction != null) {
      return separatorBuilderFunction!(context, index);
    } else {
      return super.separatorWidgetBuilder(context, index);
    }
  }
}
