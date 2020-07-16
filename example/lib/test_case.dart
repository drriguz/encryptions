import 'dart:typed_data';

import 'package:encryptions/encryptions.dart';
import 'package:convert/convert.dart';

abstract class TestCase {
  final String name;

  TestCase(this.name);

  Future<bool> execute();
}

class AesTestCase extends TestCase {
  final AES aes;
  final String plain;
  final String expectedEncrypted;

  AesTestCase(String name, this.aes, this.plain, this.expectedEncrypted)
      : super(name);

  @override
  Future<bool> execute() async {
    return validateEncrypt();
  }

  Future<bool> validateEncrypt() async {
    Uint8List encrypted = await aes.encrypt(hex.decode(plain));
    Uint8List decrypted = await aes.decrypt(encrypted);
    return hex.encode(encrypted) == expectedEncrypted &&
        hex.encode(decrypted) == plain;
  }
}

typedef HashMethod = Future<Uint8List> Function(
    Uint8List password, Uint8List salt);

abstract class HashTestCase extends TestCase {
  final String password;
  final String salt;
  final String expectedHashCode;

  HashTestCase(String name, this.password, this.salt, this.expectedHashCode)
      : super(name);

  @override
  Future<bool> execute() async {
    Uint8List hashed =
        await getHashMethod().call(hex.decode(password), hex.decode(salt));
    return hex.encode(hashed) == expectedHashCode;
  }

  HashMethod getHashMethod();
}

class Argon2iTestCase extends HashTestCase {
  final Argon2 argon2;

  Argon2iTestCase(String name, this.argon2, String password, String salt,
      String expectedHashCode)
      : super(name, password, salt, expectedHashCode);

  @override
  HashMethod getHashMethod() => argon2.argon2i;
}

class Argon2dTestCase extends HashTestCase {
  final Argon2 argon2;

  Argon2dTestCase(String name, this.argon2, String password, String salt,
      String expectedHashCode)
      : super(name, password, salt, expectedHashCode);

  @override
  HashMethod getHashMethod() => argon2.argon2d;
}

class Argon2idTestCase extends HashTestCase {
  final Argon2 argon2;

  Argon2idTestCase(String name, this.argon2, String password, String salt,
      String expectedHashCode)
      : super(name, password, salt, expectedHashCode);

  @override
  HashMethod getHashMethod() => argon2.argon2id;
}

class Report {
  final String name;
  final bool success;

  Report(this.name, this.success);
}
