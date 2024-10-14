import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:meta/meta.dart';

import 'adjust_boundary_extension.dart';
import 'canvas_container_controller_extensions.dart';
import 'canvas_container_extension.dart';
import 'drawing_board_extension.dart';

class CanvasContainerController extends ChangeNotifier
    implements CanvasContainerControllerExtensions {
  @override
  late final CanvasContainerExtension canvasContainerExtension;
  @override
  late final DrawingBoardExtension drawingBoardExtension;
  @override
  late final AdjustBoundaryExtension adjustBoundaryExtension;

  CanvasContainerController({
    CanvasContainerExtensionOption canvasContainerExtensionOption =
        const CanvasContainerExtensionOption(),
    AdjustBoundaryExtensionOption adjustBoundaryExtensionOption =
        const AdjustBoundaryExtensionOption(),
  }) {
    canvasContainerExtension = CanvasContainerExtension(
      extensions: this,
      option: canvasContainerExtensionOption,
    );
    drawingBoardExtension = DrawingBoardExtension(
      extensions: this,
    );
    adjustBoundaryExtension = AdjustBoundaryExtension(
      extensions: this,
      option: adjustBoundaryExtensionOption,
    );
  }

  Completer<void> _attachedCompleter = Completer<void>();

  bool get isAttached => _attachedCompleter.isCompleted;

  Future<void> waitAttached() => _attachedCompleter.future;

  @internal
  void attach({
    required Size containerSize,
    required Size containerChildSize,
  }) {
    canvasContainerExtension.attach(
        containerSize: containerSize, containerChildSize: containerChildSize);
    adjustBoundaryExtension.attach();
    if (!_attachedCompleter.isCompleted) {
      _attachedCompleter.complete();
    }
  }

  @internal
  void detach() {
    canvasContainerExtension.detach();
    if (_attachedCompleter.isCompleted) {
      _attachedCompleter = Completer<void>();
    }
  }

  // ---------- 绘画功能 ----------

  bool _drawingBoardEnabled = false;

  bool get drawingBoardEnabled => _drawingBoardEnabled;

  set drawingBoardEnabled(bool value) {
    if (_drawingBoardEnabled != value) {
      _drawingBoardEnabled = value;
      notifyListeners();
    }
  }

  // ---------- 剪切功能 ----------
  bool _adjustBoundaryEnabled = false;

  bool get adjustBoundaryEnabled => _adjustBoundaryEnabled;

  set adjustBoundaryEnabled(bool value) {
    if (_adjustBoundaryEnabled != value) {
      _adjustBoundaryEnabled = value;
      notifyListeners();
    }
  }

  // ----------手势事件----------

  @internal
  void onContainerScaleStart(ScaleStartDetails details) {
    canvasContainerExtension.onScaleStart(details);
  }

  @internal
  void onContainerScaleUpdate(ScaleUpdateDetails details) {
    canvasContainerExtension.onScaleUpdate(details);
  }

  @internal
  void onContainerScaleEnd(ScaleEndDetails details) {
    canvasContainerExtension.onScaleEnd(details);
  }

  @internal
  void onChildPointerDown(PointerDownEvent event) {
    if (drawingBoardEnabled) {
      drawingBoardExtension.onPointerDown(event);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onPointerDown(event);
    }
  }

  @internal
  void onChildPointerMove(PointerMoveEvent event) {
    if (drawingBoardEnabled) {
      drawingBoardExtension.onPointerMove(event);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onPointerMove(event);
    }
  }

  @internal
  void onChildPointerUp(PointerUpEvent event) {
    if (drawingBoardEnabled) {
      drawingBoardExtension.onPointerUp(event);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onPointerUpByChild(event);
    }
  }

  @internal
  void onChildPointerCancel(PointerCancelEvent event) {
    if (drawingBoardEnabled) {
      drawingBoardExtension.onPointerCancel(event);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onPointerCancelByChild(event);
    }
  }

  // ----------销毁----------

  @override
  void dispose() {
    if (!_attachedCompleter.isCompleted) {
      _attachedCompleter
          .completeError(StateError("Controller has been disposed"));
    }
    canvasContainerExtension.dispose();
    drawingBoardExtension.dispose();
    adjustBoundaryExtension.dispose();
    super.dispose();
  }
}
