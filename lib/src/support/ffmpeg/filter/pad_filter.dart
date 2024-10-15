import 'package:scaffold/scaffold_lang.dart';

import 'filter.dart';

/// Add paddings to the input image, and place the original input at the
/// provided x, y coordinates.
///
/// See Also: https://www.ffmpeg.org/ffmpeg-filters.html#pad-1
class PadFilter implements Filter {
  final String? width;
  final String? height;
  final String? x;
  final String? y;
  final String? color;
  final String? eval;
  final String? aspect;

  const PadFilter({
    this.width,
    this.height,
    this.x,
    this.y,
    this.color,
    this.eval,
    this.aspect,
  });

  @override
  String get name => "pad";

  @override
  String? get options {
    final list = <String>[];
    width?.also((it) {
      list.add("w=$it");
    });
    height?.also((it) {
      list.add("h=$it");
    });
    x?.also((it) {
      list.add("x=$it");
    });
    y?.also((it) {
      list.add("y=$it");
    });
    color?.also((it) {
      list.add("color=$it");
    });
    eval?.also((it) {
      list.add("eval=$it");
    });
    aspect?.also((it) {
      list.add("aspect=$it");
    });
    return list.isNotEmpty ? list.join(":") : null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PadFilter &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          x == other.x &&
          y == other.y &&
          color == other.color &&
          eval == other.eval &&
          aspect == other.aspect;

  @override
  int get hashCode =>
      width.hashCode ^
      height.hashCode ^
      x.hashCode ^
      y.hashCode ^
      color.hashCode ^
      eval.hashCode ^
      aspect.hashCode;

  @override
  String toString() {
    return 'PadFilter{width: $width, height: $height, x: $x, y: $y, color: $color, eval: $eval, aspect: $aspect}';
  }
}
