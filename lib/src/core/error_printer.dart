import 'package:flutter/widgets.dart';

import '../scaffold_module.dart';

abstract interface class ErrorPrinter {
  String? print(BuildContext context, Object error);
}

class ErrorPrinters {
  static String? print(BuildContext context, Object error) {
    final printers = ScaffoldModule.config.errorPrinters;
    if (printers != null) {
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
