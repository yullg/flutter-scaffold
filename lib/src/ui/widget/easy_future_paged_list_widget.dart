import 'package:base/base.dart';
import 'package:flutter/material.dart';

import '../../core/exceptions.dart';
import '../../core/list_snippet.dart';
import 'default_error_view.dart';
import 'easy_paged_list_widget.dart';

typedef _LoadMoreData<T> = Future<ListSnippet<T>> Function(int offset);

typedef _DataToWidget<T> = Widget Function(BuildContext context, int index, T data);

class EasyFuturePagedListWidget<T> extends StatelessWidget {
  final _LoadMoreData<T> loadMoreData;
  final _DataToWidget<T> dataToWidget;
  final IndexedWidgetBuilder? separatorBuilder;
  final EdgeInsetsGeometry? padding;

  EasyFuturePagedListWidget({Key? key, required this.loadMoreData, required this.dataToWidget, this.separatorBuilder, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) => RebuildWidget(
        builder: (context, notification, child) {
          if (notification is _EasyRebuildNotification<T>) {
            return FutureWidget.future(
              key: ObjectKey(notification),
              future: notification.future,
              valueWidgetBuilder: _valueWidgetBuilder,
              failedWidgetBuilder: _defaultFailedWidgetBuilder,
            );
          } else {
            return FutureWidget<PagedListControllerAttribute<T>>(
              key: ObjectKey(notification),
              asyncValueGetter: () async {
                ListSnippet<T> listSnippet = await loadMoreData(0);
                if (listSnippet.list.isEmpty) return null;
                return PagedListControllerAttribute(listSnippet.list);
              },
              valueWidgetBuilder: _valueWidgetBuilder,
              failedWidgetBuilder: _defaultFailedWidgetBuilder,
            );
          }
        },
      );

  Widget _valueWidgetBuilder(BuildContext context, PagedListControllerAttribute<T> value, child) => RefreshIndicator(
        onRefresh: () async {
          try {
            ListSnippet<T> listSnippet = await loadMoreData(0);
            if (listSnippet.list.isEmpty) {
              _EasyRebuildNotification(Future.value(null)).dispatch(context);
            } else {
              _EasyRebuildNotification(Future.value(PagedListControllerAttribute(listSnippet.list))).dispatch(context);
            }
          } catch (e) {
            showException(e, defaultMessage: "刷新失败 请稍后重试");
          }
        },
        child: EasyPagedListWidget<T>(
            controllerAttribute: value, loadMoreData: loadMoreData, dataToWidget: dataToWidget, separatorBuilder: separatorBuilder, padding: padding),
      );
}

class _EasyRebuildNotification<T> extends RebuildNotification {
  Future<PagedListControllerAttribute<T>?> future;

  _EasyRebuildNotification(this.future);
}

Widget _defaultFailedWidgetBuilder(BuildContext context, Object error, Widget? child) => DefaultErrorView(
      title: extractMessage(error) ?? "加载失败 请刷新重试",
      buttonText: "刷新",
      onButtonPressed: () => RebuildNotification().dispatch(context),
    );
