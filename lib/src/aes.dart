import 'dart:isolate';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:encryptions/src/cipher_options.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

final Uint8List _emptyIv = hex.decode("00000000000000000000000000000000");

class AES {
  static const MethodChannel _platform = const MethodChannel('encryptions');

  final BlockCipherMode _mode;
  final Uint8List _key;
  final Uint8List _iv;
  final PaddingScheme _padding;

  AES._(this._mode, this._key, this._iv, this._padding) {
    ArgumentError.checkNotNull(this._key);
    if (this._mode == BlockCipherMode.CBC) {
      ArgumentError.checkNotNull(this._iv);
      if (this._iv.length != 16) throw ArgumentError("Iv size should be 16 bytes: actual is ${_iv.length}");
    }
    if (this._key.length != 16 && this._key.length != 32)
      throw ArgumentError("Key size should be 16 bytes(AES-128) or 32 bytes(AES-256): actual is ${_key.length}");
  }

  factory AES.ofCBC(Uint8List key, Uint8List iv, PaddingScheme padding) {
    return AES._(BlockCipherMode.CBC, key, iv, padding);
  }

  factory AES.ofECB(Uint8List key, PaddingScheme padding) {
    return AES._(BlockCipherMode.ECB, key, _emptyIv, padding);
  }

  String get mode => _mode.toString().split('.').last;

  String get padding => _padding.toString().split('.').last;

  Map<String, dynamic> createAESArguments(Uint8List value) => {
        "mode": mode,
        "padding": padding,
        "key": _key,
        "iv": _iv,
        "value": value,
      };

  Future<Uint8List> encrypt(final Uint8List bytes) async {
    ArgumentError.checkNotNull(bytes);
    if (_padding == PaddingScheme.NoPadding && bytes.lengthInBytes % 16 != 0)
      throw ArgumentError("Bytes length must be multiple of block length");
    return _platform.invokeMethod("aesEncrypt", createAESArguments(bytes));
  }

  Future<Uint8List> decrypt(final Uint8List bytes) async {
    ArgumentError.checkNotNull(bytes);

    return _platform.invokeMethod("aesDecrypt", createAESArguments(bytes));
  }

  Future<Uint8List> encryptIsolated(final Uint8List bytes) async {
    ArgumentError.checkNotNull(bytes);
    if (_padding == PaddingScheme.NoPadding && bytes.lengthInBytes % 16 != 0)
      throw ArgumentError("Bytes length must be multiple of block length");
    return _aesIsolated("aesEncrypt", bytes);
  }

  Future<Uint8List> decryptIsolated(final Uint8List bytes) async {
    ArgumentError.checkNotNull(bytes);

    return _aesIsolated("aesDecrypt", bytes);
  }

  static void _aesCall(SendPort replyPort) async {
    final receivePort = ReceivePort();
    replyPort.send(receivePort.sendPort);

    final List<dynamic> params = await receivePort.first;

    int i = 0;
    final SendPort returnValuePort = params[i++];

    final String methodName = params[i++] as String;
    final String mode = params[i++] as String;
    final String padding = params[i++] as String;
    final Uint8List key = hex.decode(params[i++] as String);
    final Uint8List iv = hex.decode(params[i++] as String);
    final Uint8List value = hex.decode(params[i++] as String);

    final Uint8List result = await _platform.invokeMethod(methodName, {
      "mode": mode,
      "padding": padding,
      "key": key,
      "iv": iv,
      "value": value,
    });
    returnValuePort.send(hex.encode(result));
  }

  Future<Uint8List> _aesIsolated(String method, Uint8List value) async {
    final ReceivePort response = ReceivePort();
    final isolate = await FlutterIsolate.spawn(_aesCall, response.sendPort);
    final SendPort argumentSendPort = await response.first;
    final ReceivePort returnPort = ReceivePort();
    argumentSendPort.send([
      returnPort.sendPort,
      method,
      mode,
      padding,
      hex.encode(_key),
      hex.encode(_iv),
      hex.encode(value),
    ]);

    final String result = await returnPort.first;

    isolate.kill();

    return hex.decode(result);
  }
}
