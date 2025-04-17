import 'package:flutter/widgets.dart';

import '../paged_controller.dart';

class PagedListWidget<T> extends StatelessWidget {
  final PagedController<T> controller;
  final Widget Function(BuildContext context, int index, T data) builder;
  final IndexedWidgetBuilder? separatorBuilder;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? emptyBuilder;
  final WidgetBuilder? finishedBuilder;
  final WidgetBuilder? failedBuilder;
  final bool reverse;

  const PagedListWidget({
    super.key,
    required this.controller,
    required this.builder,
    this.separatorBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.finishedBuilder,
    this.failedBuilder,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: controller,
        builder: (context, child) => ListView.separated(
          reverse: reverse,
          itemCount: controller.data.length + 1,
          itemBuilder: (context, index) {
            if (index < controller.data.length) {
              return builder(context, index, controller.data[index]);
            } else {
              switch (controller.status) {
                case PagedControllerStatus.idle:
                  Future.microtask(() {
                    controller.loadMoreData();
                  });
                  return loadingBuilder?.call(context);
                case PagedControllerStatus.loading:
                  return loadingBuilder?.call(context);
                case PagedControllerStatus.finished:
                  if (controller.data.isEmpty) {
                    return emptyBuilder?.call(context);
                  } else {
                    return finishedBuilder?.call(context);
                  }
                case PagedControllerStatus.failed:
                  return failedBuilder?.call(context);
              }
            }
          },
          separatorBuilder: (BuildContext context, int index) {
            return separatorBuilder?.call(context, index) ??
                const SizedBox.shrink();
          },
        ),
      );
}

class PagedSliverListWidget<T> extends StatelessWidget {
  final PagedController<T> controller;
  final Widget Function(BuildContext context, int index, T data) builder;
  final NullableIndexedWidgetBuilder? separatorBuilder;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? emptyBuilder;
  final WidgetBuilder? finishedBuilder;
  final WidgetBuilder? failedWidgetBuilder;

  const PagedSliverListWidget({
    super.key,
    required this.controller,
    required this.builder,
    this.separatorBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.finishedBuilder,
    this.failedWidgetBuilder,
  });

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: controller,
        builder: (context, child) => SliverList.separated(
          itemCount: controller.data.length + 1,
          itemBuilder: (context, index) {
            if (index < controller.data.length) {
              return builder(context, index, controller.data[index]);
            } else {
              switch (controller.status) {
                case PagedControllerStatus.idle:
                  Future.microtask(() {
                    controller.loadMoreData();
                  });
                  return loadingBuilder?.call(context);
                case PagedControllerStatus.loading:
                  return loadingBuilder?.call(context);
                case PagedControllerStatus.finished:
                  if (controller.data.isEmpty) {
                    return emptyBuilder?.call(context);
                  } else {
                    return finishedBuilder?.call(context);
                  }
                case PagedControllerStatus.failed:
                  return failedWidgetBuilder?.call(context);
              }
            }
          },
          separatorBuilder: (BuildContext context, int index) {
            return separatorBuilder?.call(context, index);
          },
        ),
      );
}
