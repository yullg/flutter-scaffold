import 'package:flutter/widgets.dart';

class RebuildNotification extends Notification {
  const RebuildNotification();
}

class RebuildWidget<T extends RebuildNotification> extends StatefulWidget {
  final Widget Function(BuildContext, T?) builder;
  final bool intercept;

  const RebuildWidget(
      {super.key, required this.builder, this.intercept = true});

  @override
  State<StatefulWidget> createState() => _RebuildWidgetState<T>();
}

class _RebuildWidgetState<T extends RebuildNotification>
    extends State<RebuildWidget<T>> {
  T? notification;

  @override
  Widget build(BuildContext context) => NotificationListener<T>(
        child: Builder(
          builder: (context) => widget.builder(context, notification),
        ),
        onNotification: (notification) {
          this.notification = notification;
          if (mounted) setState(() {});
          return widget.intercept;
        },
      );
}
