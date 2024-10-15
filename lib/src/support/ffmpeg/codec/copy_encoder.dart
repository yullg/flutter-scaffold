import 'encoder.dart';

class CopyEncoder implements Encoder {
  const CopyEncoder();

  @override
  String get name => "copy";

  @override
  List<String>? get options => null;
}
