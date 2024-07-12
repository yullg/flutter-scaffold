import 'package:uuid/uuid.dart';

class UuidHelper {
  static String v1() => const Uuid().v1();

  static String v4() => const Uuid().v4();

  UuidHelper._();
}
