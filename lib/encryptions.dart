import 'dart:async';
import 'dart:typed_data';

import 'package:encryptions/hex.dart';
import 'package:flutter/services.dart';

class Encryptions {
  static const MethodChannel _channel = const MethodChannel('encryptions');

  static Future<Uint8List> aesEncrypt(
      Uint8List key, Uint8List iv, Uint8List value) async {
    return await _channel
        .invokeMethod("aesEncrypt", {"key": key, "iv": iv, "value": value});
  }

  static Future<Uint8List> aesDecrypt(
      Uint8List key, Uint8List iv, Uint8List value) async {
    return await _channel
        .invokeMethod("aesDecrypt", {"key": key, "iv": iv, "value": value});
  }

  static Future<Uint8List> aesEncryptInHex(
      String key, String iv, String value) async {
    return aesEncrypt(Hex.decode(key), Hex.decode(iv), Hex.decode(value));
  }

  static Future<Uint8List> aesDecryptInHex(
      String key, String iv, String value) async {
    return aesDecrypt(Hex.decode(key), Hex.decode(iv), Hex.decode(value));
  }

  static Future<Uint8List> argon2i(String password, String salt) async {
    return await _channel
        .invokeMethod("argon2i", {"password": password, "salt": salt});
  }

  static Future<Uint8List> argon2d(String password, String salt) async {
    return await _channel
        .invokeMethod("argon2d", {"password": password, "salt": salt});
  }
}
