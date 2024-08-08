import 'package:flutter/widgets.dart';

import '../config/scaffold_config.dart';

class ErrorPrinters {
  static String? print(BuildContext context, Object error) {
    final printers = ScaffoldConfig.errorPrintOption?.printers;
    if (printers != null && printers.isNotEmpty) {
      for (final printer in printers) {
        final result = printer.print(context, error);
        if (result != null) {
          return result;
        }
      }
    }
    return null;
  }

  ErrorPrinters._();
}

abstract interface class ErrorPrinter {
  String? print(BuildContext context, Object error);
}
