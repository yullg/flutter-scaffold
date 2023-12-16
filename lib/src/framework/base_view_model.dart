import 'package:async/async.dart';
import 'package:flutter/widgets.dart';

import 'base_state.dart';

class BaseViewModel<T extends StatefulWidget> {
  final BaseState<T, BaseViewModel<T>> _state;

  const BaseViewModel(this._state);

  BuildContext get context => _state.context;

  bool get mounted => _state.mounted;

  T get widget => _state.widget;

  ResultFuture<void> get asyncInitializeFuture => _state.asyncInitializeFuture;

  @mustCallSuper
  void initialize() {}

  @mustCallSuper
  Future<void> asyncInitialize() async {}

  @mustCallSuper
  void destroy() {}
}
