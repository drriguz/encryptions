import 'dart:isolate';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

class Argon2 {
  static const MethodChannel _platform = const MethodChannel('encryptions');

  final int iterations;
  final int memory; // KB
  final int parallelism;
  final int hashLength;

  Argon2({
    this.iterations = 2,
    this.memory = 65536, // 64MB
    this.parallelism = 1,
    this.hashLength = 32,
  });

  static void _argon2Call(SendPort replyPort) async {
    final receivePort = ReceivePort();
    replyPort.send(receivePort.sendPort);

    final List<dynamic> params = await receivePort.first;

    int i = 0;
    final SendPort returnValuePort = params[i++];

    final String hashMethodName = params[i++] as String;

    final Argon2 argon2 = Argon2(
      iterations: params[i++] as int,
      memory: params[i++] as int,
      parallelism: params[i++] as int,
      hashLength: params[i++] as int,
    );

    final Uint8List password = hex.decode(params[i++] as String) as Uint8List;
    final Uint8List salt = hex.decode(params[i++] as String) as Uint8List;

    final Uint8List result = await argon2._invokeNative(hashMethodName, password, salt);
    returnValuePort.send(hex.encode(result));
  }

  Future<Uint8List> _invokeNative(String method, Uint8List password, Uint8List salt) {
    return _platform.invokeMethod(method, _createParams(password, salt));
  }

  Future<Uint8List> _argon2Isolated(String method, Uint8List password, Uint8List salt) async {
    final ReceivePort response = ReceivePort();
    final isolate = await FlutterIsolate.spawn(_argon2Call, response.sendPort);
    final SendPort argumentSendPort = await response.first;
    final ReceivePort returnPort = ReceivePort();
    argumentSendPort.send([
      returnPort.sendPort,
      method,
      iterations,
      memory,
      parallelism,
      hashLength,
      hex.encode(password),
      hex.encode(salt),
    ]);
    final String result = await returnPort.first;

    // do we need to kill that?
    isolate.kill();

    return hex.decode(result);
  }

  Future<Uint8List> argon2iIsolated(Uint8List password, Uint8List salt) async {
    return _argon2Isolated("argon2i", password, salt);
  }

  Future<Uint8List> argon2dIsolated(Uint8List password, Uint8List salt) async {
    return _argon2Isolated("argon2d", password, salt);
  }

  Future<Uint8List> argon2idIsolated(Uint8List password, Uint8List salt) async {
    return _argon2Isolated("argon2id", password, salt);
  }

  Future<Uint8List> argon2i(Uint8List password, Uint8List salt) {
    return _platform.invokeMethod("argon2i", _createParams(password, salt));
  }

  Future<Uint8List> argon2d(Uint8List password, Uint8List salt) {
    return _platform.invokeMethod("argon2d", _createParams(password, salt));
  }

  Future<Uint8List> argon2id(Uint8List password, Uint8List salt) {
    return _platform.invokeMethod("argon2id", _createParams(password, salt));
  }

  Map<String, dynamic> _createParams(Uint8List password, Uint8List salt) => {
        "iterations": iterations,
        "memory": memory,
        "parallelism": parallelism,
        "hashLength": hashLength,
        "password": password,
        "salt": salt,
      };
}
