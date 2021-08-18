import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/scaffold_logger.dart';

class GrowableListView<T> extends StatelessWidget {
  final GrowableListController<T> controller;
  final ValueWidgetBuilder<T> dataWidgetBuilder;
  final IndexedWidgetBuilder? separatorWidgetBuilder;

  GrowableListView({Key? key, required this.controller, required this.dataWidgetBuilder, this.separatorWidgetBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GrowableListController<T>>(
      init: controller,
      builder: (controller) {
        if (separatorWidgetBuilder != null) {
          return ScrollablePositionedList.separated(
            physics: AlwaysScrollableScrollPhysics(),
            itemScrollController: controller._scrollController,
            itemPositionsListener: controller._itemPositionsListener,
            itemCount: controller._datas.length + 1,
            itemBuilder: (context, index) {
              if (index < controller._datas.length) {
                return dataWidgetBuilder(context, controller._datas[index], null);
              } else {
                return SizedBox.shrink();
              }
            },
            separatorBuilder: (context, index) {
              if (index < controller._datas.length - 1) {
                return separatorWidgetBuilder!(context, index);
              } else {
                return SizedBox.shrink();
              }
            },
          );
        } else {
          return ScrollablePositionedList.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemScrollController: controller._scrollController,
            itemPositionsListener: controller._itemPositionsListener,
            itemCount: controller._datas.length + 1,
            itemBuilder: (context, index) {
              if (index < controller._datas.length) {
                return dataWidgetBuilder(context, controller._datas[index], null);
              } else {
                return SizedBox.shrink();
              }
            },
          );
        }
      },
    );
  }
}

class GrowableListController<T> extends GetxController {
  final int maxDataSize;
  final _scrollController = ItemScrollController();
  final _itemPositionsListener = ItemPositionsListener.create();
  final _datas = <T>[];

  GrowableListController({this.maxDataSize = -1});

  void addData(T data) {
    if (maxDataSize == 0) {
      _datas.clear();
    } else if (maxDataSize > 0) {
      if (_datas.length >= maxDataSize) {
        _datas.removeRange(0, (maxDataSize + 1) ~/ 2);
      }
    }
    _datas.add(data);
    update();
    if (_itemPositionsListener.itemPositions.value.any((element) => element.index == _datas.length - 2)) {
      scrollToEnd();
    }
  }

  void scrollToEnd() {
    Future.delayed(Duration(milliseconds: 100),
        () => _scrollController.scrollTo(index: _datas.length + 1, duration: Duration(milliseconds: 200), alignment: 1)).catchError((e, s) {
      ScaffoldLogger.warn("GrowableListView >>> scrollToEnd() error", e, s);
    });
  }
}
