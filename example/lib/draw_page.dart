import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class DrawPage extends StatefulWidget {
  const DrawPage({super.key});

  @override
  State<StatefulWidget> createState() => _DrawState();
}

enum _AspectRation { free, r1_1, r16_9, r9_16 }

class _DrawState extends State<DrawPage> {
  late final CanvasContainerController controller;

  _AspectRation aspectRatio = _AspectRation.free;

  @override
  void initState() {
    super.initState();
    controller = CanvasContainerController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Draw Page'),
          actions: [
            Builder(
              builder: (context) {
                if (controller.drawingBoardEnabled) {
                  return IconButton.filled(
                    onPressed: () {
                      controller.drawingBoardEnabled = false;
                    },
                    color: theme.colorScheme.onPrimary,
                    icon: const Icon(Icons.draw),
                  );
                } else {
                  return IconButton(
                    onPressed: () {
                      controller.drawingBoardEnabled = true;
                    },
                    icon: const Icon(Icons.draw),
                  );
                }
              },
            ),
            Builder(
              builder: (context) {
                if (controller.adjustBoundaryEnabled) {
                  return IconButton.filled(
                    onPressed: () {
                      controller.adjustBoundaryEnabled = false;
                    },
                    color: theme.colorScheme.onPrimary,
                    icon: const Icon(Icons.crop),
                  );
                } else {
                  return IconButton(
                    onPressed: () {
                      controller.adjustBoundaryEnabled = true;
                    },
                    icon: const Icon(Icons.crop),
                  );
                }
              },
            ),
            PopupMenuButton(
              position: PopupMenuPosition.under,
              itemBuilder: (context) => <PopupMenuEntry>[
                if (controller.drawingBoardEnabled)
                  PopupMenuItem(
                    child: const Text("上一步"),
                    onTap: () async {
                      if (controller.drawingBoardExtension.canUndo) {
                        controller.drawingBoardExtension.undo();
                      } else {
                        Toast.showShort(context, "没有上一步!");
                      }
                    },
                  ),
                if (controller.drawingBoardEnabled) const PopupMenuDivider(),
                if (controller.drawingBoardEnabled)
                  PopupMenuItem(
                    child: const Text("下一步"),
                    onTap: () async {
                      if (controller.drawingBoardExtension.canRedo) {
                        controller.drawingBoardExtension.redo();
                      } else {
                        Toast.showShort(context, "没有下一步!");
                      }
                    },
                  ),
                if (controller.drawingBoardEnabled) const PopupMenuDivider(),
                if (controller.drawingBoardEnabled)
                  PopupMenuItem(
                    child: const Text("橡皮檫"),
                    onTap: () async {
                      if (controller.drawingBoardExtension.paint.blendMode !=
                          BlendMode.clear) {
                        controller.drawingBoardExtension.paint.blendMode =
                            BlendMode.clear;
                        Toast.showShort(context, "橡皮檫已打开!");
                      } else {
                        controller.drawingBoardExtension.paint.blendMode =
                            BlendMode.srcOver;
                        Toast.showShort(context, "橡皮檫已关闭!");
                      }
                    },
                  ),
                if (controller.drawingBoardEnabled) const PopupMenuDivider(),
                PopupMenuItem(
                  child: const Text("导出"),
                  onTap: () async {
                    final image = controller.drawingBoardExtension.export();
                    if (image == null) return;
                    final bytes =
                        await image.toByteData(format: ImageByteFormat.png);
                    if (bytes == null) return;
                    final file = await StorageFile(
                            StorageType.cache, "${UuidHelper.v4()}.png")
                        .file;
                    file.writeAsBytes(bytes.buffer.asInt8List(), flush: true);
                    GallerySavePlugin.saveImage(file).then((_) {
                      if (context.mounted) {
                        Toast.showShort(context, "导出成功!");
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Column(
              children: [
                Expanded(
                  child: CanvasContainer(
                    controller: controller,
                    builder: (context, constraints) => CanvasContainerChild(
                      size: constraints.biggest,
                      child: Container(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text("Rotate: ${controller.rotation ?? 0}"),
                        Expanded(
                          child: Slider(
                            min: 0,
                            max: 359,
                            value: controller.rotation?.toDouble() ?? 0,
                            onChanged: (value) {
                              final rotation = value.toInt();
                              if (rotation != 0) {
                                controller.rotation = rotation;
                              } else {
                                controller.rotation = null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                            "Scale: ${FormatHelper.printNum(controller.scale ?? 0, maxFractionDigits: 1)}"),
                        Expanded(
                          child: Slider(
                            min: 0,
                            max: 3,
                            value: controller.scale ?? 0,
                            onChanged: (value) {
                              if (value > 0) {
                                controller.scale = value;
                              } else {
                                controller.scale = null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    if (controller.drawingBoardEnabled)
                      Row(
                        children: [
                          Text(
                              "Paint Width: ${controller.drawingBoardExtension.paint.strokeWidth.toInt()}"),
                          Expanded(
                            child: Slider(
                              min: 0,
                              max: 20,
                              value: controller
                                  .drawingBoardExtension.paint.strokeWidth,
                              onChanged: (value) {
                                setState(() {
                                  controller.drawingBoardExtension.paint
                                      .strokeWidth = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    if (controller.adjustBoundaryEnabled)
                      Row(
                        children: [
                          const Text("Aspect Ration: "),
                          Expanded(
                              child: Wrap(
                            children: [
                              TextButton(
                                onPressed: () {
                                  controller.adjustBoundaryExtension
                                      .aspectRatio = null;
                                  setState(() {
                                    aspectRatio = _AspectRation.free;
                                  });
                                },
                                style: ButtonStyle(
                                  foregroundColor: WidgetStatePropertyAll(
                                      aspectRatio == _AspectRation.free
                                          ? theme.colorScheme.primary
                                          : Colors.grey),
                                ),
                                child: const Text("free"),
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.adjustBoundaryExtension
                                      .aspectRatio = 1 / 1;
                                  setState(() {
                                    aspectRatio = _AspectRation.r1_1;
                                  });
                                },
                                style: ButtonStyle(
                                  foregroundColor: WidgetStatePropertyAll(
                                      aspectRatio == _AspectRation.r1_1
                                          ? theme.colorScheme.primary
                                          : Colors.grey),
                                ),
                                child: const Text("1:1"),
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.adjustBoundaryExtension
                                      .aspectRatio = 16 / 9;
                                  setState(() {
                                    aspectRatio = _AspectRation.r16_9;
                                  });
                                },
                                style: ButtonStyle(
                                  foregroundColor: WidgetStatePropertyAll(
                                      aspectRatio == _AspectRation.r16_9
                                          ? theme.colorScheme.primary
                                          : Colors.grey),
                                ),
                                child: const Text("16:9"),
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.adjustBoundaryExtension
                                      .aspectRatio = 9 / 16;
                                  setState(() {
                                    aspectRatio = _AspectRation.r9_16;
                                  });
                                },
                                style: ButtonStyle(
                                  foregroundColor: WidgetStatePropertyAll(
                                      aspectRatio == _AspectRation.r9_16
                                          ? theme.colorScheme.primary
                                          : Colors.grey),
                                ),
                                child: const Text("9:16"),
                              ),
                            ],
                          )),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
