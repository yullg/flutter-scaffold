import 'adjust_boundary_extension.dart';
import 'canvas_container_extension.dart';
import 'drawing_board_extension.dart';

abstract interface class CanvasContainerControllerExtensions {
  CanvasContainerExtension get canvasContainerExtension;

  DrawingBoardExtension get drawingBoardExtension;

  AdjustBoundaryExtension get adjustBoundaryExtension;
}
