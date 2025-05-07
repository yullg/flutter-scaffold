import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class MediaProjectionPage extends StatelessWidget {
  const MediaProjectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MediaProjection"),
      ),
      body: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ElevatedButton(
            onPressed: () {
              AndroidMediaProjectionPlugin.authorize().ignore();
            },
            child: const Text("authorize()"),
          ),
        ],
      ),
    );
  }
}
