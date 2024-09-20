import 'package:flutter/material.dart';

class AdjustBoundaryController extends ChangeNotifier {
  Rect _boundary = Rect.zero;
  AdjustBoundaryMode _adjustBoundaryMode = AdjustBoundaryMode.none;

  Rect get boundary => _boundary;

  AdjustBoundaryMode get adjustBoundaryMode => _adjustBoundaryMode;

  set boundary(Rect value) {
    _boundary = value;
    notifyListeners();
  }

  set adjustBoundaryMode(AdjustBoundaryMode value) {
    _adjustBoundaryMode = value;
    notifyListeners();
  }
}

class AdjustBoundary extends StatelessWidget {
  final AdjustBoundaryController controller;
  final Color? backgroundColor;
  final int gridLineCount;
  final double gridLineWidth;
  final Color gridLineColor;
  final double boundaryWidth;
  final double boundaryLength;
  final Color boundaryColor;
  final Color activatedBoundaryColor;
  final bool showCenterIndicator;

  const AdjustBoundary({
    super.key,
    required this.controller,
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
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _AdjustBoundaryPainter(
            boundary: controller.boundary,
            backgroundColor: backgroundColor,
            gridLineCount: gridLineCount,
            gridLineWidth: gridLineWidth,
            gridLineColor: gridLineColor,
            boundaryWidth: boundaryWidth,
            boundaryLength: boundaryLength,
            boundaryColor: boundaryColor,
            activatedBoundaryColor: activatedBoundaryColor,
            showCenterIndicator: showCenterIndicator,
            adjustBoundaryMode: controller.adjustBoundaryMode,
          ),
        );
      },
    );
  }
}

@protected
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
  none
}

class _AdjustBoundaryPainter extends CustomPainter {
  final Rect boundary;
  final Color? backgroundColor;
  final int gridLineCount;
  final double gridLineWidth;
  final Color gridLineColor;
  final double boundaryWidth;
  final double boundaryLength;
  final Color boundaryColor;
  final Color activatedBoundaryColor;
  final bool showCenterIndicator;
  final AdjustBoundaryMode adjustBoundaryMode;

  _AdjustBoundaryPainter({
    required this.boundary,
    this.backgroundColor,
    required this.gridLineCount,
    required this.gridLineWidth,
    required this.gridLineColor,
    required this.boundaryWidth,
    required this.boundaryLength,
    required this.boundaryColor,
    required this.activatedBoundaryColor,
    required this.showCenterIndicator,
    required this.adjustBoundaryMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (backgroundColor != null) {
      final backgroundPaint = Paint()..color = backgroundColor!;
      canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
          Path()..addRect(boundary),
        ),
        backgroundPaint,
      );
    }
    if (gridLineCount > 0) {
      final gridLinePaint = Paint()
        ..strokeWidth = gridLineWidth
        ..color = gridLineColor;
      final gridWidth = boundary.width / (gridLineCount + 1);
      final gridHeight = boundary.height / (gridLineCount + 1);
      for (int i = 0; i < gridLineCount; i++) {
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
        boundary.topLeft + Offset(boundaryWidth, boundaryLength),
      ),
      boundaryPaint,
    );
    canvas.drawRect(
      Rect.fromPoints(
        boundary.topLeft,
        boundary.topLeft + Offset(boundaryLength, boundaryWidth),
      ),
      boundaryPaint,
    );
    // LEFT BOTTOM
    boundaryPaint.color =
        _calculateBoundaryColor(AdjustBoundaryMode.leftBottom);
    canvas.drawRect(
      Rect.fromPoints(
        boundary.bottomLeft - Offset(-boundaryWidth, boundaryLength),
        boundary.bottomLeft,
      ),
      boundaryPaint,
    );
    canvas.drawRect(
      Rect.fromPoints(
        boundary.bottomLeft,
        boundary.bottomLeft + Offset(boundaryLength, -boundaryWidth),
      ),
      boundaryPaint,
    );
    // RIGHT TOP
    boundaryPaint.color = _calculateBoundaryColor(AdjustBoundaryMode.rightTop);
    canvas.drawRect(
      Rect.fromPoints(
        boundary.topRight - Offset(boundaryLength, 0.0),
        boundary.topRight + Offset(0.0, boundaryWidth),
      ),
      boundaryPaint,
    );
    canvas.drawRect(
      Rect.fromPoints(
        boundary.topRight,
        boundary.topRight - Offset(boundaryWidth, -boundaryLength),
      ),
      boundaryPaint,
    );
    // RIGHT BOTTOM
    boundaryPaint.color =
        _calculateBoundaryColor(AdjustBoundaryMode.rightBottom);
    canvas.drawRect(
      Rect.fromPoints(
        boundary.bottomRight - Offset(boundaryWidth, boundaryLength),
        boundary.bottomRight,
      ),
      boundaryPaint,
    );
    canvas.drawRect(
      Rect.fromPoints(
        boundary.bottomRight,
        boundary.bottomRight - Offset(boundaryLength, boundaryWidth),
      ),
      boundaryPaint,
    );
    if (showCenterIndicator) {
      // TOP CENTER
      boundaryPaint.color =
          _calculateBoundaryColor(AdjustBoundaryMode.topCenter);
      canvas.drawRect(
        Rect.fromPoints(
          boundary.topCenter + Offset(-boundaryLength / 2, 0.0),
          boundary.topCenter + Offset(boundaryLength / 2, boundaryWidth),
        ),
        boundaryPaint,
      );
      // LEFT CENTER
      boundaryPaint.color =
          _calculateBoundaryColor(AdjustBoundaryMode.leftCenter);
      canvas.drawRect(
        Rect.fromPoints(
          boundary.centerLeft + Offset(0.0, -boundaryLength / 2),
          boundary.centerLeft + Offset(boundaryWidth, boundaryLength / 2),
        ),
        boundaryPaint,
      );
      // RIGHT CENTER
      boundaryPaint.color =
          _calculateBoundaryColor(AdjustBoundaryMode.rightCenter);
      canvas.drawRect(
        Rect.fromPoints(
          boundary.centerRight + Offset(-boundaryWidth, -boundaryLength / 2),
          boundary.centerRight + Offset(0.0, boundaryLength / 2),
        ),
        boundaryPaint,
      );
      // BOTTOM CENTER
      boundaryPaint.color =
          _calculateBoundaryColor(AdjustBoundaryMode.bottomCenter);
      canvas.drawRect(
        Rect.fromPoints(
          boundary.bottomCenter + Offset(-boundaryLength / 2, 0.0),
          boundary.bottomCenter + Offset(boundaryLength / 2, -boundaryWidth),
        ),
        boundaryPaint,
      );
    }
  }

  Color _calculateBoundaryColor(AdjustBoundaryMode mode) =>
      (AdjustBoundaryMode.inside == adjustBoundaryMode ||
              adjustBoundaryMode == mode)
          ? activatedBoundaryColor
          : boundaryColor;

  @override
  bool shouldRepaint(_AdjustBoundaryPainter oldDelegate) =>
      boundary != oldDelegate.boundary ||
      backgroundColor != oldDelegate.backgroundColor ||
      gridLineCount != oldDelegate.gridLineCount ||
      gridLineWidth != oldDelegate.gridLineWidth ||
      gridLineColor != oldDelegate.gridLineColor ||
      boundaryWidth != oldDelegate.boundaryWidth ||
      boundaryLength != oldDelegate.boundaryLength ||
      boundaryColor != oldDelegate.boundaryColor ||
      activatedBoundaryColor != oldDelegate.activatedBoundaryColor ||
      showCenterIndicator != oldDelegate.showCenterIndicator ||
      adjustBoundaryMode != oldDelegate.adjustBoundaryMode;
}
