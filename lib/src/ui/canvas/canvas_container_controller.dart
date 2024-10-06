import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:meta/meta.dart';

import 'adjust_boundary.dart';
import 'canvas_container_aware.dart';
import 'drawing_board.dart';

class CanvasContainerController extends ChangeNotifier
    with CanvasContainerAware {
  late final DrawingBoardExtension drawingBoardExtension;
  late final AdjustBoundaryExtension adjustBoundaryExtension;

  CanvasContainerController({
    this.minScale = 0.3,
    this.maxScale = 3.0,
    bool scaleGestureEnabled = true,
    bool rotationGestureEnabled = true,
    bool translateGestureEnabled = true,
    DrawingBoardExtension? drawingBoardExtension,
    AdjustBoundaryExtension? adjustBoundaryExtension,
  })  : _scaleGestureEnabled = scaleGestureEnabled,
        _rotationGestureEnabled = rotationGestureEnabled,
        _translateGestureEnabled = translateGestureEnabled {
    this.drawingBoardExtension =
        drawingBoardExtension ?? DrawingBoardExtension();
    this.adjustBoundaryExtension =
        adjustBoundaryExtension ?? AdjustBoundaryExtension();
  }

  @internal
  void dispatchAttach({
    required Size containerSize,
    required Size containerChildSize,
  }) {
    attach(
        containerSize: containerSize, containerChildSize: containerChildSize);
    drawingBoardExtension.attach(
        containerSize: containerSize, containerChildSize: containerChildSize);
    adjustBoundaryExtension.attach(
        containerSize: containerSize, containerChildSize: containerChildSize);
  }

  @internal
  void dispatchDetach() {
    detach();
    drawingBoardExtension.detach();
    adjustBoundaryExtension.detach();
  }

  // ---------- 缩放 ----------

  final double? minScale;
  final double? maxScale;

  double? _scale;

  bool _scaleGestureEnabled;

  double? get scale => _scale;

  bool get scaleGestureEnabled => _scaleGestureEnabled;

  set scale(double? value) {
    if (value != null) {
      if (minScale != null) {
        value = max(minScale!, value);
      }
      if (maxScale != null) {
        value = min(maxScale!, value);
      }
    }
    if (_scale != value) {
      _scale = value;
      translate = translate;
      notifyListeners();
    }
  }

  set scaleGestureEnabled(bool value) {
    if (_scaleGestureEnabled != value) {
      _scaleGestureEnabled = value;
      notifyListeners();
    }
  }

  // ---------- 旋转 ----------

  int? _rotation;

  bool _rotationGestureEnabled;

  int? get rotation => _rotation;

  bool get rotationGestureEnabled => _rotationGestureEnabled;

  set rotation(int? value) {
    if (value != null) {
      value = value % 360;
    }
    if (_rotation != value) {
      _rotation = value;
      translate = translate;
      notifyListeners();
    }
  }

  void rotate(int value) {
    rotation = (rotation ?? 0) + value % 360;
  }

  set rotationGestureEnabled(bool value) {
    if (_rotationGestureEnabled != value) {
      _rotationGestureEnabled = value;
      notifyListeners();
    }
  }

  // ---------- 平移 ----------

  Offset? _translate;

  bool _translateGestureEnabled;

  Offset? get translate => _translate;

  bool get translateGestureEnabled => _translateGestureEnabled;

  set translate(Offset? value) {
    value = _clampTranslate(value);
    if (_translate != value) {
      _translate = value;
      notifyListeners();
    }
  }

  set translateGestureEnabled(bool value) {
    if (_translateGestureEnabled != value) {
      _translateGestureEnabled = value;
      notifyListeners();
    }
  }

  Offset? _clampTranslate(Offset? offset) {
    if (offset == null) {
      return offset;
    }
    final containerSize = requiredContainerSize;
    final containerChildSize = requiredContainerChildSize;
    double childWidth = containerChildSize.width;
    double childHeight = containerChildSize.height;
    final rotation = this.rotation;
    if (rotation != null && rotation != 0) {
      final rotationAngle = rotation * (pi / 180);
      childWidth = (containerChildSize.width * cos(rotationAngle)).abs() +
          (containerChildSize.height * sin(rotationAngle)).abs();
      childHeight = (containerChildSize.height * cos(rotationAngle)).abs() +
          (containerChildSize.width * sin(rotationAngle)).abs();
    }
    final scale = this.scale;
    if (scale != null) {
      childWidth = childWidth * scale;
      childHeight = childHeight * scale;
    }
    final maxTranslateX = ((containerSize.width - childWidth) / 2).abs();
    final minTranslateX = -maxTranslateX;
    final maxTranslateY = ((containerSize.height - childHeight) / 2).abs();
    final minTranslateY = -maxTranslateY;
    return Offset(max(minTranslateX, min(maxTranslateX, offset.dx)),
        max(minTranslateY, min(maxTranslateY, offset.dy)));
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

  // ----------Widget事件----------

  double? _previousScale;
  int? _previousRotation;

  @internal
  void onScaleStartByContainer(ScaleStartDetails details) {
    if (scaleGestureEnabled && details.pointerCount >= 2) {
      _previousScale = scale;
    }
    if (rotationGestureEnabled && details.pointerCount >= 2) {
      _previousRotation = rotation;
    }
  }

  @internal
  void onScaleUpdateByContainer(ScaleUpdateDetails details) {
    if (scaleGestureEnabled && details.pointerCount >= 2) {
      scale = (_previousScale ?? 1.0) * details.scale;
    }
    if (rotationGestureEnabled && details.pointerCount >= 2) {
      rotation =
          (_previousRotation ?? 0) + (details.rotation * (180 / pi)).toInt();
    }
    if (translateGestureEnabled && details.pointerCount >= 2) {
      translate = (translate ?? Offset.zero) + details.focalPointDelta;
    }
  }

  @internal
  void onScaleEndByContainer(ScaleEndDetails details) {
    _previousScale = null;
    _previousRotation = null;
  }

  @internal
  void onPointerDownByChild(PointerDownEvent event) {
    if (drawingBoardEnabled) {
      drawingBoardExtension.onPointerDownByChild(event);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onPointerDownByChild(event);
    }
  }

  @internal
  void onPointerMoveByChild(PointerMoveEvent event) {
    if (drawingBoardEnabled) {
      drawingBoardExtension.onPointerMoveByChild(event);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onPointerMoveByChild(event);
    }
  }

  @internal
  void onPointerUpByChild(PointerUpEvent event) {
    if (drawingBoardEnabled) {
      drawingBoardExtension.onPointerUpByChild(event);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onPointerUpByChild(event);
    }
  }

  @internal
  void onPointerCancelByChild(PointerCancelEvent event) {
    if (drawingBoardEnabled) {
      drawingBoardExtension.onPointerCancelByChild(event);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onPointerCancelByChild(event);
    }
  }

  // ----------销毁----------

  @override
  void dispose() {
    dispatchDetach();
    drawingBoardExtension.dispose();
    adjustBoundaryExtension.dispose();
    super.dispose();
  }
}
