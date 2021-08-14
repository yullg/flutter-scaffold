import 'package:encrypt/encrypt.dart';

const String _key = "W0Xugt/RymR6Ykdcv3OulZtdKdkgyDlRFefdLJafdc0=";
const String _iv = "oT/K76MtPlRuy9Ksln1dZg==";

class AssetEncrypter {
  static String encrypt(String plainText) {
    var encrypter = Encrypter(AES(Key.fromBase64(_key)));
    return encrypter.encrypt(plainText, iv: IV.fromBase64(_iv)).base64;
  }

  static String decrypt(String encryptedText) {
    Encrypter encrypter = Encrypter(AES(Key.fromBase64(_key)));
    return encrypter.decrypt64(encryptedText, iv: IV.fromBase64(_iv));
  }

  AssetEncrypter._();
}
