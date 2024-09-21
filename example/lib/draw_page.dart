import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class DrawPage extends StatefulWidget {
  const DrawPage({super.key});

  @override
  State<StatefulWidget> createState() => _DrawState();
}

class _DrawState extends State<DrawPage> {
  late final CanvasContainerController controller;

  bool autoScale = false;

  @override
  void initState() {
    super.initState();
    controller = CanvasContainerController();
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.white,
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
                  autoScale: autoScale,
                  child: Container(
                    color: Colors.blue,
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
                        Text("Rotate: ${controller.rotation}"),
                        Expanded(
                          child: Slider(
                            min: 0,
                            max: 359,
                            value: controller.rotation.toDouble(),
                            onChanged: (value) {
                              controller.rotation = value.toInt();
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                            "Scale: ${FormatHelper.printNum(controller.scale, maxFractionDigits: 1)}"),
                        Expanded(
                          child: Slider(
                            min: 0.1,
                            max: 3.0,
                            value: controller.scale,
                            onChanged: (value) {
                              controller.scale = value;
                            },
                          ),
                        ),
                        const Text("Auto Scale:"),
                        Switch(
                          value: autoScale,
                          onChanged: (value) {
                            setState(() {
                              autoScale = value;
                            });
                          },
                        ),
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
