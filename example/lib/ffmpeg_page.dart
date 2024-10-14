import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'package:ffmpeg_kit_flutter_full/session_state.dart';
import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class FFMpegPage extends StatefulWidget {
  const FFMpegPage({super.key});

  @override
  State<StatefulWidget> createState() => _FFMpegState();
}

class _FFMpegState extends GenericState<FFMpegPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FFmpeg Demo'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            EasyListTile(
              nameText: "Video Thumbnail",
              onTap: () => run(() async {
                final input = await pickVideo();
                if (input == null) return;
                final output = await StorageFile(
                        StorageType.cache, "${UuidHelper.v4()}.png")
                    .file;
                output.parent.createSync(recursive: true);
                final commander = VideoThumbnailCommander(
                  input: input,
                  output: output,
                  encoder: const LibwebpEncoder(
                    compressionLevel: 6,
                    quality: 0,
                  ),
                  filter: const ScaleFilter.contain(),
                );
                await executeFFmpeg(commander.commandArguments());
                await GallerySavePlugin.saveImage(output);
              }),
            ),
            EasyListTile(
              nameText: "Video Compress",
              onTap: () => run(() async {
                final input = await pickVideo();
                if (input == null) return;
                final output = await StorageFile(
                        StorageType.cache, "${UuidHelper.v4()}.mp4")
                    .file;
                output.parent.createSync(recursive: true);
                final commander = VideoCompressCommander(
                  input: input,
                  output: output,
                );
                await executeFFmpeg(commander.commandArguments());
                await GallerySavePlugin.saveVideo(output);
              }),
            ),
          ],
        ).toList(),
      ),
    );
  }

  void run(Future<void> Function() block) async {
    try {
      await block();
      if (mounted) {
        Messenger.show(context, "Success");
      }
    } catch (e, s) {
      DefaultLogger.error(null, e, s);
      if (mounted) {
        Messenger.showError(context, error: e);
      }
    }
  }

  Future<void> executeFFmpeg(List<String> commandArguments) {
    defaultLoadingDialog.resetMetadata();
    defaultLoadingDialog.show(context);
    final completer = Completer<void>();
    FFmpegKit.executeWithArgumentsAsync(
      commandArguments,
      (session) async {
        DefaultLogger.info("CompleteCallback >>> ${session.getCommand()}");
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
          DefaultLogger.error("$state->${await session.getFailStackTrace()}");
          completer.completeError(StateError("State=$state"));
        } else {
          completer.completeError(StateError("State=$state"));
        }
      },
      (log) => DefaultLogger.info(
          "LogCallback >>> SessionId=${log.getSessionId()},Level=${log.getLevel()},Message=${log.getMessage()}"),
      (statistics) => DefaultLogger.info(
          "StatisticsCallback >>> SessionId=${statistics.getSessionId()},FrameNumber=${statistics.getVideoFrameNumber()},Fps=${statistics.getVideoFps()},Quality=${statistics.getVideoQuality()},Size=${statistics.getSize()},Time=${statistics.getTime()},Bitrate=${statistics.getBitrate()},Speed=${statistics.getSpeed()}"),
    ).then((session) {
      // 调用executeWithArgumentsAsync()后立即返回
    }, onError: (e, s) {
      completer.completeError(e, s);
    });
    return completer.future;
  }

  Future<File?> pickImage() async {
    return DocumentManagerPlugin.import(
      documentTypes: [
        const DocumentType(mimeType: "image/*", utType: "public.image"),
      ],
    ).then((value) => value.firstOrNull);
  }

  Future<File?> pickVideo() async {
    return DocumentManagerPlugin.import(
      documentTypes: [
        const DocumentType(mimeType: "video/*", utType: "public.video"),
      ],
    ).then((value) => value.firstOrNull);
  }
}
