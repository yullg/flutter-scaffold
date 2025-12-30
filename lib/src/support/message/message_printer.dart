import 'package:flutter/material.dart';

import 'message.dart';

abstract interface class MessagePrinter {
  bool print(BuildContext context, Message message);
}

class CompositeMessagePrinter implements MessagePrinter {
  final Iterable<MessagePrinter> items;

  const CompositeMessagePrinter(this.items);

  @override
  bool print(BuildContext context, Message message) {
    bool result = false;
    for (final item in items) {
      if (item.print(context, message)) {
        result = true;
        break;
      }
    }
    return result;
  }
}

class SnackBarPlainMessagePrinter implements MessagePrinter {
  final bool? Function(BuildContext context, PlainMessage message)? clearQueue;
  final Color? Function(BuildContext context, PlainMessage message)? backgroundColor;
  final Color? Function(BuildContext context, PlainMessage message)? foregroundColor;
  final bool? Function(BuildContext context, PlainMessage message)? showCloseIcon;
  final Color? Function(BuildContext context, PlainMessage message)? closeIconColor;
  final Duration? Function(BuildContext context, PlainMessage message)? duration;

  const SnackBarPlainMessagePrinter({
    this.clearQueue,
    this.backgroundColor,
    this.foregroundColor,
    this.showCloseIcon,
    this.closeIconColor,
    this.duration,
  });

  @override
  bool print(BuildContext context, Message message) {
    if (message is! PlainMessage) return false;
    final state = ScaffoldMessenger.maybeOf(context);
    if (state == null) return false;
    if (clearQueue?.call(context, message) ?? true) {
      state.clearSnackBars();
    }
    state.showSnackBar(
      SnackBar(
        content: Text(message.text, style: TextStyle(color: foregroundColor?.call(context, message))),
        backgroundColor: backgroundColor?.call(context, message),
        showCloseIcon: showCloseIcon?.call(context, message),
        closeIconColor: closeIconColor?.call(context, message),
        duration: duration?.call(context, message) ?? const Duration(seconds: 4),
      ),
    );
    return true;
  }
}
