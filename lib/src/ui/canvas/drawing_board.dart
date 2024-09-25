import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:scaffold/scaffold_lang.dart';

class DrawingBoardExtension extends ChangeNotifier {
  final _paint = Paint();
  final _imageList = <ui.Image>[];
  int _imageIndex = 0;

  DrawingBoardExtension() {
    _paint.style = PaintingStyle.stroke;
    _paint.strokeCap = StrokeCap.round;
    _paint.isAntiAlias = true;
    _paint.strokeWidth = 8;
  }

  // ---------- 画笔配置 ----------

  double get paintStrokeWidth => _paint.strokeWidth;

  set paintStrokeWidth(double value) => _paint.strokeWidth = value;

  Color get paintColor => _paint.color;

  set paintColor(Color value) => _paint.color = value;

  PaintingStyle get paintStyle => _paint.style;

  set paintStyle(PaintingStyle value) => _paint.style = value;

  StrokeCap get paintStrokeCap => _paint.strokeCap;

  set paintStrokeCap(StrokeCap value) => _paint.strokeCap = value;

  BlendMode get paintBlendMode => _paint.blendMode;

  set paintBlendMode(BlendMode value) => _paint.blendMode = value;

  bool get paintIsAntiAlias => _paint.isAntiAlias;

  set paintIsAntiAlias(bool value) => _paint.isAntiAlias = value;

  // ---------- 历史快照管理 ----------

  ui.Image? get image {
    if (_imageIndex < _imageList.length) {
      return _imageList[_imageIndex];
    } else {
      return _imageList.lastOrNull;
    }
  }

  bool get canUndo => _imageIndex > 0;

  bool get canRedo => _imageIndex < _imageList.length - 1;

  void undo() {
    if (canUndo) {
      _imageIndex = max(0, min(_imageList.length - 1, _imageIndex - 1));
      notifyListeners();
    }
  }

  void redo() {
    if (canRedo) {
      _imageIndex = max(0, min(_imageList.length - 1, _imageIndex + 1));
      notifyListeners();
    }
  }

  void _pushImage(ui.Image image) {
    _imageList.add(image);
    _imageIndex = max(0, _imageList.length - 1);
    notifyListeners();
  }

  // ---------- 绘图管理 ----------
  Path? _currentPath;
  ui.Offset? _currentPosition;
  ui.PictureRecorder? _currentPictureRecorder;
  Canvas? _currentCanvas;

  @internal
  void onPanDown(DragDownDetails details) {
    _currentPath = Path()
      ..moveTo(details.localPosition.dx, details.localPosition.dy);
    _currentPosition = details.localPosition;
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    image?.let((it) {
      canvas.drawImage(it, Offset.zero, Paint());
    });
    canvas.scale(_kImageCanvasScale);
    _currentPictureRecorder = pictureRecorder;
    _currentCanvas = canvas;
    notifyListeners();
  }

  @internal
  void onPanUpdate(DragUpdateDetails details) {
    _currentPath?.lineTo(details.localPosition.dx, details.localPosition.dy);
    _currentPosition = details.localPosition;
    notifyListeners();
  }

  @internal
  void onPanEnd({
    required Size? containerSize,
  }) {
    _currentPath?.let((it) {
      _currentCanvas?.drawPath(it, _paint);
    });
    _currentPath = null;
    _currentPosition = null;
    final picture = _currentPictureRecorder?.endRecording();
    _currentPictureRecorder = null;
    _currentCanvas = null;
    if (picture != null && containerSize != null) {
      try {
        final image = picture.toImageSync(
            (containerSize.width * _kImageCanvasScale).floor(),
            (containerSize.height * _kImageCanvasScale).floor());
        _pushImage(image);
      } finally {
        picture.dispose();
      }
    } else {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    try {
      for (final image in _imageList) {
        image.dispose();
      }
    } finally {
      super.dispose();
    }
  }
}

class DrawingBoard extends StatelessWidget {
  final DrawingBoardExtension extension;

  late final Paint _eraserPaint;
  late final Paint _layerPaint;

  DrawingBoard({
    super.key,
    required this.extension,
    double eraserStrokeWidth = 2,
    Color eraserColor = Colors.white,
  }) {
    _eraserPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = eraserStrokeWidth
      ..color = eraserColor;
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
            path: extension._currentPath,
            pathEndPoint: extension._currentPosition,
            pathPaint: extension._paint,
            pathEndPointPaint: _eraserPaint,
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
  final Offset? pathEndPoint;
  final Paint pathPaint;
  final Paint pathEndPointPaint;
  final Paint layerPaint;

  _DrawingBoardPainter({
    this.image,
    this.path,
    this.pathEndPoint,
    required this.pathPaint,
    required this.pathEndPointPaint,
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
    if (pathEndPoint != null && BlendMode.clear == pathPaint.blendMode) {
      canvas.drawCircle(
          pathEndPoint!, pathPaint.strokeWidth / 2, pathEndPointPaint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

const double _kImageCanvasScale = 4;
