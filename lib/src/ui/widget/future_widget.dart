import 'package:flutter/material.dart';

class FutureWidget<T> extends StatefulWidget {
  final Future<T>? future;
  final Widget Function(BuildContext, T) valueWidgetBuilder;
  final WidgetBuilder waitingWidgetBuilder;
  final Widget Function(BuildContext, Object) failedWidgetBuilder;
  final WidgetBuilder noneWidgetBuilder;

  const FutureWidget({
    super.key,
    required this.future,
    required this.valueWidgetBuilder,
    this.waitingWidgetBuilder = _defaultWaitingWidgetBuilder,
    this.failedWidgetBuilder = _defaultFailedWidgetBuilder,
    this.noneWidgetBuilder = _defaultNoneWidgetBuilder,
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
            return widget.failedWidgetBuilder(context, snapshot.error!);
          } else if (!snapshot.hasData) {
            return widget.noneWidgetBuilder(context);
          } else {
            return widget.valueWidgetBuilder(context, snapshot.requireData);
          }
        },
      );
}

Widget _defaultWaitingWidgetBuilder(BuildContext context) =>
    const Center(child: CircularProgressIndicator());

Widget _defaultFailedWidgetBuilder(BuildContext context, Object error) =>
    const SizedBox.expand();

Widget _defaultNoneWidgetBuilder(BuildContext context) =>
    const SizedBox.expand();
