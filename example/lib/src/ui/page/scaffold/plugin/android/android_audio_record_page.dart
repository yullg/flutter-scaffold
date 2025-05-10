import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class AndroidAudioRecordPage extends StatelessWidget {
  const AndroidAudioRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AndroidAudioRecord"),
      ),
      body: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {
                  AndroidMediaProjectionPlugin.startAudioPlaybackCapture(
                          notificationId: 1, notificationChannelId: "test")
                      .ignore();
                },
                child: const Text("startAudioPlaybackCapture()"),
              ),
              ElevatedButton(
                onPressed: () {
                  AndroidAudioRecordPlugin.stop().ignore();
                },
                child: const Text("stop()"),
              ),
              ElevatedButton(
                onPressed: () {
                  AndroidAudioRecordPlugin.resume().ignore();
                },
                child: const Text("resume()"),
              ),
              ElevatedButton(
                onPressed: () {
                  AndroidAudioRecordPlugin.release().ignore();
                },
                child: const Text("release()"),
              ),
            ],
          ),
          StreamBuilder(
            stream: AndroidAudioRecordPlugin.statusStream,
            builder: (context, snapshot) {
              return Text("status = ${snapshot.data}");
            },
          ),
          StreamBuilder(
              stream: AndroidAudioRecordPlugin.dataStream,
              builder: (context, snapshot) {
                return Text("data = ${snapshot.data}");
              }),
        ],
      ),
    );
  }
}
