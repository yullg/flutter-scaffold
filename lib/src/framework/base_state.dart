import 'package:flutter/widgets.dart';

import 'base_presenter.dart';

abstract class BaseState<T extends StatefulWidget, P extends BasePresenter>
    extends State<T> {
  late final P presenter;

  P newPresenter();

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    presenter = newPresenter();
    presenter.initialize();
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    try {
      presenter.destroy();
    } finally {
      super.dispose();
    }
  }
}
