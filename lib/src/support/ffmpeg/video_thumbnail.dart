import 'dart:io';

import 'codecs/libwebp_video_encoder.dart';
import 'codecs/video_encoder.dart';
import 'filters/scale_video_filter.dart';
import 'filters/video_filter.dart';

class VideoThumbnailCommander {
  final File input;
  final File output;
  final VideoEncoder? encoder;
  final VideoFilter? filter;

  VideoThumbnailCommander({
    required this.input,
    required this.output,
    this.encoder = const LibwebpVideoEncoder(),
    this.filter = const ScaleVideoFilter.contain(
      maxWidth: 480,
      maxHeight: 480,
    ),
  });

  String command() => commandArguments().join(" ");

  List<String> commandArguments() {
    final result = <String>[];
    result.add("-y");
    result.add("-i");
    result.add(input.absolute.path);
    result.add("-vframes");
    result.add("1");
    final encoder = this.encoder;
    if (encoder != null) {
      result.add("-vcodec");
      result.add(encoder.name);
      result.addAll(encoder.options);
    }
    final filter = this.filter;
    if (filter != null) {
      result.add("-vf");
      final options = filter.options;
      if (options != null) {
        result.add("${filter.name}='$options'");
      } else {
        result.add(filter.name);
      }
    }
    result.add(output.absolute.path);
    return result;
  }
}
