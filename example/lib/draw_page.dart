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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draw Page'),
        actions: [
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
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
              ListenableBuilder(
                listenable: controller,
                builder: (context, _) => Column(
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
              ),
            ],
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
