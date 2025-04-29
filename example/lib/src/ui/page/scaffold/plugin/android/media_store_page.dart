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
          ],
        ),
      ),
    );
  }
}
