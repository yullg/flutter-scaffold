import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scaffold/scaffold_lang.dart';

import 'adjust_boundary.dart';
import 'canvas_container_controller.dart';
import 'drawing_board.dart';

class CanvasContainer extends StatelessWidget {
  final CanvasContainerController controller;
  final CanvasContainerChild Function(BuildContext, BoxConstraints) builder;
  final AlignmentGeometry alignment;
  final AdjustBoundaryStyle adjustBoundaryStyle;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleUpdateCallback? onScaleUpdate;
  final GestureScaleEndCallback? onScaleEnd;

  const CanvasContainer({
    super.key,
    required this.controller,
    required this.builder,
    this.alignment = Alignment.center,
    this.adjustBoundaryStyle = const AdjustBoundaryStyle(),
    this.onTapDown,
    this.onTapUp,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final biggestSize = constraints.biggest;
          final canvasContainerChild = builder(context, constraints);
          controller.initialize(containerSize: canvasContainerChild.size);
          return ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final transform = Matrix4.identity();
              controller.rotation?.also((it) {
                transform.rotateZ(it * (pi / 180));
              });
              controller.translate?.also((it) {
                transform.translate(it.dx, it.dy);
              });
              final scale = controller.scale ??
                  _calculateAutoScale(
                    parentSize: biggestSize,
                    childSize: canvasContainerChild.size,
                    rotationAngle: (controller.rotation ?? 0) * (pi / 180),
                  );
              transform.scale(scale);
              return Transform(
                transform: transform,
                alignment: Alignment.center,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) {
                    onTapDown?.call(details);
                  },
                  onTapUp: (details) {
                    onTapUp?.call(details);
                  },
                  onScaleStart: (details) {
                    controller.onScaleStart(details);
                    onScaleStart?.call(details);
                  },
                  onScaleUpdate: (details) {
                    controller.onScaleUpdate(details);
                    onScaleUpdate?.call(details);
                  },
                  onScaleEnd: (details) {
                    controller.onScaleEnd(details);
                    onScaleEnd?.call(details);
                  },
                  child: SizedBox.fromSize(
                    size: canvasContainerChild.size,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        canvasContainerChild.child,
                        if (controller.drawingBoardEnabled)
                          DrawingBoard(
                            extension: controller.drawingBoardExtension,
                          ),
                        if (controller.adjustBoundaryEnabled)
                          AdjustBoundary(
                            extension: controller.adjustBoundaryExtension,
                            style: adjustBoundaryStyle,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  double _calculateAutoScale({
    required Size parentSize,
    required Size childSize,
    required double rotationAngle,
  }) {
    if (parentSize.isFinite && childSize.isFinite && rotationAngle.isFinite) {
      // 旋转后的子widget最大宽高
      double rotatedWidth = (childSize.width * cos(rotationAngle)).abs() +
          (childSize.height * sin(rotationAngle)).abs();
      double rotatedHeight = (childSize.height * cos(rotationAngle)).abs() +
          (childSize.width * sin(rotationAngle)).abs();
      if (rotatedWidth > 0 && rotatedHeight > 0) {
        // 计算缩放比例，使子widget在旋转后不超出父widget
        double scaleWidth = parentSize.width / rotatedWidth;
        double scaleHeight = parentSize.height / rotatedHeight;
        // 取最小缩放比例，确保在任意旋转角度下子widget都不会超出父widget
        return min(scaleWidth, scaleHeight);
      }
    }
    return 1;
  }
}

class CanvasContainerChild {
  final Size size;
  final Widget child;

  CanvasContainerChild({
    required this.size,
    required this.child,
  }) {
    if (!size.isFinite) {
      throw ArgumentError("Size must be finite");
    }
  }

  CanvasContainerChild.contain({
    required Size boxSize,
    required Size childSize,
    required this.child,
  }) : size = _calculateSize(boxSize, childSize);

  static Size _calculateSize(Size boxSize, Size childSize) {
    if (!boxSize.isFinite) {
      throw ArgumentError("BoxSize must be finite");
    }
    if (!childSize.isFinite) {
      throw ArgumentError("ChildSize must be finite");
    }
    final boxAspectRatio = boxSize.width / boxSize.height;
    final childAspectRatio = childSize.width / childSize.height;
    final scale = childAspectRatio > boxAspectRatio
        ? boxSize.width / childSize.width
        : boxSize.height / childSize.height;
    return Size(childSize.width * scale, childSize.height * scale);
  }
}
