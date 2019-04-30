import 'dart:typed_data';
import 'package:convert/convert.dart';

class Hex {
  static HexEncoder _hexEncoder;

  static Uint8List decode(String hex) {
    // dce60234d641f71f377ecafb5a566ce954d26c03fd3b5b23e9ed092ef42b5290

    if (hex == null || hex.length % 2 != 0)
      throw new ArgumentError("Hex string length should be even");
    final bytes = List<int>(hex.length ~/ 2);
    for (int i = 0; i < bytes.length; i++) {
      final index = i * 2;
      final byte = hex.substring(index, index + 2);
      bytes[i] = int.parse(byte, radix: 16);
    }
    return Uint8List.fromList(bytes);
  }

  static String encode(Uint8List bytes) {
    return hex.encode(bytes);
  }
}
