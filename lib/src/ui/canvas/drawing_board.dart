import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:scaffold/scaffold_lang.dart';

import 'canvas_container_aware.dart';

class DrawingBoardExtension extends ChangeNotifier with CanvasContainerAware {
  final paint = DrawingBoardPaint();

  // ---------- 历史快照管理 ----------
  final _imageList = <ui.Image>[];
  int _imageIndex = -1;

  ui.Image? get _image {
    if (_imageIndex >= 0 && _imageIndex < _imageList.length) {
      return _imageList[_imageIndex];
    } else {
      return null;
    }
  }

  bool get canUndo => _imageIndex >= 0;

  bool get canRedo => _imageIndex < _imageList.length - 1;

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

  void erase() {
    if (_imageList.isNotEmpty) {
      for (final image in _imageList) {
        image.dispose();
      }
      _imageList.clear();
      _imageIndex = -1;
      notifyListeners();
    }
  }

  void push(
    ui.Image image, {
    BoxFit? fit,
    Alignment alignment = Alignment.center,
  }) {
    final containerChildSize = requiredContainerChildSize;
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    canvas.scale(_kImageCanvasScale);
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, containerChildSize.width.toDouble(),
          containerChildSize.height.toDouble()),
      image: image,
      fit: fit,
      alignment: alignment,
    );
    final picture = pictureRecorder.endRecording();
    try {
      final mergedImage = picture.toImageSync(
          (containerChildSize.width * _kImageCanvasScale).floor(),
          (containerChildSize.height * _kImageCanvasScale).floor());
      _addImage(mergedImage);
    } finally {
      picture.dispose();
    }
  }

  void merge(
    ui.Image image, {
    BoxFit? fit,
    Alignment alignment = Alignment.center,
  }) {
    final containerChildSize = requiredContainerChildSize;
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    _image?.let((it) {
      canvas.drawImage(it, Offset.zero, Paint());
    });
    canvas.scale(_kImageCanvasScale);
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, containerChildSize.width.toDouble(),
          containerChildSize.height.toDouble()),
      image: image,
      fit: fit,
      alignment: alignment,
    );
    final picture = pictureRecorder.endRecording();
    try {
      final mergedImage = picture.toImageSync(
          (containerChildSize.width * _kImageCanvasScale).floor(),
          (containerChildSize.height * _kImageCanvasScale).floor());
      _addImage(mergedImage);
    } finally {
      picture.dispose();
    }
  }

  ui.Image? export() => _image?.clone();

  void _addImage(ui.Image image) {
    _imageList.add(image);
    _imageIndex = max(-1, _imageList.length - 1);
    notifyListeners();
  }

  // ---------- 绘图管理 ----------
  bool _paused = false;

  int? _currentPointer;
  Path? _currentPath;
  ui.Offset? _currentPosition;

  bool get isPaused => _paused;

  void pause() => _paused = true;

  void resume() => _paused = false;

  @internal
  void onPointerDownByChild(PointerDownEvent event) {
    if (_paused) return;
    final pos = calculateContainerChildOffset(event.localPosition);
    _currentPointer = event.pointer;
    _currentPath = Path()..moveTo(pos.dx, pos.dy);
    _currentPosition = pos;
    notifyListeners();
  }

  @internal
  void onPointerMoveByChild(PointerMoveEvent event) {
    if (_paused) return;
    if (_currentPointer != event.pointer) return;
    final pos = calculateContainerChildOffset(event.localPosition);
    _currentPath?.lineTo(pos.dx, pos.dy);
    _currentPosition = pos;
    notifyListeners();
  }

  @internal
  void onPointerUpByChild(PointerUpEvent event) {
    if (_currentPointer != event.pointer) return;
    try {
      final currentPath = _currentPath;
      if (currentPath != null) {
        final containerChildSize = requiredContainerChildSize;
        final pictureRecorder = ui.PictureRecorder();
        final canvas = Canvas(pictureRecorder);
        _image?.let((it) {
          canvas.drawImage(it, Offset.zero, Paint());
        });
        canvas.scale(_kImageCanvasScale);
        canvas.drawPath(currentPath, paint._paint);
        final picture = pictureRecorder.endRecording();
        try {
          final mergedImage = picture.toImageSync(
              (containerChildSize.width * _kImageCanvasScale).floor(),
              (containerChildSize.height * _kImageCanvasScale).floor());
          _addImage(mergedImage);
        } finally {
          picture.dispose();
        }
      }
    } finally {
      _currentPointer = null;
      _currentPath = null;
      _currentPosition = null;
    }
  }

  @internal
  void onPointerCancelByChild(PointerCancelEvent event) {
    _currentPointer = null;
    _currentPath = null;
    _currentPosition = null;
    notifyListeners();
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
  final _paint = Paint();

  DrawingBoardPaint() {
    _paint.style = PaintingStyle.stroke;
    _paint.strokeCap = StrokeCap.round;
    _paint.strokeJoin = StrokeJoin.round;
    _paint.isAntiAlias = true;
    _paint.strokeWidth = 8;
  }

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
            image: extension._image,
            path: extension._currentPath,
            ringPosition: extension._currentPosition,
            pathPaint: extension.paint._paint,
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

const double _kImageCanvasScale = 4;
