import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/session_state.dart';
import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';
import 'package:scaffold/scaffold_lang.dart';

import '../../util/ffprobe_util.dart';

class CanvasClipPage extends StatefulWidget {
  const CanvasClipPage({super.key});

  @override
  State<StatefulWidget> createState() => _CanvasClipState();
}

class _CanvasClipState extends GenericState<CanvasClipPage> {
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
        rotateGestureEnabled: false,
        singleFingerTranslate: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canvas-Clip Demo'),
        actions: [
          IconButton(
            onPressed: () async {
              final parentSize =
                  controller.canvasContainerExtension.requiredContainerSize;
              Size childSize = controller
                  .canvasContainerExtension.requiredContainerChildSize;
              controller.canvasContainerExtension.scale?.also((it) {
                childSize = childSize * it;
              });
              Offset childCenter = childSize.center(Offset.zero);
              controller.canvasContainerExtension.translate?.also((it) {
                childCenter = childCenter - it;
              });
              final imageScale =
                  childSize.width / imageFileMediaMetadata!.width;
              Rect clipRect = Rect.fromCenter(
                center: childCenter / imageScale,
                width: parentSize.width / imageScale,
                height: parentSize.height / imageScale,
              );
              DefaultLogger().info(clipRect);
              final output =
                  await StorageFile(StorageType.cache, "${UuidHelper.v4()}.png")
                      .file;
              await executeFFmpeg([
                "-y",
                "-i",
                imageFile!.absolute.path,
                "-vf",
                "crop=${clipRect.width}:${clipRect.height}:${clipRect.left}:${clipRect.top}",
                output.absolute.path
              ]);
              await GallerySavePlugin.saveImage(output);
              Toast.showLong(context, "成功");
            },
            icon: const Icon(Icons.save_outlined),
          ),
        ],
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

  Future<void> executeFFmpeg(List<String> commandArguments) {
    defaultLoadingDialog.resetMetadata();
    defaultLoadingDialog.show(context);
    final completer = Completer<void>();
    FFmpegKit.executeWithArgumentsAsync(
      commandArguments,
      (session) async {
        DefaultLogger().info("CompleteCallback >>> ${session.getCommand()}");
        defaultLoadingDialog.dismiss();
        final state = await session.getState();
        if (SessionState.completed == state) {
          final returnCode = await session.getReturnCode();
          if (ReturnCode.isSuccess(returnCode)) {
            completer.complete();
          } else if (ReturnCode.isCancel(returnCode)) {
            completer.completeError(CancellationError());
          } else {
            completer.completeError(StateError("ReturnCode=$returnCode"));
          }
        } else if (SessionState.failed == state) {
          DefaultLogger().error("$state->${await session.getFailStackTrace()}");
          completer.completeError(StateError("State=$state"));
        } else {
          completer.completeError(StateError("State=$state"));
        }
      },
      (log) => DefaultLogger().info(
          "LogCallback >>> SessionId=${log.getSessionId()},Level=${log.getLevel()},Message=${log.getMessage()}"),
      (statistics) => DefaultLogger().info(
          "StatisticsCallback >>> SessionId=${statistics.getSessionId()},FrameNumber=${statistics.getVideoFrameNumber()},Fps=${statistics.getVideoFps()},Quality=${statistics.getVideoQuality()},Size=${statistics.getSize()},Time=${statistics.getTime()},Bitrate=${statistics.getBitrate()},Speed=${statistics.getSpeed()}"),
    ).then((session) {
      // 调用executeWithArgumentsAsync()后立即返回
    }, onError: (e, s) {
      completer.completeError(e, s);
    });
    return completer.future;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
