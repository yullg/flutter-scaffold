import 'package:scaffold/scaffold_sugar.dart';

import 'encoder.dart';

/// See Also: https://www.ffmpeg.org/ffmpeg-codecs.html#libwebp
class LibwebpEncoder implements Encoder {
  final bool? lossless;
  final int? compressionLevel;
  final double? quality;
  final String? preset;

  const LibwebpEncoder({this.lossless, this.compressionLevel, this.quality, this.preset});

  @override
  String get name => "libwebp";

  @override
  Iterable<String>? get options {
    final list = <String>[];
    lossless?.also((it) {
      list.add("-lossless");
      list.add(it ? "1" : "0");
    });
    compressionLevel?.also((it) {
      list.add("-compression_level");
      list.add("$it");
    });
    quality?.also((it) {
      list.add("-quality");
      list.add("$it");
    });
    preset?.also((it) {
      list.add("-preset");
      list.add(it);
    });
    return list;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibwebpEncoder &&
          runtimeType == other.runtimeType &&
          lossless == other.lossless &&
          compressionLevel == other.compressionLevel &&
          quality == other.quality &&
          preset == other.preset;

  @override
  int get hashCode => lossless.hashCode ^ compressionLevel.hashCode ^ quality.hashCode ^ preset.hashCode;

  @override
  String toString() {
    return 'LibwebpEncoder{lossless: $lossless, compressionLevel: $compressionLevel, quality: $quality, preset: $preset}';
  }
}
