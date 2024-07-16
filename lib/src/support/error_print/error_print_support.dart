import 'package:flutter/widgets.dart';

import 'error_printer.dart';

class ErrorPrintSupport {
  static final _printers = <ErrorPrinter>[];

  static void initialize({Iterable<ErrorPrinter>? printers}) {
    _printers.clear();
    if (printers != null) {
      _printers.addAll(printers);
    }
  }

  static String? print(BuildContext context, Object error) {
    for (final printer in _printers) {
      final result = printer.print(context, error);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  static void destroy() {
    _printers.clear();
  }

  ErrorPrintSupport._();
}
