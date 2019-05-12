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

  Future<String> testAes(String method, String key, String iv, String value,
      String expected) async {
    var success = true;
    try {
      Uint8List encrypted = await Encryptions.aesEncryptInHex(key, iv, value);
      Uint8List decrypted = await Encryptions.aesDecrypt(
          Hex.decode(key), Hex.decode(iv), encrypted);

      success =
          Hex.encode(encrypted) == expected && Hex.encode(decrypted) == value;
    } on PlatformException {
      success = false;
    }
    return method + ":" + (success ? "✔ " : "✗");
  }

  Future<String> testAes256CBCNoPadding() async {
    const String key =
        "dce60234d641f71f377ecafb5a566ce954d26c03fd3b5b23e9ed092ef42b5290";
    const String iv = "c1f6fd873e14050697c168b3e9da5db2";
    const String value = "01040000000300000002400000008b2e";
    const String expectedEncrypted = "9a0106470245744f9121bbafa5dd10df";

    return testAes("Aes256/CBC/NoPadding", key, iv, value, expectedEncrypted);
  }

  Future<String> testAes128CBCNoPadding() async {
    const String key = "dce60234d641f71f377ecafb5a566ce9";
    const String iv = "c1f6fd873e14050697c168b3e9da5db2";
    const String value = "01040000000300000002400000008b2e";
    const String expectedEncrypted = "64fb88a3f1a4d75d05c5508b2f2d4893";

    return testAes("Aes128/CBC/NoPadding", key, iv, value, expectedEncrypted);
  }

  Future<String> testArgon2i() async {
    final Uint8List hashed =
        await Encryptions.argon2i("password", "helloworld");
    final expected =
        "1fe7d8ae9f8946a5170aa6b96e8eea69b5f9351cbe457c4776e01f0b72a1e40e";
    final success = expected == Hex.encode(hashed);

    print("#####" + Hex.encode(hashed));
    return "argon2i:" + (success ? "✔ " : "✗");
  }

  Future<String> testArgon2d() async {
    final Uint8List hashed =
        await Encryptions.argon2d("password", "helloworld");
    final expected =
        "251c68a5591a838647b5afa7d1379cc63690daffcedb1e725528789014064fab";
    final success = expected == Hex.encode(hashed);

    return "argon2d:" + (success ? "✔ " : "✗");
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final String result = await testAes256CBCNoPadding() +
        "\n" +
        await testAes128CBCNoPadding() +
        "\n" +
        await testArgon2i() +
        "\n" +
        await testArgon2d();

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
          child: Text('Test result:\n$_result\n'),
        ),
      ),
    );
  }
}
