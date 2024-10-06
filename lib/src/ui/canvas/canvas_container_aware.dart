import 'dart:async';
import 'dart:ui';

import 'package:meta/meta.dart';

mixin CanvasContainerAware {
  Size? _containerSize;
  Size? _containerChildSize;
  Completer<void> _attachedCompleter = Completer<void>();

  Size? get containerSize => _containerSize;

  Size get requiredContainerSize =>
      containerSize ??
      (throw StateError("Not attached to CanvasContainer yet"));

  Size? get containerChildSize => _containerChildSize;

  Size get requiredContainerChildSize =>
      containerChildSize ??
      (throw StateError("Not attached to CanvasContainer yet"));

  bool get isAttached => _attachedCompleter.isCompleted;

  Future<void> waitAttached() => _attachedCompleter.future;

  Rect? get containerChildRect {
    final parentSize = containerSize;
    final childSize = containerChildSize;
    if (parentSize != null && childSize != null) {
      return Rect.fromLTWH(
        (parentSize.width - childSize.width) / 2,
        (parentSize.height - childSize.height) / 2,
        childSize.width,
        childSize.height,
      );
    }
    return null;
  }

  Rect get requiredContainerChildRect =>
      containerChildRect ??
      (throw StateError("Not attached to CanvasContainer yet"));

  Offset calculateContainerChildOffset(Offset containerOffset) {
    return containerOffset - requiredContainerChildRect.topLeft;
  }

  @internal
  void attach({
    required Size containerSize,
    required Size containerChildSize,
  }) {
    _containerSize = containerSize;
    _containerChildSize = containerChildSize;
    if (!_attachedCompleter.isCompleted) {
      _attachedCompleter.complete();
    }
  }

  @internal
  void detach() {
    _containerSize = null;
    _containerChildSize = null;
    if (_attachedCompleter.isCompleted) {
      _attachedCompleter = Completer<void>();
    }
  }
}
