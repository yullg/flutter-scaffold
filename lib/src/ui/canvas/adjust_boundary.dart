import 'package:flutter/material.dart';

import 'adjust_boundary_extension.dart';
import 'adjust_boundary_mode.dart';

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
  final AdjustBoundaryStyle style;
  final Rect boundary;
  final AdjustBoundaryMode? adjustBoundaryMode;

  _AdjustBoundaryPainter({
    required this.style,
    required this.boundary,
    this.adjustBoundaryMode,
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
      style != oldDelegate.style ||
      boundary != oldDelegate.boundary ||
      adjustBoundaryMode != oldDelegate.adjustBoundaryMode;
}
