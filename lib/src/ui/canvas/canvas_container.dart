import 'dart:math';

import 'package:flutter/material.dart';

import 'adjust_boundary.dart';
import 'canvas_container_controller.dart';

class CanvasContainer extends StatelessWidget {
  final CanvasContainerController controller;
  final Widget child;
  final bool autoScale;
  final EdgeInsets padding;
  final AdjustBoundaryStyle adjustBoundaryStyle;

  late final Size _minBoundarySize;

  CanvasContainer({
    super.key,
    required this.controller,
    required this.child,
    this.autoScale = false,
    this.padding = const EdgeInsets.all(20),
    this.adjustBoundaryStyle = const AdjustBoundaryStyle(),
  }) {
    _minBoundarySize = Size(adjustBoundaryStyle.boundaryLength * 2,
        adjustBoundaryStyle.boundaryLength * 2);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerSize = constraints.biggest;
        final layoutSize = Size(containerSize.width - padding.horizontal,
            containerSize.height - padding.vertical);
        controller.adjustBoundaryExtension.boundary =
            Rect.fromLTWH(0, 0, layoutSize.width, layoutSize.height);
        return ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final rotationAngle = controller.rotation * (pi / 180);
            return Transform.rotate(
              angle: rotationAngle,
              child: Transform.scale(
                scale: autoScale
                    ? min(
                        _calculateAutoScale(
                          parentSize: containerSize,
                          childSize: containerSize,
                          rotationAngle: rotationAngle,
                        ),
                        controller.scale,
                      )
                    : controller.scale,
                child: GestureDetector(
                  onPanDown: (details) {
                    final position = details.localPosition
                        .translate(-padding.left, -padding.top);
                    if (controller.adjustBoundaryEnabled) {
                      controller.adjustBoundaryExtension.onPanDown(position);
                    }
                  },
                  onPanUpdate: (details) {
                    if (controller.adjustBoundaryEnabled) {
                      controller.adjustBoundaryExtension.onPanUpdate(
                        delta: details.delta,
                        layoutSize: layoutSize,
                        minBoundarySize: _minBoundarySize,
                      );
                    }
                  },
                  onPanEnd: (details) {
                    if (controller.adjustBoundaryEnabled) {
                      controller.adjustBoundaryExtension.onPanEnd();
                    }
                  },
                  onPanCancel: () {
                    if (controller.adjustBoundaryEnabled) {
                      controller.adjustBoundaryExtension.onPanEnd();
                    }
                  },
                  child: Padding(
                    padding: padding,
                    child: SizedBox.expand(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          child,
                          if (controller.adjustBoundaryEnabled)
                            AdjustBoundary(
                              extension: controller.adjustBoundaryExtension,
                              style: adjustBoundaryStyle,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  double _calculateAutoScale({
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
