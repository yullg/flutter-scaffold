import 'package:scaffold/scaffold_sugar.dart';

import 'filter.dart';

/// See Also: https://www.ffmpeg.org/ffmpeg-filters.html#crop
class CropFilter implements Filter {
  final String? w;
  final String? h;
  final String? x;
  final String? y;
  final String? keepAspect;
  final String? exact;

  const CropFilter({this.w, this.h, this.x, this.y, this.keepAspect, this.exact});

  @override
  String get name => "crop";

  @override
  String? get options {
    final list = <String>[];
    w?.also((it) {
      list.add("w=$it");
    });
    h?.also((it) {
      list.add("h=$it");
    });
    x?.also((it) {
      list.add("x=$it");
    });
    y?.also((it) {
      list.add("y=$it");
    });
    keepAspect?.also((it) {
      list.add("keep_aspect=$it");
    });
    exact?.also((it) {
      list.add("exact=$it");
    });
    return list.isNotEmpty ? list.join(":") : null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropFilter &&
          runtimeType == other.runtimeType &&
          w == other.w &&
          h == other.h &&
          x == other.x &&
          y == other.y &&
          keepAspect == other.keepAspect &&
          exact == other.exact;

  @override
  int get hashCode => w.hashCode ^ h.hashCode ^ x.hashCode ^ y.hashCode ^ keepAspect.hashCode ^ exact.hashCode;

  @override
  String toString() {
    return 'CropFilter{w: $w, h: $h, x: $x, y: $y, keepAspect: $keepAspect, exact: $exact}';
  }
}
