import 'package:flutter/widgets.dart';

class FutureWidget<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext, T) builder;
  final WidgetBuilder? waitingWidgetBuilder;
  final Widget Function(BuildContext, Object)? errorWidgetBuilder;

  const FutureWidget({
    super.key,
    required this.future,
    required this.builder,
    this.waitingWidgetBuilder,
    this.errorWidgetBuilder,
  });

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return waitingWidgetBuilder?.call(context) ?? const SizedBox.shrink();
          } else if (snapshot.hasError) {
            return errorWidgetBuilder?.call(context, snapshot.error!) ?? const SizedBox.shrink();
          } else {
            return builder(context, snapshot.data as T);
          }
        },
      );
}
