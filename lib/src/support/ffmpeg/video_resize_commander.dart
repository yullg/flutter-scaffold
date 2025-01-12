import 'dart:io';
import 'dart:ui';

import 'package:scaffold/scaffold_lang.dart';

import 'codec/encoder.dart';
import 'ffmpeg_util.dart';
import 'filter/filter.dart';
import 'filter/pad_filter.dart';
import 'filter/scale_filter.dart';

/// See Also:
/// * https://www.ffmpeg.org/ffmpeg.html
/// * https://www.ffmpeg.org/ffmpeg-filters.html#scale-1
/// * https://www.ffmpeg.org/ffmpeg-filters.html#pad-1
class VideoResizeCommander {
  final File input;
  final File output;
  final int width;
  final int height;
  final bool padding;
  final Color? padColor;
  final Duration? duration;
  final Encoder? videoEncoder;
  final Encoder? audioEncoder;

  const VideoResizeCommander({
    required this.input,
    required this.output,
    required this.width,
    required this.height,
    this.padding = false,
    this.padColor,
    this.duration,
    this.videoEncoder,
    this.audioEncoder,
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
    videoEncoder?.also((it) {
      result.add("-vcodec");
      result.add(it.name);
      it.options?.also((it) {
        result.addAll(it);
      });
    });
    audioEncoder?.also((it) {
      result.add("-acodec");
      result.add(it.name);
      it.options?.also((it) {
        result.addAll(it);
      });
    });
    final filters = <Filter>[
      ScaleFilter(
        width: "$width",
        height: "$height",
        forceOriginalAspectRatio: "decrease",
      ),
      if (padding)
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
