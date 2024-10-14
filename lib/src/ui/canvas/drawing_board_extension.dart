import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:scaffold/scaffold_lang.dart';

import 'canvas_container_controller_extensions.dart';

class DrawingBoardExtension extends ChangeNotifier {
  final CanvasContainerControllerExtensions _extensions;
  final paint = DrawingBoardPaint();

  DrawingBoardExtension({
    required CanvasContainerControllerExtensions extensions,
  }) : _extensions = extensions;

  // ---------- 历史快照管理 ----------
  final _imageList = <ui.Image>[];
  int _imageIndex = -1;

  @internal
  ui.Image? get image {
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

  ui.Image? export() => image?.clone();

  void push(
    ui.Image image, {
    BoxFit? fit,
    Alignment alignment = Alignment.center,
    BlendMode blendMode = BlendMode.srcOver,
  }) {
    final containerChildSize =
        _extensions.canvasContainerExtension.requiredContainerChildSize;
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    this.image?.let((it) {
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
      blendMode: blendMode,
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

  void _addImage(ui.Image image) {
    _imageList.add(image);
    _imageIndex = _imageList.length - 1;
    notifyListeners();
  }

  // ---------- 绘图管理 ----------
  bool _paused = false;
  Path? _inUsePath;
  Offset? _inUsePosition;
  int? _inUsePointer;
  int? _lastPointer;

  bool get isPaused => _paused;

  void pause() => _paused = true;

  void resume() => _paused = false;

  @internal
  Path? get inUsePath => _inUsePath;

  @internal
  Offset? get inUsePosition => _inUsePosition;

  @internal
  void onPointerDown(PointerDownEvent event) {
    if (isPaused) return;
    _lastPointer = event.pointer;
    if (_inUsePointer == null) {
      _inUsePointer = event.pointer;
      final pos = _extensions.canvasContainerExtension
          .containerChildOffset(event.localPosition);
      _inUsePath = Path()..moveTo(pos.dx, pos.dy);
      _inUsePosition = pos;
      notifyListeners();
    }
  }

  @internal
  void onPointerMove(PointerMoveEvent event) {
    if (isPaused) return;
    if (_inUsePointer != event.pointer || _inUsePointer != _lastPointer) return;
    final pos = _extensions.canvasContainerExtension
        .containerChildOffset(event.localPosition);
    _inUsePath?.lineTo(pos.dx, pos.dy);
    _inUsePosition = pos;
    notifyListeners();
  }

  @internal
  void onPointerUp(PointerUpEvent event) {
    if (_inUsePointer != event.pointer) return;
    try {
      if (_inUsePointer == _lastPointer) {
        final path = _inUsePath;
        if (path != null) {
          final containerChildSize =
              _extensions.canvasContainerExtension.requiredContainerChildSize;
          final pictureRecorder = ui.PictureRecorder();
          final canvas = Canvas(pictureRecorder);
          image?.let((it) {
            canvas.drawImage(it, Offset.zero, Paint());
          });
          canvas.scale(_kImageCanvasScale);
          canvas.drawPath(path, paint.paint);
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
      }
    } finally {
      _inUsePath = null;
      _inUsePosition = null;
      _inUsePointer = null;
      notifyListeners();
    }
  }

  @internal
  void onPointerCancel(PointerCancelEvent event) {
    if (_inUsePointer != event.pointer) return;
    _inUsePath = null;
    _inUsePosition = null;
    _inUsePointer = null;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final image in _imageList) {
      image.dispose();
    }
    paint.dispose();
    super.dispose();
  }
}

class DrawingBoardPaint extends ChangeNotifier {
  @internal
  final paint = Paint();

  DrawingBoardPaint() {
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    paint.isAntiAlias = true;
    paint.strokeWidth = 8;
  }

  double get strokeWidth => paint.strokeWidth;

  set strokeWidth(double value) {
    if (paint.strokeWidth != value) {
      paint.strokeWidth = value;
      notifyListeners();
    }
  }

  Color get color => paint.color;

  set color(Color value) {
    if (paint.color != value) {
      paint.color = value;
      notifyListeners();
    }
  }

  BlendMode get blendMode => paint.blendMode;

  set blendMode(BlendMode value) {
    if (paint.blendMode != value) {
      paint.blendMode = value;
      notifyListeners();
    }
  }
}

const double _kImageCanvasScale = 4;
