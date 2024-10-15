import 'package:scaffold/scaffold_lang.dart';

import 'filter.dart';

/// Scale (resize) the input video, using the libswscale library.
///
/// See Also: https://www.ffmpeg.org/ffmpeg-filters.html#scale-1
class ScaleFilter implements Filter {
  final String? width;
  final String? height;
  final String? forceOriginalAspectRatio;

  const ScaleFilter({
    this.width,
    this.height,
    this.forceOriginalAspectRatio,
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
    forceOriginalAspectRatio?.also((it) {
      list.add("force_original_aspect_ratio=$it");
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
          forceOriginalAspectRatio == other.forceOriginalAspectRatio;

  @override
  int get hashCode =>
      width.hashCode ^ height.hashCode ^ forceOriginalAspectRatio.hashCode;

  @override
  String toString() {
    return 'ScaleFilter{width: $width, height: $height, forceOriginalAspectRatio: $forceOriginalAspectRatio}';
  }
}
