import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

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
          CancellationErrorPrinter(),
        ],
      ),
    );
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
            EasyListTile(
              nameText: "Messenger Demo",
              trailingIcon: Icons.arrow_forward_ios,
              onTap: () {
                to(context, const MessengerPage());
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
