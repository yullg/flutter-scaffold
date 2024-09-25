import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:meta/meta.dart';

import 'adjust_boundary.dart';
import 'drawing_board.dart';

class CanvasContainerController extends ChangeNotifier {
  late final DrawingBoardExtension drawingBoardExtension;
  late final AdjustBoundaryExtension adjustBoundaryExtension;

  CanvasContainerController({
    DrawingBoardExtension? drawingBoardExtension,
    AdjustBoundaryExtension? adjustBoundaryExtension,
  }) {
    this.drawingBoardExtension =
        drawingBoardExtension ?? DrawingBoardExtension();
    this.adjustBoundaryExtension =
        adjustBoundaryExtension ?? AdjustBoundaryExtension();
  }

  /// 画板大小
  Size? _containerSize;

  Size? get containerSize => _containerSize;

  @internal
  set containerSize(Size? value) {
    if (_containerSize != value) {
      _containerSize = value;
      adjustBoundaryExtension.adjustBoundary(containerSize: value);
    }
  }

  /// 画板功能开关
  bool _drawingBoardEnabled = false;

  bool get drawingBoardEnabled => _drawingBoardEnabled;

  set drawingBoardEnabled(bool value) {
    if (_drawingBoardEnabled != value) {
      _drawingBoardEnabled = value;
      notifyListeners();
    }
  }

  /// 剪切功能开关
  bool _adjustBoundaryEnabled = false;

  bool get adjustBoundaryEnabled => _adjustBoundaryEnabled;

  set adjustBoundaryEnabled(bool value) {
    if (_adjustBoundaryEnabled != value) {
      _adjustBoundaryEnabled = value;
      notifyListeners();
    }
  }

  /// 旋转角度
  int? _rotation;

  int? get rotation => _rotation;

  set rotation(int? value) {
    if (_rotation != value) {
      if (value != null) {
        _rotation = value % 360;
      } else {
        _rotation = null;
      }
      notifyListeners();
    }
  }

  void rotate(int degree) {
    degree = degree % 360;
    if (degree != 0) {
      _rotation = ((_rotation ?? 0) + degree) % 360;
      notifyListeners();
    }
  }

  /// 缩放比例
  double? _scale;

  double? get scale => _scale;

  set scale(double? value) {
    if (_scale != value) {
      _scale = value;
      notifyListeners();
    }
  }

  // ----------手势事件----------

  @internal
  void onPanDown(DragDownDetails details) {
    if (drawingBoardEnabled) {
      drawingBoardExtension.onPanDown(details);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onPanDown(details.localPosition);
    }
  }

  @internal
  void onPanUpdate(DragUpdateDetails details) {
    if (drawingBoardEnabled) {
      drawingBoardExtension.onPanUpdate(details);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onPanUpdate(
        delta: details.delta,
        containerSize: containerSize,
      );
    }
  }

  @internal
  void onPanEnd(DragEndDetails details) {
    if (drawingBoardEnabled) {
      drawingBoardExtension.onPanEnd(containerSize: containerSize);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onPanEnd();
    }
  }

  @internal
  void onPanCancel() {
    if (drawingBoardEnabled) {
      drawingBoardExtension.onPanEnd(containerSize: containerSize);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onPanEnd();
    }
  }

  // ----------销毁----------

  @override
  void dispose() {
    drawingBoardExtension.dispose();
    adjustBoundaryExtension.dispose();
    super.dispose();
  }
}
