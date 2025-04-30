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
              onPressed: () {
                AndroidIntentPlugin.actionPick(
                  type: AndroidIntentPlugin.kActionPickTypeAudio,
                  forcingChooser: true,
                  chooserTitle: "测试标题",
                ).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("actionPick(Audio)"),
            ),
            ElevatedButton(
              onPressed: () {
                AndroidIntentPlugin.actionPick(
                  type: AndroidIntentPlugin.kActionPickTypeImage,
                  forcingChooser: true,
                  chooserTitle: "测试标题",
                ).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("actionPick(Images)"),
            ),
            ElevatedButton(
              onPressed: () {
                AndroidIntentPlugin.actionPick(
                  type: AndroidIntentPlugin.kActionPickTypeVideo,
                  forcingChooser: true,
                  chooserTitle: "测试标题",
                ).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("actionPick(Video)"),
            ),
            ElevatedButton(
              onPressed: () async {
                final outputContentUri =
                    await AndroidMediaStorePlugin.insertImage();
                await AndroidIntentPlugin.takePicture(
                  outputContentUri: outputContentUri!,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$outputContentUri'),
                  ),
                );
              },
              child: const Text("takePicture()"),
            ),
            ElevatedButton(
              onPressed: () async {
                final outputContentUri =
                    await AndroidMediaStorePlugin.insertVideo();
                await AndroidIntentPlugin.captureVideo(
                  outputContentUri: outputContentUri!,
                  forcingChooser: true,
                  chooserTitle: "测试标题",
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$outputContentUri'),
                  ),
                );
              },
              child: const Text("captureVideo()"),
            ),
            ElevatedButton(
              onPressed: () {
                AndroidIntentPlugin.createDocument(
                  mimeType: "image/*",
                  name: "测试名称",
                ).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("createDocument()"),
            ),
            ElevatedButton(
              onPressed: () {
                AndroidIntentPlugin.openDocument(
                  mimeTypes: ["image/*", "audio/*"],
                ).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("openDocument()"),
            ),
            ElevatedButton(
              onPressed: () {
                AndroidIntentPlugin.openDocumentTree(
                  initialLocation: null,
                ).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("openDocumentTree()"),
            ),
            ElevatedButton(
              onPressed: () {
                AndroidIntentPlugin.openMultipleDocuments(
                  mimeTypes: ["image/*", "audio/*"],
                ).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("openMultipleDocuments()"),
            ),
          ],
        ),
      ),
    );
  }
}
