import 'package:flutter/widgets.dart';

class ScrollableColumn extends StatelessWidget {
  final bool reverse;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final HitTestBehavior hitTestBehavior;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;

  const ScrollableColumn({
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
          reverse: reverse,
          padding: padding,
          physics: physics,
          controller: controller,
          hitTestBehavior: hitTestBehavior,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: children,
            ),
          ),
        ),
      );
}

class ScrollableIntrinsicHeightColumn extends StatelessWidget {
  final bool reverse;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final HitTestBehavior hitTestBehavior;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;

  const ScrollableIntrinsicHeightColumn({
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
          reverse: reverse,
          padding: padding,
          physics: physics,
          controller: controller,
          hitTestBehavior: hitTestBehavior,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: crossAxisAlignment,
                children: children,
              ),
            ),
          ),
        ),
      );
}
