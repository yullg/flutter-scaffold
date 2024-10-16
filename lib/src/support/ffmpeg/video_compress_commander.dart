import 'dart:io';

import 'package:scaffold/scaffold_lang.dart';

import 'filter/filter.dart';
import 'filter/scale_filter.dart';

/// See Also:
/// * https://www.ffmpeg.org/ffmpeg.html
/// * https://www.ffmpeg.org/ffmpeg-filters.html#scale-1
class VideoCompressCommander {
  final File input;
  final File output;
  final int? fpsMax;
  final int? maxWidth;
  final int? maxHeight;
  final Duration? duration;

  const VideoCompressCommander({
    required this.input,
    required this.output,
    this.fpsMax,
    this.maxWidth,
    this.maxHeight,
    this.duration,
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
    fpsMax?.also((it) {
      result.add("-fpsmax");
      result.add("$it");
    });
    final filters = <Filter>[
      if (maxWidth != null || maxHeight != null)
        ScaleFilter(
          width: maxWidth != null ? "min(iw, $maxWidth)" : "-1",
          height: maxHeight != null ? "min(ih, $maxHeight)" : "-1",
          forceOriginalAspectRatio: "decrease",
        )
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
