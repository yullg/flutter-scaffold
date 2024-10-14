import 'video_filter.dart';

/// Scale (resize) the input video, using the libswscale library.
///
/// See Also: https://www.ffmpeg.org/ffmpeg-filters.html#scale-1
class ScaleVideoFilter implements VideoFilter {
  static const kForceOriginalAspectRatioDisable = "disable";
  static const kForceOriginalAspectRatioDecrease = "decrease";
  static const kForceOriginalAspectRatioIncrease = "increase";

  @override
  final String name = "scale";

  final String? width;
  final String? height;
  final String? forceOriginalAspectRatio;

  const ScaleVideoFilter({
    this.width,
    this.height,
    this.forceOriginalAspectRatio,
  });

  const ScaleVideoFilter.contain({
    int? maxWidth,
    int? maxHeight,
  })  : width = maxWidth != null ? "min(iw, $maxWidth)" : null,
        height = maxHeight != null ? "min(ih, $maxHeight)" : null,
        forceOriginalAspectRatio = kForceOriginalAspectRatioDecrease;

  @override
  String? get options {
    final list = <String>[];
    if (width != null) {
      list.add("w=$width");
    }
    if (height != null) {
      list.add("h=$height");
    }
    if (forceOriginalAspectRatio != null) {
      list.add("force_original_aspect_ratio=$forceOriginalAspectRatio");
    }
    if (list.isNotEmpty) {
      return list.join(":");
    } else {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScaleVideoFilter &&
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
    return 'ScaleVideoFilter{name: $name, width: $width, height: $height, forceOriginalAspectRatio: $forceOriginalAspectRatio}';
  }
}
