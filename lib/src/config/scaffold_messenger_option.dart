import '../support/message/error_to_message.dart';
import '../support/message/message_printer.dart';

class ScaffoldMessengerOption {
  final MessagePrinter? messagePrinter;
  final ErrorToMessage? errorToMessage;

  const ScaffoldMessengerOption({this.messagePrinter, this.errorToMessage});

  @override
  String toString() {
    return 'ScaffoldMessengerOption{messagePrinter: $messagePrinter, errorToMessage: $errorToMessage}';
  }
}
