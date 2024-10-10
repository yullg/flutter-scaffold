import 'package:flutter/widgets.dart';

import '../core/error_print.dart';
import '../core/supplier.dart';
import '../ui/popup/messenger.dart';

class ScaffoldMessengerOption {
  final Supplier<BuildContext, MessageStyle?>? style;
  final Supplier<BuildContext, MessageStyle?>? errorStyle;
  final Iterable<ErrorPrinter>? errorPrinters;

  const ScaffoldMessengerOption({
    this.style,
    this.errorStyle,
    this.errorPrinters,
  });

  @override
  String toString() {
    return 'ScaffoldMessengerOption{style: $style, errorStyle: $errorStyle, errorPrinters: $errorPrinters}';
  }
}
