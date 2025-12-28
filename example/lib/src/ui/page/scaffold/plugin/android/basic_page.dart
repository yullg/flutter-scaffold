import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class BasicPage extends StatelessWidget {
  const BasicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Basic"),
      ),
      body: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ElevatedButton(
            onPressed: () {
              SystemClockPlugin.elapsedRealtime().then((v) {
                Toast.showLong(context, "$v");
              });
            },
            child: const Text("elapsedRealtime"),
          ),
          ElevatedButton(
            onPressed: () {
              SystemClockPlugin.uptime().then((v) {
                Toast.showLong(context, "$v");
              });
            },
            child: const Text("uptime"),
          ),
        ],
      ),
    );
  }
}
