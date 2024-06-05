import 'package:flutter/widgets.dart';

class FutureWidget<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final WidgetBuilder? waitingBuilder;
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  const FutureWidget({
    super.key,
    required this.future,
    required this.builder,
    this.waitingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return waitingBuilder?.call(context) ?? const SizedBox.shrink();
          } else if (snapshot.hasError) {
            return errorBuilder?.call(context, snapshot.error!) ?? const SizedBox.shrink();
          } else {
            return builder(context, snapshot.data as T);
          }
        },
      );
}
