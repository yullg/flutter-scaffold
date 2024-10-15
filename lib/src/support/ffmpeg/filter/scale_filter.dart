import 'filter.dart';

/// Scale (resize) the input video, using the libswscale library.
///
/// See Also: https://www.ffmpeg.org/ffmpeg-filters.html#scale-1
class ScaleFilter implements Filter {
  static const kForceOriginalAspectRatioDisable = "disable";
  static const kForceOriginalAspectRatioDecrease = "decrease";
  static const kForceOriginalAspectRatioIncrease = "increase";

  @override
  final String name = "scale";

  final String width;
  final String height;
  final String? forceOriginalAspectRatio;

  const ScaleFilter({
    this.width = "0",
    this.height = "0",
    this.forceOriginalAspectRatio,
  });

  const ScaleFilter.contain({
    int? maxWidth,
    int? maxHeight,
  })  : width = maxWidth != null ? "min(iw, $maxWidth)" : "-1",
        height = maxHeight != null ? "min(ih, $maxHeight)" : "-1",
        forceOriginalAspectRatio = kForceOriginalAspectRatioDecrease;

  @override
  String? get options {
    final list = <String>[];
    list.add("w=$width");
    list.add("h=$height");
    if (forceOriginalAspectRatio != null) {
      list.add("force_original_aspect_ratio=$forceOriginalAspectRatio");
    }
    return list.join(":");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScaleFilter &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          width == other.width &&
          height == other.height &&
          forceOriginalAspectRatio == other.forceOriginalAspectRatio;

  @override
  int get hashCode =>
      name.hashCode ^
      width.hashCode ^
      height.hashCode ^
      forceOriginalAspectRatio.hashCode;

  @override
  String toString() {
    return 'ScaleFilter{name: $name, width: $width, height: $height, forceOriginalAspectRatio: $forceOriginalAspectRatio}';
  }
}
