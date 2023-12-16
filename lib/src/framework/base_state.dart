import 'package:async/async.dart';
import 'package:flutter/widgets.dart';

import 'base_view_model.dart';

abstract class BaseState<T extends StatefulWidget, VM extends BaseViewModel<T>> extends State<T> {
  late final VM viewModel;
  late final ResultFuture<void> asyncInitializeFuture;

  VM newViewModel();

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    viewModel = newViewModel();
    viewModel.initialize();
    asyncInitializeFuture = ResultFuture<void>(viewModel.asyncInitialize());
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    try {
      viewModel.destroy();
    } finally {
      super.dispose();
    }
  }

  void setStateIfMounted([VoidCallback? fn]) {
    if (mounted) {
      setState(fn ?? () {});
    }
  }
}
