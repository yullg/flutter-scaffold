import 'package:scaffold/scaffold_lang.dart';

import 'filter.dart';

/// See Also: https://www.ffmpeg.org/ffmpeg-filters.html#scale-1
class ScaleFilter implements Filter {
  final String? width;
  final String? height;
  final String? eval;
  final String? forceOriginalAspectRatio;
  final String? forceDivisibleBy;

  const ScaleFilter({
    this.width,
    this.height,
    this.eval,
    this.forceOriginalAspectRatio,
    this.forceDivisibleBy,
  });

  @override
  String get name => "scale";

  @override
  String? get options {
    final list = <String>[];
    width?.also((it) {
      list.add("w=$it");
    });
    height?.also((it) {
      list.add("h=$it");
    });
    eval?.also((it) {
      list.add("eval=$eval");
    });
    forceOriginalAspectRatio?.also((it) {
      list.add("force_original_aspect_ratio=$it");
    });
    forceDivisibleBy?.also((it) {
      list.add("force_divisible_by=$it");
    });
    return list.isNotEmpty ? list.join(":") : null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScaleFilter &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          eval == other.eval &&
          forceOriginalAspectRatio == other.forceOriginalAspectRatio;

  @override
  int get hashCode =>
      width.hashCode ^
      height.hashCode ^
      eval.hashCode ^
      forceOriginalAspectRatio.hashCode;

  @override
  String toString() {
    return 'ScaleFilter{width: $width, height: $height, eval: $eval, forceOriginalAspectRatio: $forceOriginalAspectRatio}';
  }
}
