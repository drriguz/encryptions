import 'dart:typed_data';

import 'package:encryptions/encryptions.dart';
import 'package:convert/convert.dart';

class PlatformTest {
  final String name;
  final Future<bool> Function() executor;

  PlatformTest(this.name, this.executor);
}

class Report {
  final String name;
  final bool success;

  Report(this.name, this.success);
}

Uint8List key128 = hex.decode("dce60234d641f71f377ecafb5a566ce9");
Uint8List key256 = hex
    .decode("163928fb9615edf6005afc98d9fdbb3d830b3a286ebef64dd70be848f17bf9cc");
Uint8List iv = hex.decode("c1f6fd873e14050697c168b3e9da5db2");
Uint8List plain = hex.decode("01040000000300000002400000008b2e");
Uint8List plain1 = hex.decode("01040000000300000002400000008b2e01");

final List<PlatformTest> tests = [
  PlatformTest("AES/128/CBC/NoPadding", () async {
    AES aes = AES.ofCBC(key128, iv, PaddingScheme.NoPadding);
    Uint8List encrypted = await aes.encrypt(plain);
    Uint8List decrypted = await aes.decrypt(encrypted);
    return (hex.encode(encrypted) == "64fb88a3f1a4d75d05c5508b2f2d4893") &&
        (hex.encode(decrypted) == hex.encode(plain));
  }),
  PlatformTest("AES/128/CBC/PKCS5Padding", () async {
    AES aes = AES.ofCBC(key128, iv, PaddingScheme.PKCS5Padding);
    Uint8List encrypted = await aes.encrypt(plain);
    Uint8List decrypted = await aes.decrypt(encrypted);
    return (hex.encode(encrypted) ==
            "64fb88a3f1a4d75d05c5508b2f2d48936167b6d75caf4867cca5db8dcf97af04") &&
        (hex.encode(decrypted) == hex.encode(plain));
  }),
  PlatformTest("AES/128/CBC/PKCS5Padding", () async {
    AES aes = AES.ofCBC(key128, iv, PaddingScheme.PKCS5Padding);
    Uint8List encrypted = await aes.encrypt(plain1);
    Uint8List decrypted = await aes.decrypt(encrypted);
    return hex.encode(encrypted) ==
            "64fb88a3f1a4d75d05c5508b2f2d48933740cf89850b682d8082ca17223a8f0f" &&
        hex.encode(decrypted) == hex.encode(plain1);
  }),

  PlatformTest("AES/256/CBC/NoPadding", () async {
    AES aes = AES.ofCBC(key256, iv, PaddingScheme.NoPadding);
    Uint8List encrypted = await aes.encrypt(plain);
    Uint8List decrypted = await aes.decrypt(encrypted);
    return (hex.encode(encrypted) == "514628247c36f3a964ed4f2e44b3cc81") &&
        (hex.encode(decrypted) == hex.encode(plain));
  }),
  PlatformTest("AES/256/CBC/PKCS5Padding", () async {
    AES aes = AES.ofCBC(key256, iv, PaddingScheme.PKCS5Padding);
    Uint8List encrypted = await aes.encrypt(plain);
    Uint8List decrypted = await aes.decrypt(encrypted);
    return (hex.encode(encrypted) ==
            "514628247c36f3a964ed4f2e44b3cc81c30092415f2c38b0e2bfb0c9d7fb46d7") &&
        (hex.encode(decrypted) == hex.encode(plain));
  }),
  PlatformTest("AES/256/CBC/PKCS5Padding", () async {
    AES aes = AES.ofCBC(key256, iv, PaddingScheme.PKCS5Padding);
    Uint8List encrypted = await aes.encrypt(plain1);
    Uint8List decrypted = await aes.decrypt(encrypted);
    return (hex.encode(encrypted) ==
            "514628247c36f3a964ed4f2e44b3cc815de5343cfac5450b11e5de1522cefe7e") &&
        (hex.encode(decrypted) == hex.encode(plain1));
  }),

  // ECB

  PlatformTest("AES/128/ECB/NoPadding", () async {
    AES aes = AES.ofECB(key128, PaddingScheme.NoPadding);
    Uint8List encrypted = await aes.encrypt(plain);
    Uint8List decrypted = await aes.decrypt(encrypted);
    return (hex.encode(encrypted) == "0e86eca7a8f24e2e65732eb01fe04fb2") &&
        (hex.encode(decrypted) == hex.encode(plain));
  }),
  PlatformTest("AES/128/ECB/PKCS5Padding", () async {
    AES aes = AES.ofECB(key128, PaddingScheme.PKCS5Padding);
    Uint8List encrypted = await aes.encrypt(plain);
    Uint8List decrypted = await aes.decrypt(encrypted);
    return (hex.encode(encrypted) ==
            "0e86eca7a8f24e2e65732eb01fe04fb27acdfbde18273836de549e9d028f6a24") &&
        (hex.encode(decrypted) == hex.encode(plain));
  }),
  PlatformTest("AES/128/ECB/PKCS5Padding", () async {
    AES aes = AES.ofECB(key128, PaddingScheme.PKCS5Padding);
    Uint8List encrypted = await aes.encrypt(plain1);
    Uint8List decrypted = await aes.decrypt(encrypted);
    return (hex.encode(encrypted) ==
            "0e86eca7a8f24e2e65732eb01fe04fb2c41c508ff2ac46c6c9224e1f9e6a0b8f") &&
        (hex.encode(decrypted) == hex.encode(plain1));
  }),

  PlatformTest("AES/256/ECB/NoPadding", () async {
    AES aes = AES.ofECB(key256, PaddingScheme.NoPadding);
    Uint8List encrypted = await aes.encrypt(plain);
    Uint8List decrypted = await aes.decrypt(encrypted);
    return (hex.encode(encrypted) == "b6665cd69f001766eb2e852b4b6d1ae0") &&
        (hex.encode(decrypted) == hex.encode(plain));
  }),
  PlatformTest("AES/256/ECB/PKCS5Padding", () async {
    AES aes = AES.ofECB(key256, PaddingScheme.PKCS5Padding);
    Uint8List encrypted = await aes.encrypt(plain);
    Uint8List decrypted = await aes.decrypt(encrypted);
    return (hex.encode(encrypted) ==
            "b6665cd69f001766eb2e852b4b6d1ae0adb4c9f63ac1c3cce511cb1edc9304e8") &&
        (hex.encode(decrypted) == hex.encode(plain));
  }),
  PlatformTest("AES/256/ECB/PKCS5Padding", () async {
    AES aes = AES.ofECB(key256, PaddingScheme.PKCS5Padding);
    Uint8List encrypted = await aes.encrypt(plain1);
    Uint8List decrypted = await aes.decrypt(encrypted);
    return (hex.encode(encrypted) ==
            "b6665cd69f001766eb2e852b4b6d1ae088fc68b1d65cfb0d70171925d1a818e2") &&
        (hex.encode(decrypted) == hex.encode(plain1));
  }),
];
