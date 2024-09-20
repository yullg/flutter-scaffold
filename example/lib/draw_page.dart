import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class DrawPage extends StatefulWidget {
  const DrawPage({super.key});

  @override
  State<StatefulWidget> createState() => _DrawState();
}

class _DrawState extends State<DrawPage> {
  late final CanvasContainerController controller;
  late final AdjustBoundaryController adjustBoundaryController;

  @override
  void initState() {
    super.initState();
    controller = CanvasContainerController();
    adjustBoundaryController = AdjustBoundaryController();
    adjustBoundaryController.boundary = const Rect.fromLTRB(0, 0, 100, 200);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draw Page'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: CanvasContainer(
                  controller: controller,
                  autoScale: true,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.blue,
                      ),
                      AdjustBoundary(
                        controller: adjustBoundaryController,
                        showCenterIndicator: true,
                      ),
                    ],
                  ),
                ),
              ),
              ListenableBuilder(
                listenable: controller,
                builder: (context, _) => Row(
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
    adjustBoundaryController.dispose();
    super.dispose();
  }
}
