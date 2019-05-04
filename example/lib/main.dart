import 'package:encryptions/hex.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:encryptions/encryptions.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    const String key =
        "dce60234d641f71f377ecafb5a566ce954d26c03fd3b5b23e9ed092ef42b5290";
    const String iv = "c1f6fd873e14050697c168b3e9da5db2";
    const String value = "01040000000300000002400000008B2E";
    String result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      Uint8List encrypted = await Encryptions.aesEncryptInHex(key, iv, value);
      Uint8List decrypted = await Encryptions.aesDecrypt(
          Hex.decode(key), Hex.decode(iv), encrypted);
      result = "Original:" +
          value +
          "\nEncrypted:" +
          Hex.encode(encrypted) +
          "\nDecrypted:" +
          Hex.encode(decrypted);

      Uint8List argon2i = await Encryptions.argon2i("password", "hello world!");
      result += "\nArgon2i:" + Hex.encode(argon2i);
    } on PlatformException {
      result = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('AES Encryption Result:\n$_result\n'),
        ),
      ),
    );
  }
}
