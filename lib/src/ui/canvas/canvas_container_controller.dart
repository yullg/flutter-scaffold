import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'adjust_boundary.dart';

class CanvasContainerController extends ChangeNotifier {
  final adjustBoundaryExtension = AdjustBoundaryExtension();

  bool _adjustBoundaryEnabled = false;

  Size _containerSize = Size.zero;
  int _rotation = 0;
  double _scale = 1;

  bool get adjustBoundaryEnabled => _adjustBoundaryEnabled;

  Size get containerSize => _containerSize;

  int get rotation => _rotation;

  double get scale => _scale;

  set adjustBoundaryEnabled(bool value) {
    if (_adjustBoundaryEnabled != value) {
      _adjustBoundaryEnabled = value;
      notifyListeners();
    }
  }

  set containerSize(Size value) {
    if (_containerSize != value) {
      _containerSize = value;
      notifyListeners();
      adjustBoundaryExtension.boundary =
          Rect.fromLTWH(0, 0, value.width, value.height);
    }
  }

  set rotation(int value) {
    if (_rotation != value) {
      _rotation = value % 360;
      notifyListeners();
    }
  }

  set scale(double value) {
    if (_scale != value) {
      _scale = value;
      notifyListeners();
    }
  }

  void rotate(int degree) {
    degree = degree % 360;
    if (degree != 0) {
      _rotation = (_rotation + degree) % 360;
      notifyListeners();
    }
  }

  @protected
  void onPanDown(DragDownDetails details) {}

  @protected
  void onPanUpdate(DragUpdateDetails details) {}

  @protected
  void onPanEnd(DragEndDetails details) {}

  @protected
  void onPanCancel() {}

  @override
  void dispose() {
    adjustBoundaryExtension.dispose();
    super.dispose();
  }
}
