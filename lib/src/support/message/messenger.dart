import 'package:flutter/material.dart';

import '../../config/scaffold_config.dart';
import 'error_to_message.dart';
import 'message.dart';
import 'message_printer.dart';

class Messenger {
  static void show(BuildContext context, Message? message, {MessagePrinter? printer}) {
    if (message == null) return;
    printer ??= ScaffoldConfig.messengerOption?.messagePrinter;
    if (printer == null) return;
    printer.print(context, message);
  }

  static void showError(
    BuildContext context,
    Object? error, {
    ErrorToMessage? errorToMessage,
    MessagePrinter? printer,
  }) {
    if (error == null) return;
    final message = (errorToMessage ?? ScaffoldConfig.messengerOption?.errorToMessage)?.to(context, error);
    show(context, message, printer: printer);
  }

  static void showPlain(
    BuildContext context,
    String? text, {
    PlainMessageType type = PlainMessageType.normal,
    MessagePrinter? printer,
  }) {
    if (text == null) return;
    show(context, PlainMessage(text, type: type), printer: printer);
  }

  Messenger._();
}
