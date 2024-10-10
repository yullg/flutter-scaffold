import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage({super.key});

  @override
  State<StatefulWidget> createState() => _MessengerState();
}

class _MessengerState extends State<MessengerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messenger Demo'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            EasyListTile(
              nameText: "show()",
              onTap: () {
                Messenger.show(context, "show()");
              },
            ),
            EasyListTile(
              nameText: "showError()",
              onTap: () {
                Messenger.showError(context,
                    error: CancellationError(), message: "showError()");
              },
            ),
            EasyListTile(
              nameText: "toast()",
              onTap: () {
                Messenger.toast(context, "toast()");
              },
            ),
            EasyListTile(
              nameText: "snackBar()",
              onTap: () {
                Messenger.snackBar(context, contentText: "snackBar()");
              },
            ),
          ],
        ).toList(),
      ),
    );
  }
}

class CancellationErrorPrinter implements ErrorPrinter {
  @override
  String? print(BuildContext context, Object error) {
    if (error is CancellationError) {
      return "取消操作";
    }
    return null;
  }
}
