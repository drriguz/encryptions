import 'dart:typed_data';

import 'package:flutter/services.dart';

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

  argon2i(Uint8List password, Uint8List salt) {
    return _platform.invokeMethod("argon2i", _createParams(password, salt));
  }

  argon2d(Uint8List password, Uint8List salt) {
    return _platform.invokeMethod("argon2d", _createParams(password, salt));
  }

  argon2id(Uint8List password, Uint8List salt) {
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
