import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

import 'android_intent_page.dart';
import 'canvas_page.dart';
import 'messenger_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    ScaffoldConfig.apply(
      messengerOption: ScaffoldMessengerOption(
        errorStyle: FunctionSupplier((context) => SnackBarMessageStyle(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
              showCloseIcon: true,
            )),
        errorPrinters: [
          DefaultErrorPrinter(),
        ],
      ),
    );
    if (Platform.isAndroid) {
      AndroidNotificationPlugin.createNotificationChannel(
              id: "test", importance: 4, name: "test-name")
          .then((_) {
        DefaultLogger().info("createNotificationChannel");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            EasyListTile(
              nameText: "Canvas Demo",
              trailingIcon: Icons.arrow_forward_ios,
              onTap: () {
                to(context, const CanvasPage());
              },
            ),
            // EasyListTile(
            //   nameText: "Canvas-Clip Demo",
            //   trailingIcon: Icons.arrow_forward_ios,
            //   onTap: () {
            //     to(context, const CanvasClipPage());
            //   },
            // ),
            EasyListTile(
              nameText: "Messenger Demo",
              trailingIcon: Icons.arrow_forward_ios,
              onTap: () {
                to(context, const MessengerPage());
              },
            ),
            // EasyListTile(
            //   nameText: "FFmpeg Demo",
            //   trailingIcon: Icons.arrow_forward_ios,
            //   onTap: () {
            //     to(context, const FFMpegPage());
            //   },
            // ),
            if (Platform.isAndroid)
              EasyListTile(
                nameText: "Activity Intent Demo",
                trailingIcon: Icons.arrow_forward_ios,
                onTap: () {
                  to(context, const AndroidIntentPage());
                },
              ),
            EasyListTile(
              nameText: "AndroidMediaProjectionPlugin.authorize",
              onTap: () {
                AndroidMediaProjectionPlugin.authorize().catchError((e, s) {
                  DefaultLogger().error(null, e, s);
                });
              },
            ),
            EasyListTile(
              nameText: "startAudioPlaybackCapture",
              onTap: () {
                AndroidAudioRecordPlugin.startAudioPlaybackCapture(
                  notificationId: 3,
                  notificationChannelId: "test",
                  notificationContentTitle: "测试标题",
                  notificationContentText: "测试内容",
                ).catchError((e, s) {
                  DefaultLogger().error(null, e, s);
                });
              },
            ),
            EasyListTile(
              nameText: "resume",
              onTap: () {
                AndroidAudioRecordPlugin.resume().catchError((e, s) {
                  DefaultLogger().error(null, e, s);
                });
              },
            ),
            EasyListTile(
              nameText: "stop",
              onTap: () {
                AndroidAudioRecordPlugin.stop().catchError((e, s) {
                  DefaultLogger().error(null, e, s);
                });
              },
            ),
            EasyListTile(
              nameText: "release",
              onTap: () {
                AndroidAudioRecordPlugin.release().catchError((e, s) {
                  DefaultLogger().error(null, e, s);
                });
              },
            ),
          ],
        ).toList(),
      ),
    );
  }

  Future<T?> to<T>(BuildContext context, Widget page) => Navigator.push<T>(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
}
