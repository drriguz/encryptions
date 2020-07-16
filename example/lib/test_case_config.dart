import 'dart:convert';
import 'dart:typed_data';

import 'package:encryptions/encryptions.dart';
import 'package:convert/convert.dart';

import 'test_case.dart';

Uint8List key128 = hex.decode("dce60234d641f71f377ecafb5a566ce9");
Uint8List key256 = hex.decode("163928fb9615edf6005afc98d9fdbb3d830b3a286ebef64dd70be848f17bf9cc");
Uint8List iv = hex.decode("c1f6fd873e14050697c168b3e9da5db2");

String plain = "01040000000300000002400000008b2e";
String plainNotAligned = "01040000000300000002400000008b2e01";

String password = hex.encode(utf8.encode("password"));
String salt = hex.encode(utf8.encode("helloworld"));

AES aesCbcNoPadding = AES.ofCBC(key128, iv, PaddingScheme.NoPadding);

List<TestCase> testCases = [
  /* ------------------ AES-CBC-128 ------------------ */
  AesTestCase(
    "AES/128/CBC/NoPadding",
    AES.ofCBC(key128, iv, PaddingScheme.NoPadding),
    plain,
    "64fb88a3f1a4d75d05c5508b2f2d4893",
  ),
  AesTestCase(
    "AES/128/CBC/PKCS5Padding",
    AES.ofCBC(key128, iv, PaddingScheme.PKCS5Padding),
    plain,
    "64fb88a3f1a4d75d05c5508b2f2d48936167b6d75caf4867cca5db8dcf97af04",
  ),
  AesTestCase(
    "AES/128/CBC/PKCS5Padding/ApplyPadding",
    AES.ofCBC(key128, iv, PaddingScheme.PKCS5Padding),
    plainNotAligned,
    "64fb88a3f1a4d75d05c5508b2f2d48933740cf89850b682d8082ca17223a8f0f",
  ),
  /* ------------------ AES-CBC-256 ------------------ */
  AesTestCase(
    "AES/256/CBC/NoPadding",
    AES.ofCBC(key256, iv, PaddingScheme.NoPadding),
    plain,
    "514628247c36f3a964ed4f2e44b3cc81",
  ),
  AesTestCase(
    "AES/256/CBC/PKCS5Padding",
    AES.ofCBC(key256, iv, PaddingScheme.PKCS5Padding),
    plain,
    "514628247c36f3a964ed4f2e44b3cc81c30092415f2c38b0e2bfb0c9d7fb46d7",
  ),
  AesTestCase(
    "AES/256/CBC/PKCS5Padding/ApplyPadding",
    AES.ofCBC(key256, iv, PaddingScheme.PKCS5Padding),
    plainNotAligned,
    "514628247c36f3a964ed4f2e44b3cc815de5343cfac5450b11e5de1522cefe7e",
  ),
  /* ------------------ AES-ECB-128 ------------------ */
  AesTestCase(
    "AES/128/ECB/NoPadding",
    AES.ofECB(key128, PaddingScheme.NoPadding),
    plain,
    "0e86eca7a8f24e2e65732eb01fe04fb2",
  ),
  AesTestCase(
    "AES/128/ECB/PKCS5Padding",
    AES.ofECB(key128, PaddingScheme.PKCS5Padding),
    plain,
    "0e86eca7a8f24e2e65732eb01fe04fb27acdfbde18273836de549e9d028f6a24",
  ),
  AesTestCase(
    "AES/128/ECB/PKCS5Padding/ApplyPadding",
    AES.ofECB(key128, PaddingScheme.PKCS5Padding),
    plainNotAligned,
    "0e86eca7a8f24e2e65732eb01fe04fb2c41c508ff2ac46c6c9224e1f9e6a0b8f",
  ),
  /* ------------------ AES-ECB-256 ------------------ */
  AesTestCase(
    "AES/256/ECB/NoPadding",
    AES.ofECB(key256, PaddingScheme.NoPadding),
    plain,
    "b6665cd69f001766eb2e852b4b6d1ae0",
  ),
  AesTestCase(
    "AES/256/ECB/PKCS5Padding",
    AES.ofECB(key256, PaddingScheme.PKCS5Padding),
    plain,
    "b6665cd69f001766eb2e852b4b6d1ae0adb4c9f63ac1c3cce511cb1edc9304e8",
  ),
  AesTestCase(
    "AES/256/ECB/PKCS5Padding/ApplyPadding",
    AES.ofECB(key256, PaddingScheme.PKCS5Padding),
    plainNotAligned,
    "b6665cd69f001766eb2e852b4b6d1ae088fc68b1d65cfb0d70171925d1a818e2",
  ),

  /* ------------------ Argon2 ------------------ */
  Argon2iTestCase(
    "argon2i/default",
    Argon2(),
    password,
    salt,
    "1fe7d8ae9f8946a5170aa6b96e8eea69b5f9351cbe457c4776e01f0b72a1e40e",
  ),
  Argon2dTestCase(
    "argon2d/default",
    Argon2(),
    password,
    salt,
    "251c68a5591a838647b5afa7d1379cc63690daffcedb1e725528789014064fab",
  ),
  Argon2idTestCase(
    "argon2id/default",
    Argon2(),
    password,
    salt,
    "f4d4a3ae373989af91e2e396e28762fe05417bd1d5d9e44d3afdc0e71497c902",
  ),
  Argon2iTestCase(
    "argon2idcustom",
    Argon2(iterations: 16, hashLength: 64, memory: 256, parallelism: 2),
    password,
    salt,
    "dc530394aaa947ba00a24c2edd46e72b78af2561f9b823e6648f6949229593929862a23e2cbbaa1e48918e9dd425c2306d09898f03f5f29a3429a86e07b4e9d6",
  ),
];
