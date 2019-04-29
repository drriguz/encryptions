import 'dart:async';

import 'package:flutter/services.dart';

class Encryptions {
  static const MethodChannel _channel =
      const MethodChannel('encryptions');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
