import 'dart:math';

import 'package:flutter/material.dart';

import 'adjust_boundary.dart';
import 'canvas_container_controller.dart';

class CanvasContainer extends StatelessWidget {
  final CanvasContainerController controller;
  final Widget child;
  final bool autoScale;
  final AdjustBoundaryStyle adjustBoundaryStyle;

  const CanvasContainer({
    super.key,
    required this.controller,
    required this.child,
    this.autoScale = false,
    this.adjustBoundaryStyle = const AdjustBoundaryStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxLayoutSize = constraints.biggest;
        controller.containerSize = maxLayoutSize;
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
                          parentSize: maxLayoutSize,
                          childSize: maxLayoutSize,
                          rotationAngle: rotationAngle,
                        ),
                        controller.scale,
                      )
                    : controller.scale,
                child: GestureDetector(
                  onPanDown: (details) => _onPanDown(
                    details: details,
                    containerSize: maxLayoutSize,
                  ),
                  onPanUpdate: (details) => _onPanUpdate(
                    details: details,
                    containerSize: maxLayoutSize,
                  ),
                  onPanEnd: (details) => _onPanEnd(
                    details: details,
                    containerSize: maxLayoutSize,
                  ),
                  onPanCancel: () => _onPanCancel(
                    containerSize: maxLayoutSize,
                  ),
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

  void _onPanDown({
    required DragDownDetails details,
    required Size containerSize,
  }) {
    if (controller.adjustBoundaryEnabled) {
      final Offset pos = details.localPosition;
      final boundary = controller.adjustBoundaryExtension.boundary;
      AdjustBoundaryMode? newAdjustBoundaryMode;
      if (boundary.contains(pos)) {
        newAdjustBoundaryMode = AdjustBoundaryMode.inside;
        // CORNERS
        if (_expandedPosition(boundary.topLeft).contains(pos)) {
          newAdjustBoundaryMode = AdjustBoundaryMode.leftTop;
        } else if (_expandedPosition(boundary.topRight).contains(pos)) {
          newAdjustBoundaryMode = AdjustBoundaryMode.rightTop;
        } else if (_expandedPosition(boundary.bottomRight).contains(pos)) {
          newAdjustBoundaryMode = AdjustBoundaryMode.rightBottom;
        } else if (_expandedPosition(boundary.bottomLeft).contains(pos)) {
          newAdjustBoundaryMode = AdjustBoundaryMode.leftBottom;
        } else if (controller.adjustBoundaryExtension.aspectRatio == null) {
          // CENTERS
          if (_expandedPosition(boundary.centerLeft).contains(pos)) {
            newAdjustBoundaryMode = AdjustBoundaryMode.leftCenter;
          } else if (_expandedPosition(boundary.topCenter).contains(pos)) {
            newAdjustBoundaryMode = AdjustBoundaryMode.topCenter;
          } else if (_expandedPosition(boundary.centerRight).contains(pos)) {
            newAdjustBoundaryMode = AdjustBoundaryMode.rightCenter;
          } else if (_expandedPosition(boundary.bottomCenter).contains(pos)) {
            newAdjustBoundaryMode = AdjustBoundaryMode.bottomCenter;
          }
        }
        controller.adjustBoundaryExtension.adjustBoundaryMode =
            newAdjustBoundaryMode;
      }
    }
  }

  void _onPanUpdate({
    required DragUpdateDetails details,
    required Size containerSize,
  }) {
    if (controller.adjustBoundaryEnabled) {
      final adjustBoundaryMode =
          controller.adjustBoundaryExtension.adjustBoundaryMode;
      if (adjustBoundaryMode == null) return;
      final boundary = controller.adjustBoundaryExtension.boundary;
      final Offset delta = details.delta;
      switch (adjustBoundaryMode) {
        case AdjustBoundaryMode.inside:
          final Offset pos = boundary.topLeft + delta;
          controller.adjustBoundaryExtension.boundary = Rect.fromLTWH(
              pos.dx.clamp(0, containerSize.width - boundary.width),
              pos.dy.clamp(0, containerSize.height - boundary.height),
              boundary.width,
              boundary.height);
          break;
        //CORNERS
        case AdjustBoundaryMode.leftTop:
          final Offset pos = boundary.topLeft + delta;
          _adjustBoundary(
            containerSize: containerSize,
            adjustBoundaryMode: AdjustBoundaryMode.leftTop,
            left: pos.dx,
            top: pos.dy,
          );
          break;
        case AdjustBoundaryMode.rightTop:
          final Offset pos = boundary.topRight + delta;
          _adjustBoundary(
            containerSize: containerSize,
            adjustBoundaryMode: AdjustBoundaryMode.rightTop,
            right: pos.dx,
            top: pos.dy,
          );
          break;
        case AdjustBoundaryMode.rightBottom:
          final Offset pos = boundary.bottomRight + delta;
          _adjustBoundary(
            containerSize: containerSize,
            adjustBoundaryMode: AdjustBoundaryMode.rightBottom,
            right: pos.dx,
            bottom: pos.dy,
          );
          break;
        case AdjustBoundaryMode.leftBottom:
          final Offset pos = boundary.bottomLeft + delta;
          _adjustBoundary(
            containerSize: containerSize,
            adjustBoundaryMode: AdjustBoundaryMode.leftBottom,
            left: pos.dx,
            bottom: pos.dy,
          );
          break;
        //CENTERS
        case AdjustBoundaryMode.topCenter:
          _adjustBoundary(
            containerSize: containerSize,
            adjustBoundaryMode: AdjustBoundaryMode.topCenter,
            top: boundary.top + delta.dy,
          );
          break;
        case AdjustBoundaryMode.bottomCenter:
          _adjustBoundary(
            containerSize: containerSize,
            adjustBoundaryMode: AdjustBoundaryMode.bottomCenter,
            bottom: boundary.bottom + delta.dy,
          );
          break;
        case AdjustBoundaryMode.leftCenter:
          _adjustBoundary(
            containerSize: containerSize,
            adjustBoundaryMode: AdjustBoundaryMode.leftCenter,
            left: boundary.left + delta.dx,
          );
          break;
        case AdjustBoundaryMode.rightCenter:
          _adjustBoundary(
            containerSize: containerSize,
            adjustBoundaryMode: AdjustBoundaryMode.rightCenter,
            right: boundary.right + delta.dx,
          );
          break;
      }
    }
  }

  void _onPanEnd({
    required DragEndDetails details,
    required Size containerSize,
  }) {
    _stopAdjustBoundary();
  }

  void _onPanCancel({
    required Size containerSize,
  }) {
    _stopAdjustBoundary();
  }

  void _adjustBoundary({
    required Size containerSize,
    required AdjustBoundaryMode adjustBoundaryMode,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    final boundary = controller.adjustBoundaryExtension.boundary;
    final aspectRatio = controller.adjustBoundaryExtension.aspectRatio;
    top = max(0, top ?? boundary.top);
    left = max(0, left ?? boundary.left);
    right = min(containerSize.width, right ?? boundary.right);
    bottom = min(containerSize.height, bottom ?? boundary.bottom);
    // update crop height or width to adjust to the selected aspect ratio
    if (aspectRatio != null) {
      final width = right - left;
      final height = bottom - top;

      if (width / height > aspectRatio) {
        switch (adjustBoundaryMode) {
          case AdjustBoundaryMode.leftTop:
          case AdjustBoundaryMode.leftBottom:
            left = right - height * aspectRatio;
            break;
          case AdjustBoundaryMode.rightTop:
          case AdjustBoundaryMode.rightBottom:
            right = left + height * aspectRatio;
            break;
          default:
            break;
        }
      } else {
        switch (adjustBoundaryMode) {
          case AdjustBoundaryMode.leftTop:
          case AdjustBoundaryMode.rightTop:
            top = bottom - width / aspectRatio;
            break;
          case AdjustBoundaryMode.leftBottom:
          case AdjustBoundaryMode.rightBottom:
            bottom = top + width / aspectRatio;
            break;
          default:
            assert(false);
        }
      }
    }
    final newRect = Rect.fromLTRB(left, top, right, bottom);
    // don't apply changes if out of bounds
    if (newRect.width < adjustBoundaryStyle.boundaryLength * 2 ||
        newRect.height < adjustBoundaryStyle.boundaryLength * 2 ||
        !_isRectContained(containerSize, newRect)) {
      return;
    }
    controller.adjustBoundaryExtension.boundary = newRect;
  }

  void _stopAdjustBoundary() {
    if (controller.adjustBoundaryEnabled) {
      controller.adjustBoundaryExtension.adjustBoundaryMode = null;
    }
  }

  Rect _expandedPosition(Offset position) =>
      Rect.fromCenter(center: position, width: 48, height: 48);

  bool _isRectContained(Size size, Rect rect) =>
      rect.left >= 0 &&
      rect.top >= 0 &&
      rect.right <= size.width &&
      rect.bottom <= size.height;
}
