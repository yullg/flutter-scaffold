import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:meta/meta.dart';

import 'canvas_container_controller_extensions.dart';

class AdjustBoundaryExtensionOption {
  final Size minBoundarySize;

  const AdjustBoundaryExtensionOption({
    this.minBoundarySize = const Size(48, 48),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdjustBoundaryExtensionOption &&
          runtimeType == other.runtimeType &&
          minBoundarySize == other.minBoundarySize;

  @override
  int get hashCode => minBoundarySize.hashCode;

  @override
  String toString() {
    return 'AdjustBoundaryExtensionOption{minBoundarySize: $minBoundarySize}';
  }
}

class AdjustBoundaryExtension extends ChangeNotifier {
  final CanvasContainerControllerExtensions _extensions;

  AdjustBoundaryExtension({
    required CanvasContainerControllerExtensions extensions,
    required AdjustBoundaryExtensionOption option,
  })  : _extensions = extensions,
        minBoundarySize = option.minBoundarySize;

  final Size minBoundarySize;

  @internal
  void attach() {
    final containerChildSize =
        _extensions.canvasContainerExtension.requiredContainerChildSize;
    _adjustBoundary(
      oldBoundary: Rect.fromLTWH(
          0, 0, containerChildSize.width, containerChildSize.height),
    );
  }

  AdjustBoundaryMode? _adjustBoundaryMode;
  double? _aspectRatio;
  Rect? _boundary;

  @internal
  AdjustBoundaryMode? get adjustBoundaryMode => _adjustBoundaryMode;

  @internal
  set adjustBoundaryMode(AdjustBoundaryMode? value) {
    if (_adjustBoundaryMode != value) {
      _adjustBoundaryMode = value;
      notifyListeners();
    }
  }

  double? get aspectRatio => _aspectRatio;

  set aspectRatio(double? value) {
    if (_aspectRatio != value) {
      _aspectRatio = value;
      final containerChildSize =
          _extensions.canvasContainerExtension.requiredContainerChildSize;
      _adjustBoundary(
        oldBoundary: Rect.fromLTWH(
            0, 0, containerChildSize.width, containerChildSize.height),
      );
      notifyListeners();
    }
  }

  Rect? get boundary => _boundary;

  void _moveBoundary({
    required Rect oldBoundary,
    required Offset offset,
  }) {
    final containerChildSize =
        _extensions.canvasContainerExtension.requiredContainerChildSize;
    final maxLeft = containerChildSize.width - oldBoundary.width;
    final maxTop = containerChildSize.height - oldBoundary.height;
    final newBoundary = Rect.fromLTWH(
        max(0, min(maxLeft, oldBoundary.left + offset.dx)),
        max(0, min(maxTop, oldBoundary.top + offset.dy)),
        oldBoundary.width,
        oldBoundary.height);
    if (_boundary != newBoundary) {
      _boundary = newBoundary;
      notifyListeners();
    }
  }

  void _adjustBoundary({
    required Rect oldBoundary,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    final containerChildSize =
        _extensions.canvasContainerExtension.requiredContainerChildSize;
    final maxRight = containerChildSize.width;
    final maxBottom = containerChildSize.height;
    double newRight = max(0, min(maxRight, oldBoundary.right + (right ?? 0)));
    double newBottom =
        max(0, min(maxBottom, oldBoundary.bottom + (bottom ?? 0)));
    double newLeft = max(0, min(newRight, oldBoundary.left + (left ?? 0)));
    double newTop = max(0, min(newBottom, oldBoundary.top + (top ?? 0)));
    final newWidth = newRight - newLeft;
    final newHeight = newBottom - newTop;
    final aspectRatio = this.aspectRatio;
    if (aspectRatio != null && newWidth > 0 && newHeight > 0) {
      if (left != null && top != null) {
        if (newWidth / newHeight > aspectRatio) {
          newLeft = newRight - newHeight * aspectRatio;
        } else {
          newTop = newBottom - newWidth / aspectRatio;
        }
      } else if (right != null && top != null) {
        if (newWidth / newHeight > aspectRatio) {
          newRight = newLeft + newHeight * aspectRatio;
        } else {
          newTop = newBottom - newWidth / aspectRatio;
        }
      } else if (right != null && bottom != null) {
        if (newWidth / newHeight > aspectRatio) {
          newRight = newLeft + newHeight * aspectRatio;
        } else {
          newBottom = newTop + newWidth / aspectRatio;
        }
      } else if (left != null && bottom != null) {
        if (newWidth / newHeight > aspectRatio) {
          newLeft = newRight - newHeight * aspectRatio;
        } else {
          newBottom = newTop + newWidth / aspectRatio;
        }
      } else if (left != null || right != null) {
        newTop = max(0, oldBoundary.center.dy - newWidth / aspectRatio / 2);
        newBottom = newTop + newWidth / aspectRatio;
      } else if (top != null || bottom != null) {
        newLeft = max(0, oldBoundary.center.dx - newHeight * aspectRatio / 2);
        newRight = newLeft + newHeight * aspectRatio;
      } else {
        if (newWidth / newHeight > aspectRatio) {
          newLeft = oldBoundary.center.dx - newHeight * aspectRatio / 2;
          newRight = oldBoundary.center.dx + newHeight * aspectRatio / 2;
          newTop = oldBoundary.center.dy - newHeight / 2;
          newBottom = oldBoundary.center.dy + newHeight / 2;
        } else {
          newLeft = oldBoundary.center.dx - newWidth / 2;
          newRight = oldBoundary.center.dx + newWidth / 2;
          newTop = oldBoundary.center.dy - newWidth / aspectRatio / 2;
          newBottom = oldBoundary.center.dy + newWidth / aspectRatio / 2;
        }
      }
    }
    final newBoundary = Rect.fromLTRB(newLeft, newTop, newRight, newBottom);
    if (newBoundary.left < 0 ||
        newBoundary.top < 0 ||
        newBoundary.right > containerChildSize.width ||
        newBoundary.bottom > containerChildSize.height ||
        newBoundary.width < minBoundarySize.width ||
        newBoundary.height < minBoundarySize.height) {
      return;
    }
    if (_boundary != newBoundary) {
      _boundary = newBoundary;
      notifyListeners();
    }
  }

  // ----------手势事件----------

  @internal
  void onPointerDown(PointerDownEvent event) {
    final boundary = this.boundary;
    if (boundary == null) return;
    final position = _extensions.canvasContainerExtension
        .containerChildOffset(event.localPosition);
    AdjustBoundaryMode? newAdjustBoundaryMode;
    final expandedBoundary = Rect.fromCenter(
      center: boundary.center,
      width: boundary.width + 48,
      height: boundary.height + 48,
    );
    if (expandedBoundary.contains(position)) {
      newAdjustBoundaryMode = AdjustBoundaryMode.inside;
      final expandedPosition = Rect.fromCenter(
        center: position,
        width: 48,
        height: 48,
      );
      if (expandedPosition.contains(boundary.topLeft)) {
        newAdjustBoundaryMode = AdjustBoundaryMode.leftTop;
      } else if (expandedPosition.contains(boundary.topRight)) {
        newAdjustBoundaryMode = AdjustBoundaryMode.rightTop;
      } else if (expandedPosition.contains(boundary.bottomRight)) {
        newAdjustBoundaryMode = AdjustBoundaryMode.rightBottom;
      } else if (expandedPosition.contains(boundary.bottomLeft)) {
        newAdjustBoundaryMode = AdjustBoundaryMode.leftBottom;
      } else if (expandedPosition.contains(boundary.centerLeft)) {
        newAdjustBoundaryMode = AdjustBoundaryMode.leftCenter;
      } else if (expandedPosition.contains(boundary.topCenter)) {
        newAdjustBoundaryMode = AdjustBoundaryMode.topCenter;
      } else if (expandedPosition.contains(boundary.centerRight)) {
        newAdjustBoundaryMode = AdjustBoundaryMode.rightCenter;
      } else if (expandedPosition.contains(boundary.bottomCenter)) {
        newAdjustBoundaryMode = AdjustBoundaryMode.bottomCenter;
      }
    } else {
      newAdjustBoundaryMode = null;
    }
    adjustBoundaryMode = newAdjustBoundaryMode;
  }

  @internal
  void onPointerMove(PointerMoveEvent event) {
    final boundary = this.boundary;
    if (boundary == null) return;
    final adjustBoundaryMode = this.adjustBoundaryMode;
    if (adjustBoundaryMode == null) return;
    switch (adjustBoundaryMode) {
      case AdjustBoundaryMode.inside:
        _moveBoundary(
          oldBoundary: boundary,
          offset: event.localDelta,
        );
      case AdjustBoundaryMode.leftTop:
        _adjustBoundary(
          oldBoundary: boundary,
          left: event.localDelta.dx,
          top: event.localDelta.dy,
        );
      case AdjustBoundaryMode.rightTop:
        _adjustBoundary(
          oldBoundary: boundary,
          right: event.localDelta.dx,
          top: event.localDelta.dy,
        );
      case AdjustBoundaryMode.rightBottom:
        _adjustBoundary(
          oldBoundary: boundary,
          right: event.localDelta.dx,
          bottom: event.localDelta.dy,
        );
      case AdjustBoundaryMode.leftBottom:
        _adjustBoundary(
          oldBoundary: boundary,
          left: event.localDelta.dx,
          bottom: event.localDelta.dy,
        );
      case AdjustBoundaryMode.leftCenter:
        _adjustBoundary(
          oldBoundary: boundary,
          left: event.localDelta.dx,
        );
      case AdjustBoundaryMode.topCenter:
        _adjustBoundary(
          oldBoundary: boundary,
          top: event.localDelta.dy,
        );
      case AdjustBoundaryMode.rightCenter:
        _adjustBoundary(
          oldBoundary: boundary,
          right: event.localDelta.dx,
        );
      case AdjustBoundaryMode.bottomCenter:
        _adjustBoundary(
          oldBoundary: boundary,
          bottom: event.localDelta.dy,
        );
    }
  }

  @internal
  void onPointerUpByChild(PointerUpEvent event) {
    adjustBoundaryMode = null;
  }

  @internal
  void onPointerCancelByChild(PointerCancelEvent event) {
    adjustBoundaryMode = null;
  }
}

@internal
enum AdjustBoundaryMode {
  inside,
  leftTop,
  rightTop,
  leftBottom,
  rightBottom,
  leftCenter,
  topCenter,
  rightCenter,
  bottomCenter,
}
