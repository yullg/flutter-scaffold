import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class ToastPage extends StatelessWidget {
  const ToastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toast"),
      ),
      body: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ElevatedButton(
            onPressed: () {
              AndroidToastPlugin.show(
                      text: "测试短Toast",
                      duration: AndroidToastPlugin.kDurationLengthShort)
                  .ignore();
            },
            child: const Text("show(short)"),
          ),
          ElevatedButton(
            onPressed: () {
              AndroidToastPlugin.show(
                      text: "测试长Toast",
                      duration: AndroidToastPlugin.kDurationLengthLong)
                  .ignore();
            },
            child: const Text("show(long)"),
          ),
          ElevatedButton(
            onPressed: () {
              AndroidToastPlugin.cancel().ignore();
            },
            child: const Text("cancel()"),
          ),
        ],
      ),
    );
  }
}
