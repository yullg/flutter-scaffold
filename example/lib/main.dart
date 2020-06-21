import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: IconButton(
            iconSize: 72,
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
              Get.defaultDialog(
                  middleText: "Get.isDarkMode=${Get.isDarkMode}",
                  textConfirm: "Confirm",
                  textCancel: "Cancel",
                  textCustom: "Custom",
                  onConfirm: () {});
            },
          ),
        ),
      ),
    );
  }
}
