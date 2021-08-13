import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart' show rootBundle;

const String _key = "W0Xugt/RymR6Ykdcv3OulZtdKdkgyDlRFefdLJafdc0=";
const String _iv = "oT/K76MtPlRuy9Ksln1dZg==";

Future<String> loadEncryptedAsset(String assetKey) async {
  String encryptedText = await rootBundle.loadString(assetKey);
  Encrypter encrypter = Encrypter(AES(Key.fromBase64(_key)));
  return encrypter.decrypt64(encryptedText, iv: IV.fromBase64(_iv));
}
