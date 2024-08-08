import '../core/error_print.dart';

class ScaffoldErrorPrintOption {
  final Iterable<ErrorPrinter>? printers;

  const ScaffoldErrorPrintOption({
    this.printers,
  });

  @override
  String toString() {
    return 'ScaffoldErrorPrintOption{printers: $printers}';
  }
}
