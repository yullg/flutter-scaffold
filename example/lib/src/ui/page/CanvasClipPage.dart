import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

import '../../util/ffprobe_util.dart';

class CanvasClipPage extends StatefulWidget {
  const CanvasClipPage({super.key});

  @override
  State<StatefulWidget> createState() => _CanvasClipState();
}

class _CanvasClipState extends State<CanvasClipPage> {
  late final CanvasContainerController controller;

  File? imageFile;
  MediaMetadata? imageFileMediaMetadata;

  @override
  void initState() {
    super.initState();
    controller = CanvasContainerController(
      canvasContainerExtensionOption: const CanvasContainerExtensionOption(
        minScale: 1,
        maxScale: 5,
        rotationGestureEnabled: false,
        singleFingerTranslation: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canvas-Clip Demo'),
      ),
      body: Center(
        child: SafeArea(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: Colors.grey,
              alignment: Alignment.center,
              child: imageFile != null && imageFileMediaMetadata != null
                  ? AspectRatio(
                      aspectRatio: 1280 / 768,
                      child: Stack(
                        children: [
                          CanvasContainer(
                            controller: controller,
                            builder: (context, constraints) {
                              return CanvasContainerChild.cover(
                                boxSize: constraints.biggest,
                                childSize: Size(
                                  imageFileMediaMetadata!.width.toDouble(),
                                  imageFileMediaMetadata!.height.toDouble(),
                                ),
                                child: Image.file(
                                  imageFile!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          ),
                          IgnorePointer(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.green,
                                  width: 5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        final files = await DocumentManagerPlugin.import(
                            documentTypes: [DocumentType.image]);
                        final file = files.firstOrNull;
                        if (file == null) return;
                        final mediaMetadata =
                            await FFProbeUtil.mediaMetadata(file);
                        if (mounted) {
                          setState(() {
                            imageFile = file;
                            imageFileMediaMetadata = mediaMetadata;
                          });
                        }
                      },
                      child: const Text("选择图片"),
                    ),
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
