import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scaffold/scaffold_lang.dart';

import 'adjust_boundary.dart';
import 'canvas_container_controller.dart';
import 'drawing_board.dart';

class CanvasContainer extends StatelessWidget {
  final CanvasContainerController controller;
  final CanvasContainerChild Function(BuildContext, BoxConstraints) builder;
  final DrawingBoardStyle drawingBoardStyle;
  final AdjustBoundaryStyle adjustBoundaryStyle;
  final PointerDownEventListener? onPointerDown;
  final PointerMoveEventListener? onPointerMove;
  final PointerUpEventListener? onPointerUp;
  final PointerCancelEventListener? onPointerCancel;

  const CanvasContainer({
    super.key,
    required this.controller,
    required this.builder,
    this.drawingBoardStyle = const DrawingBoardStyle(),
    this.adjustBoundaryStyle = const AdjustBoundaryStyle(),
    this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
    this.onPointerCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onScaleStart: (details) {
        controller.onScaleStartByContainer(details);
      },
      onScaleUpdate: (details) {
        controller.onScaleUpdateByContainer(details);
      },
      onScaleEnd: (details) {
        controller.onScaleEndByContainer(details);
      },
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final containerSize = constraints.biggest;
            final containerChild = builder(context, constraints);
            controller.dispatchAttach(
              containerSize: containerSize,
              containerChildSize: containerChild.size,
            );
            return ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                final transform = Matrix4.identity();
                controller.translate?.also((it) {
                  transform.translate(it.dx, it.dy);
                });
                controller.rotation?.also((it) {
                  transform.rotateZ(it * (pi / 180));
                });
                controller.scale?.also((it) {
                  transform.scale(it);
                });
                return Transform(
                  transform: transform,
                  alignment: Alignment.center,
                  child: Listener(
                    behavior: HitTestBehavior.translucent,
                    onPointerDown: (event) {
                      controller.onPointerDownByChild(event);
                      onPointerDown?.call(event);
                    },
                    onPointerMove: (event) {
                      controller.onPointerMoveByChild(event);
                      onPointerMove?.call(event);
                    },
                    onPointerUp: (event) {
                      controller.onPointerUpByChild(event);
                      onPointerUp?.call(event);
                    },
                    onPointerCancel: (event) {
                      controller.onPointerCancelByChild(event);
                      onPointerCancel?.call(event);
                    },
                    child: Center(
                      child: SizedBox.fromSize(
                        size: containerChild.size,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            containerChild.child,
                            if (controller.drawingBoardEnabled)
                              DrawingBoard(
                                extension: controller.drawingBoardExtension,
                                style: drawingBoardStyle,
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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
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
