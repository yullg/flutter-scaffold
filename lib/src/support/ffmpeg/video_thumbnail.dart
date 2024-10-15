import 'dart:io';

import 'package:scaffold/scaffold_lang.dart';

import 'codec/libwebp_encoder.dart';
import 'filter/filter.dart';
import 'filter/scale_filter.dart';

class VideoThumbnailCommander {
  final File input;
  final File output;
  final bool selectIFrame;
  final bool? lossless;
  final int? compressionLevel;
  final double? quality;
  final int? maxWidth;
  final int? maxHeight;

  const VideoThumbnailCommander({
    required this.input,
    required this.output,
    this.selectIFrame = false,
    this.lossless,
    this.compressionLevel,
    this.quality,
    this.maxWidth,
    this.maxHeight,
  });

  String command() => commandArguments().join(" ");

  List<String> commandArguments() {
    final result = <String>[];
    result.add("-y");
    result.add("-i");
    result.add(input.absolute.path);
    result.add("-vframes");
    result.add("1");
    result.add("-vcodec");
    final encoder = LibwebpEncoder(
      lossless: lossless,
      compressionLevel: compressionLevel,
      quality: quality,
    );
    result.add(encoder.name);
    encoder.options?.also((it) {
      result.addAll(it);
    });
    final filters = <Filter>[
      if (selectIFrame) const FilterImpl("select", "eq(pict_type,I)"),
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
