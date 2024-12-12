import 'package:flutter/widgets.dart';

class ScrollableRow extends StatelessWidget {
  final bool reverse;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final HitTestBehavior hitTestBehavior;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;

  const ScrollableRow({
    super.key,
    this.reverse = false,
    this.padding,
    this.physics,
    this.controller,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.children = const <Widget>[],
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: reverse,
          padding: padding,
          physics: physics,
          controller: controller,
          hitTestBehavior: hitTestBehavior,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: children,
            ),
          ),
        ),
      );
}

class ScrollableIntrinsicWidthRow extends StatelessWidget {
  final bool reverse;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final HitTestBehavior hitTestBehavior;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;

  const ScrollableIntrinsicWidthRow({
    super.key,
    this.reverse = false,
    this.padding,
    this.physics,
    this.controller,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.children = const <Widget>[],
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: reverse,
          padding: padding,
          physics: physics,
          controller: controller,
          hitTestBehavior: hitTestBehavior,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
            ),
            child: IntrinsicWidth(
              child: Row(
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: crossAxisAlignment,
                children: children,
              ),
            ),
          ),
        ),
      );
}
