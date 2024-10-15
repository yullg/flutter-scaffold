import 'dart:io';

import 'package:scaffold/scaffold_lang.dart';

import 'codec/encoder.dart';
import 'codec/libwebp_encoder.dart';
import 'filter/filter.dart';
import 'filter/scale_filter.dart';

class VideoThumbnailCommander {
  final File input;
  final File output;
  final Encoder? encoder;
  final Filter? filter;

  VideoThumbnailCommander({
    required this.input,
    required this.output,
    this.encoder = const LibwebpEncoder(),
    this.filter = const ScaleFilter.contain(
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
    encoder?.also((it) {
      result.add("-vcodec");
      result.add(it.name);
      it.options?.also((it) {
        result.addAll(it);
      });
    });
    filter?.also((it) {
      result.add("-vf");
      final options = it.options;
      if (options != null) {
        result.add("${it.name}='$options'");
      } else {
        result.add(it.name);
      }
    });
    result.add(output.absolute.path);
    return result;
  }
}
