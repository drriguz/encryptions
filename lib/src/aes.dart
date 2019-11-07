import 'dart:typed_data';

import 'package:encryptions/src/cipher_options.dart';
import 'package:flutter/services.dart';

class AES {
  static const MethodChannel _platform = const MethodChannel('encryptions_aes');

  final BlockCipherMode _mode;
  final Uint8List _key;
  final Uint8List _iv;
  final PaddingScheme _padding;

  AES._(this._mode, this._key, this._iv, this._padding) {
    ArgumentError.checkNotNull(this._key);
    ArgumentError.checkNotNull(this._iv);
    if (this._key.length != 16 && this._key.length != 32)
      throw ArgumentError(
          "Key size should be 16 bytes(AES-128) or 32 bytes(AES-256): actual is ${_key.length}");
    if (this._iv.length != 16)
      throw ArgumentError(
          "Iv size should be 16 bytes: actual is ${_iv.length}");
  }

  factory AES.ofCBC(Uint8List key, Uint8List iv, PaddingScheme padding) {
    return AES._(BlockCipherMode.CBC, key, iv, padding);
  }

  factory AES.ofECB(Uint8List key, PaddingScheme padding) {
    return AES._(BlockCipherMode.CBC, key, null, padding);
  }

  Map<String, dynamic> createAESArguments() => {
        "mode": _mode.toString().split('.').last,
        "padding": _padding.toString().split('.').last,
        "key": _key,
        "iv": _iv,
      };

  Future<Uint8List> encrypt(final Uint8List bytes) async {
    ArgumentError.checkNotNull(bytes);

    return _platform.invokeMethod("aesEncrypt", createAESArguments());
  }

  Future<Uint8List> decrypt(final Uint8List bytes) async {
    ArgumentError.checkNotNull(bytes);

    return _platform.invokeMethod("aesDecrypt", createAESArguments());
  }
}
