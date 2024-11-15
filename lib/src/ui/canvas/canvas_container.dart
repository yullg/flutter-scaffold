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
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final containerSize = constraints.biggest;
          final containerChild = builder(context, constraints);
          controller.attach(
            containerSize: containerSize,
            containerChildSize: containerChild.size,
          );
          return ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final drawingBoardEnabled = controller.drawingBoardEnabled;
              final adjustBoundaryEnabled = controller.adjustBoundaryEnabled;
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onScaleStart: (details) {
                  controller.onContainerScaleStart(details);
                },
                onScaleUpdate: (details) {
                  controller.onContainerScaleUpdate(details);
                },
                onScaleEnd: (details) {
                  controller.onContainerScaleEnd(details);
                },
                child: SizedBox.expand(
                  child: ListenableBuilder(
                    listenable: controller.canvasContainerExtension,
                    builder: (context, _) {
                      final transform = Matrix4.identity();
                      controller.canvasContainerExtension.translate?.also((it) {
                        transform.translate(it.dx, it.dy);
                      });
                      controller.canvasContainerExtension.rotation?.also((it) {
                        transform.rotateZ(it * (pi / 180));
                      });
                      controller.canvasContainerExtension.scale?.also((it) {
                        transform.scale(it);
                      });
                      return Transform(
                        transform: transform,
                        alignment: Alignment.center,
                        child: Listener(
                          behavior: HitTestBehavior.translucent,
                          onPointerDown: (event) {
                            controller.onChildPointerDown(event);
                            onPointerDown?.call(event);
                          },
                          onPointerMove: (event) {
                            controller.onChildPointerMove(event);
                            onPointerMove?.call(event);
                          },
                          onPointerUp: (event) {
                            controller.onChildPointerUp(event);
                            onPointerUp?.call(event);
                          },
                          onPointerCancel: (event) {
                            controller.onChildPointerCancel(event);
                            onPointerCancel?.call(event);
                          },
                          child: OverflowBox(
                            maxWidth: double.infinity,
                            maxHeight: double.infinity,
                            child: Center(
                              child: SizedBox.fromSize(
                                size: containerChild.size,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    containerChild.child,
                                    if (drawingBoardEnabled)
                                      DrawingBoard(
                                        extension:
                                            controller.drawingBoardExtension,
                                        style: drawingBoardStyle,
                                      ),
                                    if (adjustBoundaryEnabled)
                                      AdjustBoundary(
                                        extension:
                                            controller.adjustBoundaryExtension,
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
                  ),
                ),
              );
            },
          );
        },
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
  }) : size = _calculateContainSize(boxSize, childSize);

  CanvasContainerChild.cover({
    required Size boxSize,
    required Size childSize,
    required this.child,
  }) : size = _calculateCoverSize(boxSize, childSize);

  static Size _calculateContainSize(Size boxSize, Size childSize) {
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

  static Size _calculateCoverSize(Size boxSize, Size childSize) {
    if (!boxSize.isFinite) {
      throw ArgumentError("BoxSize must be finite");
    }
    if (!childSize.isFinite) {
      throw ArgumentError("ChildSize must be finite");
    }
    final scaleX = boxSize.width / childSize.width;
    final scaleY = boxSize.height / childSize.height;
    final scale = max(scaleX, scaleY);
    return Size(childSize.width * scale, childSize.height * scale);
  }
}
