import 'package:uuid/uuid.dart';

class UuidHelper {
  static final _uuid = Uuid();

  static String v1() => _uuid.v1();

  static String v4() => _uuid.v4();

  UuidHelper._();
}
