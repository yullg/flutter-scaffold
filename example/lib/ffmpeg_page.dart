import 'dart:convert';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
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
              onTap: () async {
                final input = (await DocumentManagerPlugin.import(
                  documentTypes: [
                    const DocumentType(
                        mimeType: "video/*", utType: "public.video"),
                  ],
                ))
                    .firstOrNull;
                if (input == null) return;
                final output = await StorageFile(
                        StorageType.cache, "${UuidHelper.v4()}.png")
                    .file;
                final commander = VideoThumbnailCommander(
                  input: input,
                  output: output,
                );
                if (!context.mounted) return;
                defaultLoadingDialog.resetMetadata();
                defaultLoadingDialog.show(context);
                FFmpegKit.executeWithArgumentsAsync(
                  commander.commandArguments(),
                  (session) async {
                    defaultLoadingDialog.dismiss();
                    DefaultLogger.info(await session.getLogsAsString());
                    final state = await session.getState();
                    if (SessionState.completed == state) {
                      GallerySavePlugin.saveImage(output).ignore();
                    } else {
                      DefaultLogger.error(
                          "$state->${await session.getFailStackTrace()}");
                    }
                  },
                  (log) => DefaultLogger.info(jsonEncode(log)),
                  (statistics) {
                    final statisticsStr = jsonEncode(statistics);
                    DefaultLogger.info(statisticsStr);
                    defaultLoadingDialog.message = statisticsStr;
                  },
                ).then((session) async {
                  DefaultLogger.info(
                      "then -> ${await session.getLogsAsString()}");
                }, onError: (e, s) {
                  DefaultLogger.error(null, e, s);
                });
              },
            ),
          ],
        ).toList(),
      ),
    );
  }
}
