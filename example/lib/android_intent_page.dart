import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class AndroidIntentPage extends StatefulWidget {
  const AndroidIntentPage({super.key});

  @override
  State<StatefulWidget> createState() => _AndroidIntentState();
}

class _AndroidIntentState extends State<AndroidIntentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Intent Demo'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            EasyListTile(
              nameText: "actionPick()",
              description: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      actionPick(AndroidIntentPlugin.kActionPickTypeAudio).then(
                          (value) {
                        DefaultLogger.info(value);
                        Messenger.show(context, value.toString());
                      }, onError: (e, s) {
                        DefaultLogger.error(null, e, s);
                        Messenger.showError(context, error: e);
                      });
                    },
                    child: const Text("audio"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      actionPick(AndroidIntentPlugin.kActionPickTypeImage).then(
                          (value) {
                        DefaultLogger.info(value);
                        Messenger.show(context, value.toString());
                      }, onError: (e, s) {
                        DefaultLogger.error(null, e, s);
                        Messenger.showError(context, error: e);
                      });
                    },
                    child: const Text("image"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      actionPick(AndroidIntentPlugin.kActionPickTypeVideo).then(
                          (value) {
                        DefaultLogger.info(value);
                        Messenger.show(context, value.toString());
                      }, onError: (e, s) {
                        DefaultLogger.error(null, e, s);
                        Messenger.showError(context, error: e);
                      });
                    },
                    child: const Text("video"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      actionPick("").then((value) {
                        DefaultLogger.info(value);
                        Messenger.show(context, value.toString());
                      }, onError: (e, s) {
                        DefaultLogger.error(null, e, s);
                        Messenger.showError(context, error: e);
                      });
                    },
                    child: const Text("none"),
                  ),
                ],
              ),
            ),
          ],
        ).toList(),
      ),
    );
  }

  Future<File?> actionPick(String type) async {
    final contentUri = await AndroidIntentPlugin.actionPick(type: type);
    if (contentUri != null) {
      final metadata =
          await AndroidContentResolverPlugin.getMetadata(contentUri);
      final file = await StorageFile(StorageType.cache,
              "${UuidHelper.v4()}/${metadata.displayName ?? UuidHelper.v4()}")
          .file;
      await AndroidContentResolverPlugin.copyContentUriToFile(
        contentUri: contentUri,
        file: file,
      );
      return file;
    }
  }
}
