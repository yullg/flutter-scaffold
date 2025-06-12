import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

class PolymorphicTextPage extends StatelessWidget {
  const PolymorphicTextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Polymorphic Text"),
      ),
      body: Center(
        child: Container(
          color: Colors.black12,
          width: 300,
          child: PolymorphicText(
            text: "a" * 500,
            textExpand: "更多",
            textCollapse: "收起",
            maxLinesCollapse: 3,
            maxLinesExpand: 6,
            // maxLinesExpand: 5,
          ),
        ),
      ),
    );
  }
}
