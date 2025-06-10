import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoadingState();
}

class _LoadingState extends State<LoadingPage> {
  late final LoadingDialog loadingDialog;

  @override
  void initState() {
    super.initState();
    loadingDialog = LoadingDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loading"),
      ),
      body: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ElevatedButton(
            onPressed: () {
              loadingDialog.message = "测试" * 50;
              loadingDialog.show(context);
              loadingDialog.show(context);
              loadingDialog.close(context);
              loadingDialog.close(context);
              loadingDialog.show(context);
            },
            child: const Text("show()"),
          ),
          ElevatedButton(
            onPressed: () {
              loadingDialog.close(context);
            },
            child: const Text("close()"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    loadingDialog.dispose();
    super.dispose();
  }
}
