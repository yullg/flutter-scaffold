import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:meta/meta.dart';

import 'canvas_container_controller_extensions.dart';

class CanvasContainerExtensionOption {
  final double? minScale;
  final double? maxScale;
  final bool scaleGestureEnabled;
  final bool rotateGestureEnabled;
  final bool translateGestureEnabled;
  final bool singleFingerTranslate;

  const CanvasContainerExtensionOption({
    this.minScale = 0.3,
    this.maxScale = 3.0,
    this.scaleGestureEnabled = true,
    this.rotateGestureEnabled = true,
    this.translateGestureEnabled = true,
    this.singleFingerTranslate = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CanvasContainerExtensionOption &&
          runtimeType == other.runtimeType &&
          minScale == other.minScale &&
          maxScale == other.maxScale &&
          scaleGestureEnabled == other.scaleGestureEnabled &&
          rotateGestureEnabled == other.rotateGestureEnabled &&
          translateGestureEnabled == other.translateGestureEnabled &&
          singleFingerTranslate == other.singleFingerTranslate;

  @override
  int get hashCode =>
      minScale.hashCode ^
      maxScale.hashCode ^
      scaleGestureEnabled.hashCode ^
      rotateGestureEnabled.hashCode ^
      translateGestureEnabled.hashCode ^
      singleFingerTranslate.hashCode;

  @override
  String toString() {
    return 'CanvasContainerExtensionOption{minScale: $minScale, maxScale: $maxScale, scaleGestureEnabled: $scaleGestureEnabled, rotateGestureEnabled: $rotateGestureEnabled, translateGestureEnabled: $translateGestureEnabled, singleFingerTranslate: $singleFingerTranslate}';
  }
}

class CanvasContainerExtension extends ChangeNotifier {
  final CanvasContainerControllerExtensions _extensions;

  CanvasContainerExtension({
    required CanvasContainerControllerExtensions extensions,
    required CanvasContainerExtensionOption option,
  })  : _extensions = extensions,
        _scaleGestureEnabled = option.scaleGestureEnabled,
        _rotateGestureEnabled = option.rotateGestureEnabled,
        _translateGestureEnabled = option.translateGestureEnabled,
        _singleFingerTranslate = option.singleFingerTranslate,
        _minScale = option.minScale,
        _maxScale = option.maxScale;

  Size? _containerSize;
  Size? _containerChildSize;

  @internal
  void attach({
    required Size containerSize,
    required Size containerChildSize,
  }) {
    _containerSize = containerSize;
    _containerChildSize = containerChildSize;
    // 校正位移以适配新的Widget窗口大小
    _adjustTranslateWithoutNotify();
  }

  @internal
  void detach() {
    _containerSize = null;
    _containerChildSize = null;
  }

  Size? get containerSize => _containerSize;

  Size get requiredContainerSize =>
      containerSize ??
      (throw StateError("Not attached to CanvasContainer yet"));

  Size? get containerChildSize => _containerChildSize;

  Size get requiredContainerChildSize =>
      containerChildSize ??
      (throw StateError("Not attached to CanvasContainer yet"));

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

  Offset containerChildOffset(Offset containerOffset) {
    return containerOffset - requiredContainerChildRect.topLeft;
  }

  // ---------- 缩放 ----------

  bool _scaleGestureEnabled;
  final double? _minScale;
  final double? _maxScale;
  double? _scale;

  bool get scaleGestureEnabled => _scaleGestureEnabled;

  set scaleGestureEnabled(bool value) {
    if (_scaleGestureEnabled != value) {
      _scaleGestureEnabled = value;
      notifyListeners();
    }
  }

  double? get scale => _scale;

  set scale(double? value) {
    if (value != null) {
      if (_minScale != null) {
        value = max(_minScale, value);
      }
      if (_maxScale != null) {
        value = min(_maxScale, value);
      }
    }
    if (_scale != value) {
      _scale = value;
      _adjustTranslateWithoutNotify();
      notifyListeners();
    }
  }

  // ---------- 旋转 ----------

  bool _rotateGestureEnabled;
  int? _rotate;

  bool get rotateGestureEnabled => _rotateGestureEnabled;

  set rotateGestureEnabled(bool value) {
    if (_rotateGestureEnabled != value) {
      _rotateGestureEnabled = value;
      notifyListeners();
    }
  }

  int? get rotate => _rotate;

  set rotate(int? value) {
    if (value != null) {
      value = value % 360;
    }
    if (_rotate != value) {
      _rotate = value;
      _adjustTranslateWithoutNotify();
      notifyListeners();
    }
  }

  void rotateBy(int value) {
    rotate = (rotate ?? 0) + value % 360;
  }

  // ---------- 平移 ----------

  bool _translateGestureEnabled;
  final bool _singleFingerTranslate;
  Offset? _translate;

  bool get translateGestureEnabled => _translateGestureEnabled;

  set translateGestureEnabled(bool value) {
    if (_translateGestureEnabled != value) {
      _translateGestureEnabled = value;
      notifyListeners();
    }
  }

  Offset? get translate => _translate;

  set translate(Offset? value) {
    value = _clampTranslate(value);
    if (_translate != value) {
      _translate = value;
      notifyListeners();
    }
  }

  void translateBy(Offset value) {
    translate = (translate ?? Offset.zero) + value;
  }

  void _adjustTranslateWithoutNotify() {
    final newTranslate = _clampTranslate(translate);
    if (_translate != newTranslate) {
      _translate = newTranslate;
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
    final rotate = this.rotate;
    if (rotate != null && rotate != 0) {
      final rotationAngle = rotate * (pi / 180);
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

  // ----------手势事件----------

  double? _previousScale;
  int? _previousRotate;

  @internal
  void onScaleStart(ScaleStartDetails details) {
    if (scaleGestureEnabled && details.pointerCount >= 2) {
      _previousScale = scale;
    }
    if (rotateGestureEnabled && details.pointerCount >= 2) {
      _previousRotate = rotate;
    }
  }

  @internal
  void onScaleUpdate(ScaleUpdateDetails details) {
    if (scaleGestureEnabled && details.pointerCount >= 2) {
      scale = (_previousScale ?? 1.0) * details.scale;
    }
    if (rotateGestureEnabled && details.pointerCount >= 2) {
      rotate = (_previousRotate ?? 0) + (details.rotation * (180 / pi)).toInt();
    }
    if (translateGestureEnabled &&
        (_singleFingerTranslate || details.pointerCount >= 2)) {
      translate = (translate ?? Offset.zero) + details.focalPointDelta;
    }
  }

  @internal
  void onScaleEnd(ScaleEndDetails details) {
    _previousScale = null;
    _previousRotate = null;
  }
}
