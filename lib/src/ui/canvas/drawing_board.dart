import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:scaffold/scaffold_lang.dart';

class DrawingBoardExtension extends ChangeNotifier {
  final _paint = Paint();

  late final DrawingBoardPaint paint;

  DrawingBoardExtension() {
    _paint.style = PaintingStyle.stroke;
    _paint.strokeCap = StrokeCap.round;
    _paint.isAntiAlias = true;
    _paint.strokeWidth = 8;
    paint = DrawingBoardPaint(_paint);
  }

  // ---------- 画板 ----------
  Size? _containerSize;

  @internal
  set containerSize(Size? value) {
    if (_containerSize != value) {
      _containerSize = value;
    }
  }

  // ---------- 历史快照管理 ----------
  final _imageList = <ui.Image>[];
  int _imageIndex = -1;

  ui.Image? get image {
    if (_imageIndex >= 0 && _imageIndex < _imageList.length) {
      return _imageList[_imageIndex];
    } else {
      return null;
    }
  }

  bool get canUndo => _imageIndex >= 0;

  bool get canRedo => _imageIndex < _imageList.length - 1;

  void erase() {
    if (_imageList.isNotEmpty) {
      _imageList.clear();
      _imageIndex = -1;
      notifyListeners();
    }
  }

  void undo() {
    if (canUndo) {
      _imageIndex = max(-1, min(_imageList.length - 1, _imageIndex - 1));
      notifyListeners();
    }
  }

  void redo() {
    if (canRedo) {
      _imageIndex = max(-1, min(_imageList.length - 1, _imageIndex + 1));
      notifyListeners();
    }
  }

  void join(ui.Image image) {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    this.image?.let((it) {
      canvas.drawImage(it, Offset.zero, Paint());
    });
  }

  void _pushImage(ui.Image image) {
    _imageList.add(image);
    _imageIndex = max(-1, _imageList.length - 1);
    notifyListeners();
  }

  // ---------- 绘图管理 ----------
  bool _paused = false;

  Path? _currentPath;
  ui.Offset? _currentPosition;
  ui.PictureRecorder? _currentPictureRecorder;
  Canvas? _currentCanvas;

  void pause() => _paused = true;

  void resume() => _paused = false;

  @internal
  void onPanDown(DragDownDetails details) {
    if (_paused) return;
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
    if (_paused) return;
    _currentPath?.lineTo(details.localPosition.dx, details.localPosition.dy);
    _currentPosition = details.localPosition;
    notifyListeners();
  }

  @internal
  void onPanEnd({required Size? containerSize}) {
    if (_paused) {
      _currentPath = null;
      _currentPosition = null;
      _currentPictureRecorder = null;
      _currentCanvas = null;
    } else {
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
  }

  @override
  void dispose() {
    try {
      paint.dispose();
      for (final image in _imageList) {
        image.dispose();
      }
    } finally {
      super.dispose();
    }
  }
}

class DrawingBoardPaint extends ChangeNotifier {
  final Paint _paint;

  DrawingBoardPaint(this._paint);

  double get strokeWidth => _paint.strokeWidth;

  set strokeWidth(double value) {
    _paint.strokeWidth = value;
    notifyListeners();
  }

  Color get color => _paint.color;

  set color(Color value) {
    _paint.color = value;
    notifyListeners();
  }

  PaintingStyle get style => _paint.style;

  set style(PaintingStyle value) {
    _paint.style = value;
    notifyListeners();
  }

  StrokeCap get strokeCap => _paint.strokeCap;

  set strokeCap(StrokeCap value) {
    _paint.strokeCap = value;
    notifyListeners();
  }

  BlendMode get blendMode => _paint.blendMode;

  set blendMode(BlendMode value) {
    _paint.blendMode = value;
    notifyListeners();
  }

  bool get isAntiAlias => _paint.isAntiAlias;

  set isAntiAlias(bool value) {
    _paint.isAntiAlias = value;
    notifyListeners();
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
