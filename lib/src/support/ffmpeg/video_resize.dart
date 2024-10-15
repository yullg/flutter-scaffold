import 'dart:io';
import 'dart:ui';

import 'package:scaffold/scaffold_lang.dart';

import 'ffmpeg_util.dart';
import 'filter/filter.dart';
import 'filter/pad_filter.dart';
import 'filter/scale_filter.dart';

class VideoResizeCommander {
  final File input;
  final File output;
  final int width;
  final int height;
  final Duration? duration;
  final Color? padColor;

  const VideoResizeCommander({
    required this.input,
    required this.output,
    required this.width,
    required this.height,
    this.duration,
    this.padColor,
  });

  String command() => commandArguments().join(" ");

  List<String> commandArguments() {
    final result = <String>[];
    result.add("-y");
    result.add("-i");
    result.add(input.absolute.path);
    duration?.also((it) {
      result.add("-t");
      result.add("${it.inSeconds}");
    });
    final filters = <Filter>[
      ScaleFilter(
        width: "$width",
        height: "$height",
        forceOriginalAspectRatio: "decrease",
      ),
      PadFilter(
        width: "$width",
        height: "$height",
        x: "(ow-iw)/2",
        y: "(oh-ih)/2",
        color: FFmpegUtil.toFFmpegColor(padColor),
      ),
    ];
    if (filters.isNotEmpty) {
      result.add("-vf");
      result.add(filters.map((filter) {
        final options = filter.options;
        if (options != null) {
          return "${filter.name}='$options'";
        } else {
          return filter.name;
        }
      }).join(","));
    }
    result.add(output.absolute.path);
    return result;
  }
}
