import 'package:flutter/widgets.dart';

import 'base_view_model.dart';

abstract class BaseState<T extends StatefulWidget, VM extends BaseViewModel> extends State<T> {
  late final VM viewModel;

  VM newViewModel();

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    viewModel = newViewModel();
    viewModel.initialize();
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
