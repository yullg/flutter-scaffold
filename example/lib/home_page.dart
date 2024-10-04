import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

import 'canvas_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
