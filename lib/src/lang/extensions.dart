import 'package:flutter/material.dart';

extension ExtensionLet<T> on T {
  R let<R>(R Function(T it) block) => block(this);
}

extension ExtensionAlso<T> on T {
  void also(void Function(T it) block) => block(this);
}

extension ExtensionTakeIf<T> on T {
  T? takeIf(bool Function(T value) predicate) => predicate(this) ? this : null;
}

extension ExtensionTakeUnless<T> on T {
  T? takeUnless(bool Function(T value) predicate) => predicate(this) ? null : this;
}

extension ExtensionFuture<T> on Future<T> {
  Future<void> asyncIgnore() => then<void>(_ignore, onError: _ignore);

  Future<T?> catchErrorToNull([void Function(Object e, StackTrace s)? onError]) => then<T?>(
    (value) => value,
    onError: (e, s) {
      onError?.call(e, s);
      return null;
    },
  );

  static void _ignore(Object? _, [Object? __]) {}
}

extension ExtensionWidget on Widget {
  Route<T> route<T>({
    RouteSettings? settings,
    bool? requestFocus,
    bool maintainState = true,
    bool fullscreenDialog = false,
    bool allowSnapshotting = true,
    bool barrierDismissible = false,
    TraversalEdgeBehavior? traversalEdgeBehavior,
    TraversalEdgeBehavior? directionalTraversalEdgeBehavior,
  }) => MaterialPageRoute<T>(
    builder: (context) => this,
    settings: settings,
    requestFocus: requestFocus,
    maintainState: maintainState,
    fullscreenDialog: fullscreenDialog,
    allowSnapshotting: allowSnapshotting,
    barrierDismissible: barrierDismissible,
    traversalEdgeBehavior: traversalEdgeBehavior,
    directionalTraversalEdgeBehavior: directionalTraversalEdgeBehavior,
  );
}
