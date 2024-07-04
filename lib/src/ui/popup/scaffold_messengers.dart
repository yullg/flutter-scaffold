import 'package:flutter/material.dart';

import '../../core/error_printer.dart';

class ScaffoldMessengers {
  static Future<SnackBarClosedReason> showSnackBar(
    BuildContext context, {
    Widget? content,
    String contentText = "",
    bool? showCloseIcon,
    Duration? duration,
    bool clearQueue = true,
  }) {
    final state = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    if (clearQueue) {
      state.clearSnackBars();
    }
    return state
        .showSnackBar(SnackBar(
          content: content ??
              Text(
                contentText,
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
          backgroundColor: theme.colorScheme.primaryContainer,
          closeIconColor: theme.colorScheme.onPrimaryContainer,
          duration: duration ?? const Duration(seconds: 4),
          showCloseIcon: showCloseIcon,
        ))
        .closed;
  }

  static Future<SnackBarClosedReason> showErrorSnackBar(
    BuildContext context, {
    Object? error,
    String message = "",
    bool? showCloseIcon,
    Duration? duration,
    bool clearQueue = true,
  }) {
    final state = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    if (clearQueue) {
      state.clearSnackBars();
    }
    if (error != null) {
      final newMessage = ErrorPrinters.print(context, error);
      if (newMessage != null) {
        message = newMessage;
      }
    }
    return state
        .showSnackBar(SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
          backgroundColor: theme.colorScheme.errorContainer,
          closeIconColor: theme.colorScheme.onErrorContainer,
          duration: duration ?? const Duration(seconds: 4),
          showCloseIcon: showCloseIcon,
        ))
        .closed;
  }

  static void hideCurrentSnackBar(BuildContext context, {SnackBarClosedReason reason = SnackBarClosedReason.hide}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar(reason: reason);
  }

  static void removeCurrentSnackBar(BuildContext context, {SnackBarClosedReason reason = SnackBarClosedReason.remove}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar(reason: reason);
  }

  static void clearSnackBars(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  ScaffoldMessengers._();
}
