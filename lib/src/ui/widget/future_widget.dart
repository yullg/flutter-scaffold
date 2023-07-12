import 'package:flutter/material.dart';

class FutureWidget<T> extends StatefulWidget {
  final Future<T> future;
  final Widget Function(BuildContext, T) builder;
  final WidgetBuilder waitingWidgetBuilder;
  final Widget Function(BuildContext, Object) errorWidgetBuilder;

  const FutureWidget({
    super.key,
    required this.future,
    required this.builder,
    this.waitingWidgetBuilder = _defaultWaitingWidgetBuilder,
    this.errorWidgetBuilder = _defaultErrorWidgetBuilder,
  });

  @override
  State<StatefulWidget> createState() => _FutureWidgetState<T>();
}

class _FutureWidgetState<T> extends State<FutureWidget<T>> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: widget.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return widget.waitingWidgetBuilder(context);
          } else if (snapshot.hasError) {
            return widget.errorWidgetBuilder(context, snapshot.error!);
          } else {
            return widget.builder(context, snapshot.data as T);
          }
        },
      );
}

Widget _defaultWaitingWidgetBuilder(BuildContext context) => const CircularProgressIndicator();

Widget _defaultErrorWidgetBuilder(BuildContext context, Object error) => const SizedBox.shrink();
