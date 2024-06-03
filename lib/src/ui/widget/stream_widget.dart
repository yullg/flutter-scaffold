import 'package:flutter/widgets.dart';

class StreamWidget<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext context, T data, bool haveDone) builder;
  final WidgetBuilder? waitingWidgetBuilder;
  final Widget Function(BuildContext context, bool haveDone)? emptyWidgetBuilder;
  final Widget Function(BuildContext context, Object error, bool haveDone)? errorWidgetBuilder;

  const StreamWidget({
    super.key,
    required this.stream,
    required this.builder,
    this.waitingWidgetBuilder,
    this.emptyWidgetBuilder,
    this.errorWidgetBuilder,
  });

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return waitingWidgetBuilder?.call(context) ?? const SizedBox.shrink();
            case ConnectionState.active:
              if (snapshot.hasError) {
                return errorWidgetBuilder?.call(context, snapshot.error!, false) ?? const SizedBox.shrink();
              } else {
                return builder(context, snapshot.data as T, false);
              }
            case ConnectionState.done:
              if (snapshot.hasError) {
                return errorWidgetBuilder?.call(context, snapshot.error!, true) ?? const SizedBox.shrink();
              } else if (snapshot.hasData) {
                return builder(context, snapshot.requireData, true);
              } else {
                return emptyWidgetBuilder?.call(context, true) ?? const SizedBox.shrink();
              }
          }
        },
      );
}
