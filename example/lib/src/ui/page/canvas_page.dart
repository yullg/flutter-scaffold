import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';
import 'package:scaffold/scaffold_lang.dart';

class CanvasPage extends StatefulWidget {
  const CanvasPage({super.key});

  @override
  State<StatefulWidget> createState() => _CanvasState();
}

class _CanvasState extends State<CanvasPage> {
  late final CanvasContainerController controller;

  @override
  void initState() {
    super.initState();
    controller = CanvasContainerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canvas Demo'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).showBottomSheet(
                  (context) => _CanvasSettingsWidget(controller: controller),
                  backgroundColor:
                      Theme.of(context).colorScheme.surface.withOpacity(0.7),
                  showDragHandle: true,
                  enableDrag: true,
                );
              },
              icon: const Icon(Icons.apps),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CanvasContainer(
          controller: controller,
          builder: (context, constraints) => CanvasContainerChild(
            size: constraints.biggest / 2,
            child: Container(
              color: Colors.blue,
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

class _CanvasSettingsWidget extends StatelessWidget {
  final CanvasContainerController controller;

  const _CanvasSettingsWidget({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (controller.drawingBoardEnabled)
                      FilledButton(
                        onPressed: () {
                          if (controller.drawingBoardExtension.canUndo) {
                            controller.drawingBoardExtension.undo();
                          } else {
                            Toast.showShort(context, "没有上一步!");
                          }
                        },
                        child: const Text("上一步"),
                      ),
                    if (controller.drawingBoardEnabled)
                      FilledButton(
                        onPressed: () {
                          if (controller.drawingBoardExtension.canRedo) {
                            controller.drawingBoardExtension.redo();
                          } else {
                            Toast.showShort(context, "没有下一步!");
                          }
                        },
                        child: const Text("下一步"),
                      ),
                    if (controller.drawingBoardEnabled)
                      FilledButton(
                        onPressed: () async {
                          final image =
                              controller.drawingBoardExtension.export();
                          if (image == null) return;
                          final bytes = await image.toByteData(
                              format: ImageByteFormat.png);
                          if (bytes == null) return;
                          final file = await StorageFile(
                                  StorageType.cache, "${UuidHelper.v4()}.png")
                              .file;
                          await file.writeAsBytes(bytes.buffer.asInt8List(),
                              flush: true);
                          GallerySavePlugin.saveImage(file).then((_) {
                            if (context.mounted) {
                              Toast.showShort(context, "导出成功!");
                            }
                          });
                        },
                        child: const Text("导出"),
                      ),
                  ],
                ),
              ),
              EasyListTile(
                nameText: "旋转",
                valueText:
                    controller.canvasContainerExtension.rotate?.toString() ??
                        "null",
                description: Slider(
                  min: 0,
                  max: 360,
                  value: controller.canvasContainerExtension.rotate
                          ?.toDouble() ??
                      0,
                  onChanged: (value) {
                    controller.canvasContainerExtension.rotate =
                        value.toInt();
                  },
                ),
              ),
              EasyListTile(
                nameText: "缩放",
                valueText: controller.canvasContainerExtension.scale?.let(
                        (it) =>
                            FormatHelper.printNum(it, maxFractionDigits: 1)) ??
                    "null",
                description: Slider(
                  min: 0,
                  max: 3,
                  value: controller.canvasContainerExtension.scale ?? 0,
                  onChanged: (value) {
                    if (value > 0) {
                      controller.canvasContainerExtension.scale = value;
                    } else {
                      controller.canvasContainerExtension.scale = null;
                    }
                  },
                ),
              ),
              EasySwitchListTile(
                value: controller.drawingBoardEnabled,
                onChanged: (value) {
                  controller.drawingBoardEnabled = value;
                },
                titleText: "绘画",
              ),
              if (controller.drawingBoardEnabled)
                ListenableBuilder(
                  listenable: controller.drawingBoardExtension.paint,
                  builder: (context, _) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        EasyListTile(
                          nameText: "混合模式",
                          valueText: controller
                              .drawingBoardExtension.paint.blendMode.name,
                          description: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: () => controller
                                    .drawingBoardExtension
                                    .paint
                                    .blendMode = BlendMode.srcOver,
                                child: Text(BlendMode.srcOver.name),
                              ),
                              OutlinedButton(
                                onPressed: () => controller
                                    .drawingBoardExtension
                                    .paint
                                    .blendMode = BlendMode.clear,
                                child: Text(BlendMode.clear.name),
                              ),
                            ],
                          ),
                        ),
                        EasyListTile(
                          nameText: "画笔宽度",
                          valueText: controller
                              .drawingBoardExtension.paint.strokeWidth
                              .toInt()
                              .toString(),
                          description: Slider(
                            min: 0,
                            max: 20,
                            value: controller
                                .drawingBoardExtension.paint.strokeWidth,
                            onChanged: (value) {
                              controller.drawingBoardExtension.paint
                                  .strokeWidth = value;
                            },
                          ),
                        ),
                      ],
                    ).toList(),
                  ),
                ),
              EasySwitchListTile(
                value: controller.adjustBoundaryEnabled,
                onChanged: (value) {
                  controller.adjustBoundaryEnabled = value;
                },
                titleText: "剪切",
              ),
              if (controller.adjustBoundaryEnabled)
                ListenableBuilder(
                  listenable: controller.adjustBoundaryExtension,
                  builder: (context, _) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        EasyListTile(
                          nameText: "宽高比",
                          valueText: _AspectRatio.fromRatio(controller
                                  .adjustBoundaryExtension.aspectRatio)
                              .displayName,
                          description: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: _AspectRatio.values
                                .map((e) => OutlinedButton(
                                      onPressed: () {
                                        controller.adjustBoundaryExtension
                                            .aspectRatio = e.ratio;
                                      },
                                      child: Text(e.displayName),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ).toList(),
                  ),
                ),
            ],
          ).toList(),
        );
      },
    );
  }
}

enum _AspectRatio {
  free(null, "free"),
  r1_1(1 / 1, "1:1"),
  r16_9(16 / 9, "16:9"),
  r9_16(9 / 16, "9:16");

  final double? ratio;
  final String displayName;

  const _AspectRatio(this.ratio, this.displayName);

  static _AspectRatio fromRatio(double? ratio) {
    if (_AspectRatio.r1_1.ratio == ratio) {
      return _AspectRatio.r1_1;
    } else if (_AspectRatio.r16_9.ratio == ratio) {
      return _AspectRatio.r16_9;
    } else if (_AspectRatio.r9_16.ratio == ratio) {
      return _AspectRatio.r9_16;
    } else {
      return _AspectRatio.free;
    }
  }
}
