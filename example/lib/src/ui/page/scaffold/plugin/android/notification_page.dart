import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
      ),
      body: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ElevatedButton(
            onPressed: () {
              AndroidNotificationPlugin.createNotificationChannel(
                      id: "test", importance: 3, name: "测试")
                  .ignore();
            },
            child: const Text("createNotificationChannel()"),
          ),
        ],
      ),
    );
  }
}
