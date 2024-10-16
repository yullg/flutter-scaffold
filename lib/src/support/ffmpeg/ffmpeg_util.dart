import 'dart:ui';

import 'package:meta/meta.dart';

@internal
class FFmpegUtil {
  static String? toFFmpegColor(Color? color) {
    if (color == null) return null;
    return "0x${color.red.toRadixString(16).padLeft(2, "0")}${color.green.toRadixString(16).padLeft(2, "0")}${color.blue.toRadixString(16).padLeft(2, "0")}${color.alpha.toRadixString(16).padLeft(2, "0")}";
  }

  FFmpegUtil._();
}
