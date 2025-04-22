// import 'dart:io';
//
// import 'package:ffmpeg_kit_flutter_full_gpl/ffprobe_kit.dart';
// import 'package:scaffold/scaffold.dart';
//
// class FFProbeUtil {
//   static Future<MediaMetadata> mediaMetadata(File file) async {
//     final mediaInformation =
//         (await FFprobeKit.getMediaInformation(file.path)).getMediaInformation();
//     final durationMilliseconds =
//         ((FormatHelper.tryParseDouble(mediaInformation?.getDuration()) ?? 0) *
//                 1000)
//             .toInt();
//     final duration = Duration(milliseconds: durationMilliseconds);
//     int width = 0, height = 0;
//     double frameRate = 0;
//     final streams = mediaInformation?.getStreams();
//     if (streams != null) {
//       for (final stream in streams) {
//         final streamWidth = stream.getWidth();
//         if (streamWidth != null && streamWidth > width) {
//           width = streamWidth;
//         }
//         final streamHeight = stream.getHeight();
//         if (streamHeight != null && streamHeight > height) {
//           height = streamHeight;
//         }
//         final streamFrameRate =
//             _tryParseFrameRate(stream.getAverageFrameRate());
//         if (streamFrameRate != null && streamFrameRate > frameRate) {
//           frameRate = streamFrameRate;
//         }
//       }
//     }
//     return MediaMetadata(
//       duration: duration,
//       width: width,
//       height: height,
//       frameRate: frameRate.toInt(),
//     );
//   }
//
//   static double? _tryParseFrameRate(String? str) {
//     try {
//       if (str == null) return null;
//       double? result = double.tryParse(str);
//       if (result != null) return result;
//       final parts = str.split("/");
//       result = double.parse(parts.first) / double.parse(parts.last);
//       return result.isFinite ? result : null;
//     } catch (e) {
//       return null;
//     }
//   }
//
//   FFProbeUtil._();
// }
//
// class MediaMetadata {
//   final int width;
//   final int height;
//   final Duration duration;
//   final int frameRate;
//
//   MediaMetadata({
//     required this.width,
//     required this.height,
//     required this.duration,
//     required this.frameRate,
//   });
// }
