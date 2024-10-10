import 'package:flutter/material.dart';

import '../../config/scaffold_config.dart';
import 'toast.dart';

class Messenger {
  static void show(
    BuildContext context,
    String message, {
    MessageStyle? style,
  }) {
    style = _mergeStyle(
      self: style,
      other: ScaffoldConfig.messengerOption?.style?.get(context),
    );
    style ??= const ToastMessageStyle();
    switch (style) {
      case ToastMessageStyle():
        toast(context, message, style: style);
      case SnackBarMessageStyle():
        snackBar(context, contentText: message, style: style);
    }
  }

  static void showError(
    BuildContext context, {
    Object? error,
    String? message,
    MessageStyle? style,
  }) {
    message = _printError(context, error) ?? message ?? "";
    style = _mergeStyle(
      self: style,
      other: ScaffoldConfig.messengerOption?.errorStyle?.get(context),
    );
    show(context, message, style: style);
  }

  static void toast(
    BuildContext context,
    String text, {
    ToastMessageStyle? style,
  }) {
    Toast.show(context, text, style?.longDuration ?? false);
  }

  static Future<SnackBarClosedReason> snackBar(
    BuildContext context, {
    Widget? content,
    String? contentText,
    SnackBarMessageStyle? style,
    bool clearQueue = true,
  }) {
    final state = ScaffoldMessenger.of(context);
    if (clearQueue) {
      state.clearSnackBars();
    }
    return state
        .showSnackBar(SnackBar(
          content: content ??
              Text(
                contentText ?? "",
                style: TextStyle(
                  color: style?.foregroundColor,
                ),
              ),
          backgroundColor: style?.backgroundColor,
          showCloseIcon: style?.showCloseIcon,
          closeIconColor: style?.closeIconColor,
          duration: style?.duration ?? const Duration(seconds: 4),
        ))
        .closed;
  }

  static MessageStyle? _mergeStyle({MessageStyle? self, MessageStyle? other}) {
    if (self == null) {
      return other;
    }
    if (other == null) {
      return self;
    }
    switch (self) {
      case ToastMessageStyle():
        if (other is ToastMessageStyle) {
          return ToastMessageStyle(
            longDuration: self.longDuration ?? other.longDuration,
          );
        } else {
          return self;
        }
      case SnackBarMessageStyle():
        if (other is SnackBarMessageStyle) {
          return SnackBarMessageStyle(
            backgroundColor: self.backgroundColor ?? other.backgroundColor,
            foregroundColor: self.foregroundColor ?? other.foregroundColor,
            showCloseIcon: self.showCloseIcon ?? other.showCloseIcon,
            closeIconColor: self.closeIconColor ?? other.closeIconColor,
            duration: self.duration ?? other.duration,
          );
        } else {
          return self;
        }
    }
  }

  static String? _printError(BuildContext context, Object? error) {
    if (error != null) {
      final printers = ScaffoldConfig.messengerOption?.errorPrinters;
      if (printers != null && printers.isNotEmpty) {
        for (final printer in printers) {
          final result = printer.print(context, error);
          if (result != null) {
            return result;
          }
        }
      }
    }
    return null;
  }

  Messenger._();
}

sealed class MessageStyle {
  const MessageStyle();
}

class ToastMessageStyle extends MessageStyle {
  final bool? longDuration;

  const ToastMessageStyle({
    this.longDuration,
  });
}

class SnackBarMessageStyle extends MessageStyle {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool? showCloseIcon;
  final Color? closeIconColor;
  final Duration? duration;

  const SnackBarMessageStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.showCloseIcon,
    this.closeIconColor,
    this.duration,
  });
}
