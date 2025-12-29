import 'dart:io';

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
              Future(() {
                if (Platform.isAndroid) {
                  return AndroidBasicPlugin.invoke(
                    SystemClockABM.kElapsedRealtime,
                  ).then((v) => v != null ? Duration(milliseconds: v) : Duration.zero);
                } else {
                  return IsoBasicPlugin.invoke(
                    ProcessInfoIBM.kSystemUptime,
                  ).then((v) => v != null ? Duration(seconds: v.round()) : Duration.zero);
                }
              }).then((v) {
                Toast.showLong(context, "$v");
              });
            },
            child: const Text("elapsedRealtime"),
          ),
          ElevatedButton(
            onPressed: () {
              Future(() {
                if (Platform.isAndroid) {
                  return AndroidBasicPlugin.invoke(
                    SystemClockABM.kUptimeMillis,
                  ).then((v) => v != null ? Duration(milliseconds: v) : Duration.zero);
                } else {
                  return IsoBasicPlugin.invoke(
                    ProcessInfoIBM.kSystemUptime,
                  ).then((v) => v != null ? Duration(seconds: v.round()) : Duration.zero);
                }
              }).then((v) {
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
