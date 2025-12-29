import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Route<T> route<T>({
    RouteSettings? settings,
    bool? requestFocus,
    bool maintainState = true,
    bool fullscreenDialog = false,
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
  }) => MaterialPageRoute<T>(
    builder: (context) => this,
    settings: settings,
    requestFocus: requestFocus,
    maintainState: maintainState,
    fullscreenDialog: fullscreenDialog,
    allowSnapshotting: allowSnapshotting,
    barrierDismissible: barrierDismissible,
  );
}
