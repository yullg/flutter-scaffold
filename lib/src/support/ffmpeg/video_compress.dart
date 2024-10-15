import 'dart:io';

import 'package:scaffold/scaffold_lang.dart';

import 'codec/encoder.dart';
import 'filter/filter.dart';
import 'filter/scale_filter.dart';

class VideoCompressCommander {
  final File input;
  final File output;
  final Duration? duration;
  final int? fpsMax;
  final Encoder? encoder;
  final Encoder? videoEncoder;
  final Encoder? audioEncoder;
  final Filter? filter;

  VideoCompressCommander({
    required this.input,
    required this.output,
    this.duration,
    this.fpsMax,
    this.encoder,
    this.videoEncoder,
    this.audioEncoder,
    this.filter = const ScaleFilter.contain(
      maxWidth: 1080,
      maxHeight: 1080,
    ),
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
    encoder?.also((it) {
      result.add("-c");
      result.add(it.name);
      it.options?.also((it) {
        result.addAll(it);
      });
    });
    videoEncoder?.also((it) {
      result.add("-c:v");
      result.add(it.name);
      it.options?.also((it) {
        result.addAll(it);
      });
    });
    audioEncoder?.also((it) {
      result.add("-c:a");
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
