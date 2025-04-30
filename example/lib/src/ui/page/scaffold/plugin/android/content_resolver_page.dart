import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class ContentResolverPage extends StatefulWidget {
  const ContentResolverPage({super.key});

  @override
  State<StatefulWidget> createState() => _ContentResolverState();
}

class _ContentResolverState extends State<ContentResolverPage> {
  Uri? contentUri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ContentResolver"),
        actions: [
          TextButton(
            onPressed: () {
              AndroidMediaStorePlugin.insertImage().then((value) {
                setState(() {
                  contentUri = value;
                });
              });
            },
            child: const Text("创建ContentUri"),
          ),
        ],
      ),
      bottomSheet: contentUri != null ? Text("$contentUri") : null,
      body: Builder(
        builder: (context) => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () {
                AndroidContentResolverPlugin.getMetadata(contentUri!)
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$value'),
                    ),
                  );
                });
              },
              child: const Text("getMetadata()"),
            ),
            ElevatedButton(
              onPressed: () async {
                final file = await GlobalCacheManager().getSingleFile(
                    "https://cdn.pixabay.com/photo/2015/10/01/17/17/car-967387_1280.png");
                AndroidContentResolverPlugin.copyFileToContentUri(
                  file: file,
                  contentUri: contentUri!,
                ).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('成功')),
                  );
                });
              },
              child: const Text("copyFileToContentUri()"),
            ),
            ElevatedButton(
              onPressed: () async {
                final file = await StorageFile(StorageType.cache,
                        "${DateTime.now().millisecondsSinceEpoch}.png")
                    .file;
                AndroidContentResolverPlugin.copyContentUriToFile(
                  contentUri: contentUri!,
                  file: file,
                ).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('成功:${file.path}')),
                  );
                });
              },
              child: const Text("copyContentUriToFile()"),
            ),
          ],
        ),
      ),
    );
  }
}
