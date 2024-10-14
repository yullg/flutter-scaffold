import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'drawing_board_extension.dart';

class DrawingBoardStyle {
  final Color ringColor;
  final double ringWidth;

  const DrawingBoardStyle({
    this.ringColor = Colors.white,
    this.ringWidth = 2,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawingBoardStyle &&
          runtimeType == other.runtimeType &&
          ringColor == other.ringColor &&
          ringWidth == other.ringWidth;

  @override
  int get hashCode => ringColor.hashCode ^ ringWidth.hashCode;

  @override
  String toString() {
    return 'DrawingBoardStyle{ringColor: $ringColor, ringWidth: $ringWidth}';
  }
}

class DrawingBoard extends StatelessWidget {
  final DrawingBoardExtension extension;
  final DrawingBoardStyle style;

  late final Paint _ringPaint;
  late final Paint _layerPaint;

  DrawingBoard({
    super.key,
    required this.extension,
    required this.style,
  }) {
    _ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = style.ringWidth
      ..color = style.ringColor;
    _layerPaint = Paint();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: extension,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _DrawingBoardPainter(
            image: extension.image,
            path: extension.inUsePath,
            ringPosition: extension.inUsePosition,
            pathPaint: extension.paint.paint,
            ringPaint: _ringPaint,
            layerPaint: _layerPaint,
          ),
        );
      },
    );
  }
}

class _DrawingBoardPainter extends CustomPainter {
  final ui.Image? image;
  final Path? path;
  final Offset? ringPosition;
  final Paint pathPaint;
  final Paint ringPaint;
  final Paint layerPaint;

  _DrawingBoardPainter({
    this.image,
    this.path,
    this.ringPosition,
    required this.pathPaint,
    required this.ringPaint,
    required this.layerPaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(rect);
    canvas.saveLayer(rect, layerPaint);
    if (image != null) {
      paintImage(canvas: canvas, rect: rect, image: image!, fit: BoxFit.fill);
    }
    if (path != null) {
      canvas.drawPath(path!, pathPaint);
    }
    if (ringPosition != null) {
      canvas.drawCircle(ringPosition!,
          pathPaint.strokeWidth / 2 + ringPaint.strokeWidth / 2, ringPaint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
