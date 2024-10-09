import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'canvas_container_aware.dart';

class AdjustBoundaryExtension extends ChangeNotifier with CanvasContainerAware {
  final Size minBoundarySize;

  AdjustBoundaryExtension({
    this.minBoundarySize = const Size(48, 48),
  });

  @override
  void attach({required Size containerSize, required Size containerChildSize}) {
    super.attach(
        containerSize: containerSize, containerChildSize: containerChildSize);
    _adjustBoundary(
      oldBoundary: Rect.fromLTWH(
          0, 0, containerChildSize.width, containerChildSize.height),
    );
  }

  Rect? _boundary;
  double? _aspectRatio;
  AdjustBoundaryMode? _adjustBoundaryMode;

  Rect? get boundary => _boundary;

  double? get aspectRatio => _aspectRatio;

  AdjustBoundaryMode? get adjustBoundaryMode => _adjustBoundaryMode;

  set aspectRatio(double? value) {
    if (_aspectRatio != value) {
      _aspectRatio = value;
      _adjustBoundary(
        oldBoundary: Rect.fromLTWH(0, 0, requiredContainerChildSize.width,
            requiredContainerChildSize.height),
      );
      notifyListeners();
    }
  }

  set adjustBoundaryMode(AdjustBoundaryMode? value) {
    if (_adjustBoundaryMode != value) {
      _adjustBoundaryMode = value;
      notifyListeners();
    }
  }

  void _moveBoundary({
    required Rect oldBoundary,
    required Offset offset,
  }) {
    final maxLeft = requiredContainerChildSize.width - oldBoundary.width;
    final maxTop = requiredContainerChildSize.height - oldBoundary.height;
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
    final maxRight = requiredContainerChildSize.width;
    final maxBottom = requiredContainerChildSize.height;
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
        newBoundary.right > requiredContainerChildSize.width ||
        newBoundary.bottom > requiredContainerChildSize.height ||
        newBoundary.width < minBoundarySize.width ||
        newBoundary.height < minBoundarySize.height) {
      return;
    }
    if (_boundary != newBoundary) {
      _boundary = newBoundary;
      notifyListeners();
    }
  }

  @internal
  void onPointerDownByChild(PointerDownEvent event) {
    final boundary = this.boundary;
    if (boundary == null) return;
    final position = calculateContainerChildOffset(event.localPosition);
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
  void onPointerMoveByChild(PointerMoveEvent event) {
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

class AdjustBoundaryStyle {
  final Color? backgroundColor;
  final int gridLineCount;
  final double gridLineWidth;
  final Color gridLineColor;
  final double boundaryWidth;
  final double boundaryLength;
  final Color boundaryColor;
  final Color activatedBoundaryColor;
  final bool showCenterIndicator;

  const AdjustBoundaryStyle({
    this.backgroundColor = Colors.black45,
    this.gridLineCount = 3,
    this.gridLineWidth = 1,
    this.gridLineColor = Colors.white,
    this.boundaryWidth = 5,
    this.boundaryLength = 20,
    this.boundaryColor = Colors.white,
    this.activatedBoundaryColor = Colors.yellow,
    this.showCenterIndicator = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdjustBoundaryStyle &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          gridLineCount == other.gridLineCount &&
          gridLineWidth == other.gridLineWidth &&
          gridLineColor == other.gridLineColor &&
          boundaryWidth == other.boundaryWidth &&
          boundaryLength == other.boundaryLength &&
          boundaryColor == other.boundaryColor &&
          activatedBoundaryColor == other.activatedBoundaryColor &&
          showCenterIndicator == other.showCenterIndicator;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      gridLineCount.hashCode ^
      gridLineWidth.hashCode ^
      gridLineColor.hashCode ^
      boundaryWidth.hashCode ^
      boundaryLength.hashCode ^
      boundaryColor.hashCode ^
      activatedBoundaryColor.hashCode ^
      showCenterIndicator.hashCode;

  @override
  String toString() {
    return 'AdjustBoundaryStyle{backgroundColor: $backgroundColor, gridLineCount: $gridLineCount, gridLineWidth: $gridLineWidth, gridLineColor: $gridLineColor, boundaryWidth: $boundaryWidth, boundaryLength: $boundaryLength, boundaryColor: $boundaryColor, activatedBoundaryColor: $activatedBoundaryColor, showCenterIndicator: $showCenterIndicator}';
  }
}

class AdjustBoundary extends StatelessWidget {
  final AdjustBoundaryExtension extension;
  final AdjustBoundaryStyle style;

  const AdjustBoundary({
    super.key,
    required this.extension,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: extension,
      builder: (context, _) {
        final boundary = extension.boundary;
        if (boundary != null) {
          return CustomPaint(
            size: Size.infinite,
            painter: _AdjustBoundaryPainter(
              boundary: boundary,
              adjustBoundaryMode: extension.adjustBoundaryMode,
              style: style,
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class _AdjustBoundaryPainter extends CustomPainter {
  final Rect boundary;
  final AdjustBoundaryMode? adjustBoundaryMode;
  final AdjustBoundaryStyle style;

  _AdjustBoundaryPainter({
    required this.boundary,
    this.adjustBoundaryMode,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (style.backgroundColor != null) {
      final backgroundPaint = Paint()..color = style.backgroundColor!;
      canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
          Path()..addRect(boundary),
        ),
        backgroundPaint,
      );
    }
    if (style.gridLineCount > 0) {
      final gridLinePaint = Paint()
        ..strokeWidth = style.gridLineWidth
        ..color = style.gridLineColor;
      final gridWidth = boundary.width / (style.gridLineCount + 1);
      final gridHeight = boundary.height / (style.gridLineCount + 1);
      for (int i = 0; i < style.gridLineCount; i++) {
        final rowDy = boundary.top + gridHeight * (i + 1);
        final columnDx = boundary.left + gridWidth * (i + 1);
        canvas.drawLine(
          Offset(columnDx, boundary.top),
          Offset(columnDx, boundary.bottom),
          gridLinePaint,
        );
        canvas.drawLine(
          Offset(boundary.left, rowDy),
          Offset(boundary.right, rowDy),
          gridLinePaint,
        );
      }
    }
    final boundaryPaint = Paint();
    // LEFT TOP
    boundaryPaint.color = _calculateBoundaryColor(AdjustBoundaryMode.leftTop);
    canvas.drawRect(
      Rect.fromPoints(
        boundary.topLeft,
        boundary.topLeft + Offset(style.boundaryWidth, style.boundaryLength),
      ),
      boundaryPaint,
    );
    canvas.drawRect(
      Rect.fromPoints(
        boundary.topLeft,
        boundary.topLeft + Offset(style.boundaryLength, style.boundaryWidth),
      ),
      boundaryPaint,
    );
    // LEFT BOTTOM
    boundaryPaint.color =
        _calculateBoundaryColor(AdjustBoundaryMode.leftBottom);
    canvas.drawRect(
      Rect.fromPoints(
        boundary.bottomLeft -
            Offset(-style.boundaryWidth, style.boundaryLength),
        boundary.bottomLeft,
      ),
      boundaryPaint,
    );
    canvas.drawRect(
      Rect.fromPoints(
        boundary.bottomLeft,
        boundary.bottomLeft +
            Offset(style.boundaryLength, -style.boundaryWidth),
      ),
      boundaryPaint,
    );
    // RIGHT TOP
    boundaryPaint.color = _calculateBoundaryColor(AdjustBoundaryMode.rightTop);
    canvas.drawRect(
      Rect.fromPoints(
        boundary.topRight - Offset(style.boundaryLength, 0.0),
        boundary.topRight + Offset(0.0, style.boundaryWidth),
      ),
      boundaryPaint,
    );
    canvas.drawRect(
      Rect.fromPoints(
        boundary.topRight,
        boundary.topRight - Offset(style.boundaryWidth, -style.boundaryLength),
      ),
      boundaryPaint,
    );
    // RIGHT BOTTOM
    boundaryPaint.color =
        _calculateBoundaryColor(AdjustBoundaryMode.rightBottom);
    canvas.drawRect(
      Rect.fromPoints(
        boundary.bottomRight -
            Offset(style.boundaryWidth, style.boundaryLength),
        boundary.bottomRight,
      ),
      boundaryPaint,
    );
    canvas.drawRect(
      Rect.fromPoints(
        boundary.bottomRight,
        boundary.bottomRight -
            Offset(style.boundaryLength, style.boundaryWidth),
      ),
      boundaryPaint,
    );
    if (style.showCenterIndicator) {
      // TOP CENTER
      boundaryPaint.color =
          _calculateBoundaryColor(AdjustBoundaryMode.topCenter);
      canvas.drawRect(
        Rect.fromPoints(
          boundary.topCenter + Offset(-style.boundaryLength / 2, 0.0),
          boundary.topCenter +
              Offset(style.boundaryLength / 2, style.boundaryWidth),
        ),
        boundaryPaint,
      );
      // LEFT CENTER
      boundaryPaint.color =
          _calculateBoundaryColor(AdjustBoundaryMode.leftCenter);
      canvas.drawRect(
        Rect.fromPoints(
          boundary.centerLeft + Offset(0.0, -style.boundaryLength / 2),
          boundary.centerLeft +
              Offset(style.boundaryWidth, style.boundaryLength / 2),
        ),
        boundaryPaint,
      );
      // RIGHT CENTER
      boundaryPaint.color =
          _calculateBoundaryColor(AdjustBoundaryMode.rightCenter);
      canvas.drawRect(
        Rect.fromPoints(
          boundary.centerRight +
              Offset(-style.boundaryWidth, -style.boundaryLength / 2),
          boundary.centerRight + Offset(0.0, style.boundaryLength / 2),
        ),
        boundaryPaint,
      );
      // BOTTOM CENTER
      boundaryPaint.color =
          _calculateBoundaryColor(AdjustBoundaryMode.bottomCenter);
      canvas.drawRect(
        Rect.fromPoints(
          boundary.bottomCenter + Offset(-style.boundaryLength / 2, 0.0),
          boundary.bottomCenter +
              Offset(style.boundaryLength / 2, -style.boundaryWidth),
        ),
        boundaryPaint,
      );
    }
  }

  Color _calculateBoundaryColor(AdjustBoundaryMode mode) =>
      (AdjustBoundaryMode.inside == adjustBoundaryMode ||
              adjustBoundaryMode == mode)
          ? style.activatedBoundaryColor
          : style.boundaryColor;

  @override
  bool shouldRepaint(_AdjustBoundaryPainter oldDelegate) =>
      boundary != oldDelegate.boundary ||
      adjustBoundaryMode != oldDelegate.adjustBoundaryMode ||
      style != oldDelegate.style;
}
