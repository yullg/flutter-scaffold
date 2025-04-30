import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class MediaStorePage extends StatelessWidget {
  const MediaStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MediaStore"),
      ),
      body: Builder(
        builder: (context) => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () {
                AndroidMediaStorePlugin.insertAudio().then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("insertAudio()"),
            ),
            ElevatedButton(
              onPressed: () {
                AndroidMediaStorePlugin.insertImage().then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("insertImage()"),
            ),
            ElevatedButton(
              onPressed: () {
                AndroidMediaStorePlugin.insertVideo().then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("insertVideo()"),
            ),
            ElevatedButton(
              onPressed: () async {
                final file = await GlobalCacheManager().getSingleFile(
                    "https://cdn.pixabay.com/download/audio/2025/04/21/audio_ed6f0ed574.mp3");
                AndroidMediaStorePlugin.insertAudioFile(
                  file: file,
                  displayName: "测试名称.mp3",
                ).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("insertAudioFile()"),
            ),
            ElevatedButton(
              onPressed: () async {
                final file = await GlobalCacheManager().getSingleFile(
                    "https://cdn.pixabay.com/photo/2022/03/30/22/05/easter-7101862_1280.jpg");
                AndroidMediaStorePlugin.insertImageFile(
                  file: file,
                  displayName: "测试名称.jpg",
                ).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("insertImageFile()"),
            ),
            ElevatedButton(
              onPressed: () async {
                final file = await GlobalCacheManager().getSingleFile(
                    "https://a7cb2d87-b62d-4ddc-8eea-8bb5d3f9010a.mdnplay.dev/shared-assets/videos/flower.webm");
                AndroidMediaStorePlugin.insertVideoFile(
                  file: file,
                ).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("insertVideoFile()"),
            ),
            ElevatedButton(
              onPressed: () async {
                final file = await GlobalCacheManager().getSingleFile(
                    "https://cdn.pixabay.com/video/2025/04/10/271161_large.mp4");
                AndroidMediaStorePlugin.insertDownload(
                  file: file,
                ).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("insertDownload()"),
            ),
          ],
        ),
      ),
    );
  }
}
