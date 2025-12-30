import 'package:flutter/widgets.dart';

import 'message.dart';

abstract interface class ErrorToMessage {
  Message? to(BuildContext context, Object error);
}

class CompositeErrorToMessage implements ErrorToMessage {
  final Iterable<ErrorToMessage> items;

  const CompositeErrorToMessage(this.items);

  @override
  Message? to(BuildContext context, Object error) {
    Message? message;
    for (final item in items) {
      message = item.to(context, error);
      if (message != null) {
        break;
      }
    }
    return message;
  }
}
