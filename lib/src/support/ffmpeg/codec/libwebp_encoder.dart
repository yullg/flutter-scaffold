import 'encoder.dart';

/// libwebp WebP Image encoder wrapper.
///
/// See Also: https://www.ffmpeg.org/ffmpeg-codecs.html#libwebp
class LibwebpEncoder implements Encoder {
  static const kPresetNone = "none";
  static const kPresetDefault = "default";
  static const kPresetPicture = "picture";
  static const kPresetPhoto = "photo";
  static const kPresetDrawing = "drawing";
  static const kPresetIcon = "icon";
  static const kPresetText = "text";

  @override
  final String name = "libwebp";

  final bool? lossless;
  final int? compressionLevel;
  final double? quality;
  final String? preset;

  const LibwebpEncoder({
    this.lossless,
    this.compressionLevel,
    this.quality,
    this.preset,
  });

  @override
  List<String>? get options {
    final list = <String>[];
    if (lossless != null) {
      list.add("-lossless");
      list.add(lossless! ? "1" : "0");
    }
    if (compressionLevel != null) {
      list.add("-compression_level");
      list.add("$compressionLevel");
    }
    if (quality != null) {
      list.add("-quality");
      list.add("$quality");
    }
    if (preset != null) {
      list.add("-preset");
      list.add(preset!);
    }
    return list;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibwebpEncoder &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          lossless == other.lossless &&
          compressionLevel == other.compressionLevel &&
          quality == other.quality &&
          preset == other.preset;

  @override
  int get hashCode =>
      name.hashCode ^
      lossless.hashCode ^
      compressionLevel.hashCode ^
      quality.hashCode ^
      preset.hashCode;

  @override
  String toString() {
    return 'LibwebpEncoder{name: $name, lossless: $lossless, compressionLevel: $compressionLevel, quality: $quality, preset: $preset}';
  }
}
