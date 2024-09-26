import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class AdjustBoundaryExtension extends ChangeNotifier {
  final Size minBoundarySize;

  AdjustBoundaryExtension({
    this.minBoundarySize = const Size(48, 48),
  });

  // ---------- 画板 ----------
  Size? _containerSize;

  @internal
  set containerSize(Size? value) {
    if (_containerSize != value) {
      _containerSize = value;
      adjustBoundary(containerSize: value);
    }
  }

  Rect? _boundary;
  double? _aspectRatio;
  AdjustBoundaryMode? _adjustBoundaryMode;

  Rect? get boundary => _boundary;

  double? get aspectRatio => _aspectRatio;

  AdjustBoundaryMode? get adjustBoundaryMode => _adjustBoundaryMode;

  set boundary(Rect? value) {
    if (_boundary != value) {
      _boundary = value;
      notifyListeners();
    }
  }

  set aspectRatio(double? value) {
    if (_aspectRatio != value) {
      _aspectRatio = value;
      notifyListeners();
      adjustBoundary(containerSize: boundary?.size);
    }
  }

  set adjustBoundaryMode(AdjustBoundaryMode? value) {
    if (_adjustBoundaryMode != value) {
      _adjustBoundaryMode = value;
      notifyListeners();
    }
  }

  void adjustBoundary({
    Size? containerSize,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (containerSize != null) {
      left = max(0, left ?? boundary?.left ?? 0);
      top = max(0, top ?? boundary?.top ?? 0);
      right = min(
          containerSize.width, right ?? boundary?.right ?? containerSize.width);
      bottom = min(containerSize.height,
          bottom ?? boundary?.bottom ?? containerSize.height);
      final width = right - left;
      final height = bottom - top;
      final aspectRatio = this.aspectRatio;
      Rect newBoundary;
      if (aspectRatio != null) {
        if (width / height > aspectRatio) {
          switch (adjustBoundaryMode) {
            case AdjustBoundaryMode.leftTop:
            case AdjustBoundaryMode.leftBottom:
              newBoundary = Rect.fromLTRB(
                right - height * aspectRatio,
                top,
                right,
                bottom,
              );
            case AdjustBoundaryMode.rightTop:
            case AdjustBoundaryMode.rightBottom:
              newBoundary = Rect.fromLTRB(
                left,
                top,
                left + height * aspectRatio,
                bottom,
              );
            default:
              newBoundary = Rect.fromCenter(
                center:
                    Offset(left + (right - left) / 2, top + (bottom - top) / 2),
                width: height * aspectRatio,
                height: height,
              );
          }
        } else {
          switch (adjustBoundaryMode) {
            case AdjustBoundaryMode.leftTop:
            case AdjustBoundaryMode.rightTop:
              newBoundary = Rect.fromLTRB(
                left,
                bottom - width / aspectRatio,
                right,
                bottom,
              );
            case AdjustBoundaryMode.leftBottom:
            case AdjustBoundaryMode.rightBottom:
              newBoundary = Rect.fromLTRB(
                left,
                top,
                right,
                top + width / aspectRatio,
              );
            default:
              newBoundary = Rect.fromCenter(
                center:
                    Offset(left + (right - left) / 2, top + (bottom - top) / 2),
                width: width,
                height: width / aspectRatio,
              );
          }
        }
      } else {
        newBoundary = Rect.fromLTRB(left, top, right, bottom);
      }
      if (newBoundary.width < minBoundarySize.width ||
          newBoundary.height < minBoundarySize.height ||
          newBoundary.left < 0 ||
          newBoundary.top < 0 ||
          newBoundary.right > containerSize.width ||
          newBoundary.bottom > containerSize.height) {
        return;
      }
      boundary = newBoundary;
    } else {
      boundary = null;
    }
  }

  @internal
  void onPanDown(Offset position) {
    final boundary = this.boundary;
    if (boundary == null) return;
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
      // CORNERS
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
  void onPanUpdate({
    required Offset delta,
    required Size? containerSize,
  }) {
    if (containerSize == null) return;
    final boundary = this.boundary;
    if (boundary == null) return;
    switch (adjustBoundaryMode) {
      case AdjustBoundaryMode.inside:
        final Offset pos = boundary.topLeft + delta;
        this.boundary = Rect.fromLTWH(
            pos.dx.clamp(0, containerSize.width - boundary.width),
            pos.dy.clamp(0, containerSize.height - boundary.height),
            boundary.width,
            boundary.height);
      // 角
      case AdjustBoundaryMode.leftTop:
        final Offset pos = boundary.topLeft + delta;
        adjustBoundary(
          containerSize: containerSize,
          left: pos.dx,
          top: pos.dy,
        );
      case AdjustBoundaryMode.rightTop:
        final Offset pos = boundary.topRight + delta;
        adjustBoundary(
          containerSize: containerSize,
          right: pos.dx,
          top: pos.dy,
        );
      case AdjustBoundaryMode.rightBottom:
        final Offset pos = boundary.bottomRight + delta;
        adjustBoundary(
          containerSize: containerSize,
          right: pos.dx,
          bottom: pos.dy,
        );
      case AdjustBoundaryMode.leftBottom:
        final Offset pos = boundary.bottomLeft + delta;
        adjustBoundary(
          containerSize: containerSize,
          left: pos.dx,
          bottom: pos.dy,
        );
      // 边
      case AdjustBoundaryMode.topCenter:
        adjustBoundary(
          containerSize: containerSize,
          top: boundary.top + delta.dy,
        );
      case AdjustBoundaryMode.bottomCenter:
        adjustBoundary(
          containerSize: containerSize,
          bottom: boundary.bottom + delta.dy,
        );
      case AdjustBoundaryMode.leftCenter:
        adjustBoundary(
          containerSize: containerSize,
          left: boundary.left + delta.dx,
        );
      case AdjustBoundaryMode.rightCenter:
        adjustBoundary(
          containerSize: containerSize,
          right: boundary.right + delta.dx,
        );
      default:
        break;
    }
  }

  @internal
  void onPanEnd() {
    adjustBoundaryMode = null;
  }
}

enum AdjustBoundaryMode {
  inside,
  leftTop,
  leftCenter,
  leftBottom,
  topCenter,
  rightTop,
  rightCenter,
  rightBottom,
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
    this.showCenterIndicator = false,
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
    this.style = const AdjustBoundaryStyle(),
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
