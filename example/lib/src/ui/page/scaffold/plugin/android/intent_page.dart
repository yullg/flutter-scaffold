import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class IntentPage extends StatelessWidget {
  const IntentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Intent"),
      ),
      body: Builder(
        builder: (context) => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () async {
                final outputContentUri =
                    await AndroidMediaStorePlugin.insertImage();
                await AndroidIntentPlugin.imageCapture(
                  outputContentUri: outputContentUri!,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$outputContentUri'),
                  ),
                );
              },
              child: const Text("imageCapture()"),
            ),
            ElevatedButton(
              onPressed: () async {
                final outputContentUri =
                    await AndroidMediaStorePlugin.insertVideo();
                await AndroidIntentPlugin.videoCapture(
                  outputContentUri: outputContentUri!,
                  forcingChooser: true,
                  chooserTitle: "请选择相机",
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$outputContentUri'),
                  ),
                );
              },
              child: const Text("videoCapture()"),
            ),
          ],
        ),
      ),
    );
  }
}
