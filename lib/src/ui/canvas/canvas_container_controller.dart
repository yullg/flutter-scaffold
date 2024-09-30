import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:meta/meta.dart';
import 'package:scaffold/scaffold_lang.dart';

import 'adjust_boundary.dart';
import 'drawing_board.dart';

class CanvasContainerController extends ChangeNotifier {
  late final DrawingBoardExtension drawingBoardExtension;
  late final AdjustBoundaryExtension adjustBoundaryExtension;

  final double? minScale;
  final double? maxScale;

  int? _rotation;
  Offset? _translate;
  double? _scale = 1.0;
  bool _translateGestureEnabled;
  bool _scaleGestureEnabled;

  CanvasContainerController({
    this.minScale = 0.3,
    this.maxScale = 3.0,
    bool translateGestureEnabled = true,
    bool scaleGestureEnabled = true,
    DrawingBoardExtension? drawingBoardExtension,
    AdjustBoundaryExtension? adjustBoundaryExtension,
  })  : _translateGestureEnabled = translateGestureEnabled,
        _scaleGestureEnabled = scaleGestureEnabled {
    this.drawingBoardExtension =
        drawingBoardExtension ?? DrawingBoardExtension();
    this.adjustBoundaryExtension =
        adjustBoundaryExtension ?? AdjustBoundaryExtension();
  }

  /// 画板大小
  Size? _containerSize;

  Size? get containerSize => _containerSize;

  final _initializedCompleter = Completer<void>();

  Future<void> get initializedFuture => _initializedCompleter.future;

  @internal
  void initialize({required Size containerSize}) {
    _containerSize = containerSize;
    drawingBoardExtension.containerSize = containerSize;
    adjustBoundaryExtension.containerSize = containerSize;
    if (!_initializedCompleter.isCompleted) {
      _initializedCompleter.complete();
    }
  }

  // ---------- 旋转 ----------

  int? get rotation => _rotation;

  set rotation(int? value) {
    if (_rotation != value) {
      if (value != null) {
        _rotation = value % 360;
      } else {
        _rotation = null;
      }
      translate?.also((it) {
        _translate = _adjustTranslate(it);
      });
      notifyListeners();
    }
  }

  void rotate(int degree) {
    degree = degree % 360;
    if (degree != 0) {
      _rotation = ((_rotation ?? 0) + degree) % 360;
      translate?.also((it) {
        _translate = _adjustTranslate(it);
      });
      notifyListeners();
    }
  }

  // ---------- 平移 ----------

  Offset? get translate => _translate;

  bool get translateGestureEnabled => _translateGestureEnabled;

  set translate(Offset? value) {
    if (_translate != value) {
      if (value != null) {
        _translate = _adjustTranslate(value);
      } else {
        _translate = null;
      }
      notifyListeners();
    }
  }

  set translateGestureEnabled(bool value) {
    if (_translateGestureEnabled != value) {
      _translateGestureEnabled = value;
      notifyListeners();
    }
  }

  Offset _adjustTranslate(Offset offset) {
    final containerSize = this.containerSize;
    if (containerSize != null && containerSize.isFinite) {
      final width = containerSize.width;
      final height = containerSize.height;
      double rotatedWidth = width;
      double rotatedHeight = height;
      final rotation = this.rotation;
      if (rotation != null && rotation.isFinite) {
        final rotationAngle = rotation * (pi / 180);
        rotatedWidth = (width * cos(rotationAngle)).abs() +
            (height * sin(rotationAngle)).abs();
        rotatedHeight = (height * cos(rotationAngle)).abs() +
            (width * sin(rotationAngle)).abs();
      }
      final scaledWidth = rotatedWidth * (scale ?? 1);
      final scaledHeight = rotatedHeight * (scale ?? 1);
      final maxOffsetX = ((containerSize.width - scaledWidth) / 2).abs();
      final maxOffsetY = ((containerSize.height - scaledHeight) / 2).abs();
      return Offset(max(-maxOffsetX, min(maxOffsetX, offset.dx)),
          max(-maxOffsetY, min(maxOffsetY, offset.dy)));
    } else {
      return offset;
    }
  }

  // ---------- 缩放 ----------

  double? get scale => _scale;

  bool get scaleGestureEnabled => _scaleGestureEnabled;

  set scale(double? value) {
    if (_scale != value) {
      if (value != null) {
        if (minScale != null) {
          value = max(minScale!, value);
        }
        if (maxScale != null) {
          value = min(maxScale!, value);
        }
      }
      _scale = value;
      translate?.also((it) {
        _translate = _adjustTranslate(it);
      });
      notifyListeners();
    }
  }

  set scaleGestureEnabled(bool value) {
    if (_scaleGestureEnabled != value) {
      _scaleGestureEnabled = value;
      notifyListeners();
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

  // ----------手势事件----------

  double? _previousScale;

  @internal
  void onScaleStart(ScaleStartDetails details) {
    if (scaleGestureEnabled && details.pointerCount >= 2) {
      _previousScale = scale;
    }
    if (drawingBoardEnabled) {
      drawingBoardExtension.onScaleStart(details);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onScaleStart(details);
    }
  }

  @internal
  void onScaleUpdate(ScaleUpdateDetails details) {
    if (scaleGestureEnabled && details.pointerCount >= 2) {
      scale = (_previousScale ?? 1.0) * details.scale;
    }
    if (translateGestureEnabled && details.pointerCount >= 2) {
      translate = (translate ?? Offset.zero) + details.focalPointDelta;
    }
    if (drawingBoardEnabled) {
      drawingBoardExtension.onScaleUpdate(details);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onScaleUpdate(details);
    }
  }

  @internal
  void onScaleEnd(ScaleEndDetails details) {
    _previousScale = null;
    if (drawingBoardEnabled) {
      drawingBoardExtension.onScaleEnd(details);
    }
    if (adjustBoundaryEnabled) {
      adjustBoundaryExtension.onScaleEnd(details);
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
