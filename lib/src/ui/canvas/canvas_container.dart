import 'dart:math';

import 'package:flutter/material.dart';

class CanvasContainerController extends ChangeNotifier {
  int _rotation = 0;

  int get rotation => _rotation;

  set rotation(int value) {
    _rotation = value % 360;
    notifyListeners();
  }

  void rotate(int degree) {
    degree = degree % 360;
    _rotation = (_rotation + degree) % 360;
    notifyListeners();
  }
}

class CanvasContainer extends StatelessWidget {
  final CanvasContainerController controller;
  final Widget child;
  final bool autoScale;

  const CanvasContainer({
    super.key,
    required this.controller,
    required this.child,
    this.autoScale = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxLayoutSize = constraints.biggest;
        return ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final rotationAngle = controller.rotation * (pi / 180);
            return Transform.rotate(
              angle: rotationAngle,
              child: Transform.scale(
                scale: autoScale
                    ? _calculateScale(
                        parentSize: maxLayoutSize,
                        childSize: maxLayoutSize,
                        rotationAngle: rotationAngle,
                      )
                    : 1,
                child: child,
              ),
            );
          },
        );
      },
    );
  }

  double _calculateScale({
    required Size parentSize,
    required Size childSize,
    required double rotationAngle,
  }) {
    // 旋转后的子widget最大宽高
    double rotatedWidth = (childSize.width * cos(rotationAngle)).abs() +
        (childSize.height * sin(rotationAngle)).abs();
    double rotatedHeight = (childSize.height * cos(rotationAngle)).abs() +
        (childSize.width * sin(rotationAngle)).abs();
    // 计算缩放比例，使子widget在旋转后不超出父widget
    double scaleWidth = parentSize.width / rotatedWidth;
    double scaleHeight = parentSize.height / rotatedHeight;
    // 取最小缩放比例，确保在任意旋转角度下子widget都不会超出父widget
    return min(scaleWidth, scaleHeight);
  }
}
