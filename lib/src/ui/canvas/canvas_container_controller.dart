import 'package:flutter/foundation.dart';

import 'adjust_boundary.dart';

class CanvasContainerController extends ChangeNotifier {
  late final AdjustBoundaryExtension adjustBoundaryExtension;

  CanvasContainerController({
    AdjustBoundaryExtension? adjustBoundaryExtension,
  }) {
    this.adjustBoundaryExtension =
        adjustBoundaryExtension ?? AdjustBoundaryExtension();
  }

  bool _adjustBoundaryEnabled = false;

  int _rotation = 0;
  double _scale = 1;

  bool get adjustBoundaryEnabled => _adjustBoundaryEnabled;

  int get rotation => _rotation;

  double get scale => _scale;

  set adjustBoundaryEnabled(bool value) {
    if (_adjustBoundaryEnabled != value) {
      _adjustBoundaryEnabled = value;
      notifyListeners();
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

  @override
  void dispose() {
    adjustBoundaryExtension.dispose();
    super.dispose();
  }
}
