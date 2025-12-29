import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<StatefulWidget> createState() => _ExampleState();
}

class _ExampleState extends State<ExamplePage> {
  final allGroups = <ExampleItem>[];

  final groupStack = <ExampleItemGroup>[];

  @override
  void initState() {
    super.initState();
    allGroups.addAll([
      ExampleItemGroup(title: "Toast", children: [
        ExampleItemAction(
          title: "showShort",
          onAction: () {
            Toast.showShort(context, "测试短Toast");
          },
        ),
        ExampleItemAction(
          title: "showLong",
          onAction: () {
            Toast.showLong(context, "测试长Toast");
          },
        ),
        ExampleItemAction(
          title: "cancel",
          onAction: () {
            Toast.cancel();
          },
        ),
      ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final items = groupStack.lastOrNull?.children ?? allGroups;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (groupStack.isNotEmpty) {
              setState(() {
                groupStack.removeLast();
              });
            } else {
              Navigator.maybePop(context);
            }
          },
        ),
        title: Text(groupStack.lastOrNull?.title ?? 'Example'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items.elementAt(index);
          return EasyListTile(
            nameText: item.title,
            descriptionText: item.subtitle,
            trailingIcon: item is ExampleItemGroup ? Icons.navigate_next : null,
            onTap: () {
              switch (item) {
                case ExampleItemGroup():
                  setState(() {
                    groupStack.add(item);
                  });
                case ExampleItemAction():
                  item.onAction();
              }
            },
          );
        },
      ),
    );
  }
}

sealed class ExampleItem {
  final String title;
  final String? subtitle;

  const ExampleItem({required this.title, this.subtitle});
}

class ExampleItemGroup extends ExampleItem {
  final Iterable<ExampleItem> children;

  const ExampleItemGroup({required super.title, super.subtitle, required this.children});
}

class ExampleItemAction extends ExampleItem {
  final VoidCallback onAction;

  const ExampleItemAction({required super.title, super.subtitle, required this.onAction});
}
