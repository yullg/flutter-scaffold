import 'package:flutter/widgets.dart';

abstract interface class ErrorPrinter {
  String? print(BuildContext context, Object error);
}
