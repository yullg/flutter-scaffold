import 'package:flutter/widgets.dart';

class BaseViewModel<T extends StatefulWidget> {
  final State<T> _state;

  const BaseViewModel(this._state);

  BuildContext get context => _state.context;

  bool get mounted => _state.mounted;

  T get widget => _state.widget;

  @mustCallSuper
  void initialize() {}

  @mustCallSuper
  void destroy() {}
}
