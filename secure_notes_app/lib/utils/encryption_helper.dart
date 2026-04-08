import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  static final _key = Key.fromUtf8('1234567890123456'); // MUST be 16/24/32 chars
  static final _iv = IV.fromLength(16);

  static final _encrypter = Encrypter(AES(_key));

  static String encrypt(String text) {
    final encrypted = _encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  static String decrypt(String text) {
    final decrypted = _encrypter.decrypt64(text, iv: _iv);
    return decrypted;
  }
}