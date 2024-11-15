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
  final bool rotationGestureEnabled;
  final bool translateGestureEnabled;
  final bool singleFingerTranslation;

  const CanvasContainerExtensionOption({
    this.minScale = 0.3,
    this.maxScale = 3.0,
    this.scaleGestureEnabled = true,
    this.rotationGestureEnabled = true,
    this.translateGestureEnabled = true,
    this.singleFingerTranslation = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CanvasContainerExtensionOption &&
          runtimeType == other.runtimeType &&
          minScale == other.minScale &&
          maxScale == other.maxScale &&
          scaleGestureEnabled == other.scaleGestureEnabled &&
          rotationGestureEnabled == other.rotationGestureEnabled &&
          translateGestureEnabled == other.translateGestureEnabled &&
          singleFingerTranslation == other.singleFingerTranslation;

  @override
  int get hashCode =>
      minScale.hashCode ^
      maxScale.hashCode ^
      scaleGestureEnabled.hashCode ^
      rotationGestureEnabled.hashCode ^
      translateGestureEnabled.hashCode ^
      singleFingerTranslation.hashCode;

  @override
  String toString() {
    return 'CanvasContainerExtensionOption{minScale: $minScale, maxScale: $maxScale, scaleGestureEnabled: $scaleGestureEnabled, rotationGestureEnabled: $rotationGestureEnabled, translateGestureEnabled: $translateGestureEnabled, singleFingerTranslation: $singleFingerTranslation}';
  }
}

class CanvasContainerExtension extends ChangeNotifier {
  final CanvasContainerControllerExtensions _extensions;

  CanvasContainerExtension({
    required CanvasContainerControllerExtensions extensions,
    required CanvasContainerExtensionOption option,
  })  : _extensions = extensions,
        _scaleGestureEnabled = option.scaleGestureEnabled,
        _rotationGestureEnabled = option.rotationGestureEnabled,
        _translateGestureEnabled = option.translateGestureEnabled,
        _singleFingerTranslation = option.singleFingerTranslation,
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
      translate = translate;
      notifyListeners();
    }
  }

  // ---------- 旋转 ----------

  bool _rotationGestureEnabled;
  int? _rotation;

  bool get rotationGestureEnabled => _rotationGestureEnabled;

  set rotationGestureEnabled(bool value) {
    if (_rotationGestureEnabled != value) {
      _rotationGestureEnabled = value;
      notifyListeners();
    }
  }

  int? get rotation => _rotation;

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

  // ---------- 平移 ----------

  bool _translateGestureEnabled;
  final bool _singleFingerTranslation;
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

  // ----------手势事件----------

  double? _previousScale;
  int? _previousRotation;

  @internal
  void onScaleStart(ScaleStartDetails details) {
    if (scaleGestureEnabled && details.pointerCount >= 2) {
      _previousScale = scale;
    }
    if (rotationGestureEnabled && details.pointerCount >= 2) {
      _previousRotation = rotation;
    }
  }

  @internal
  void onScaleUpdate(ScaleUpdateDetails details) {
    if (scaleGestureEnabled && details.pointerCount >= 2) {
      scale = (_previousScale ?? 1.0) * details.scale;
    }
    if (rotationGestureEnabled && details.pointerCount >= 2) {
      rotation =
          (_previousRotation ?? 0) + (details.rotation * (180 / pi)).toInt();
    }
    if (translateGestureEnabled &&
        (_singleFingerTranslation || details.pointerCount >= 2)) {
      translate = (translate ?? Offset.zero) + details.focalPointDelta;
    }
  }

  @internal
  void onScaleEnd(ScaleEndDetails details) {
    _previousScale = null;
    _previousRotation = null;
  }
}
