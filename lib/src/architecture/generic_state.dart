import 'package:flutter/widgets.dart';

import '../ui/popup/loading_dialog.dart';

abstract class GenericState<T extends StatefulWidget> extends State<T> {
  late final LoadingDialog defaultLoadingDialog;

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    defaultLoadingDialog = LoadingDialog();
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    try {
      defaultLoadingDialog.dispose();
    } finally {
      super.dispose();
    }
  }

  @protected
  void setStateIfMounted() {
    // 有意移除了传递给setState()的回调方法来避免产生歧义。
    if (mounted) {
      setState(() {});
    }
  }
}
