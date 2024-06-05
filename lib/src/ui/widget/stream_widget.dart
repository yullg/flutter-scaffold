import 'package:flutter/widgets.dart';

class StreamWidget<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext context, T data, bool isDone) builder;
  final Widget Function(BuildContext context, bool isDone)? waitingBuilder;
  final Widget Function(BuildContext context, Object error, bool isDone)? errorBuilder;

  const StreamWidget({
    super.key,
    required this.stream,
    required this.builder,
    this.waitingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return waitingBuilder?.call(context, false) ?? const SizedBox.shrink();
            case ConnectionState.active:
              if (snapshot.hasError) {
                return errorBuilder?.call(context, snapshot.error!, false) ?? const SizedBox.shrink();
              } else {
                return builder(context, snapshot.data as T, false);
              }
            case ConnectionState.done:
              if (snapshot.hasError) {
                return errorBuilder?.call(context, snapshot.error!, true) ?? const SizedBox.shrink();
              } else {
                final data = snapshot.data;
                if (data is T) {
                  return builder(context, data, true);
                } else {
                  return waitingBuilder?.call(context, true) ?? const SizedBox.shrink();
                }
              }
          }
        },
      );
}
