import 'dart:io';

import 'package:flutter/services.dart';

class ProcessHelper {
  static Never killMe() {
    SystemNavigator.pop();
    exit(0);
  }

  ProcessHelper._();
}
