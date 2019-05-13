import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:encryptions/hex.dart';
import 'package:matcher/matcher.dart';

void main() {
  test('convert string to hex', () async {
    expect(await Hex.decode("dce6"),
        Uint8List.fromList(<int>[0xdc, 0xe6]));
  });
  test('convert invalid string to hex then throw error', () async {
    expect(
        () => Hex.decode(
            "dce60234d641f71f377ecafb5a566ce954d26c03fd3b5b23e9ed092ef42b529"),
        throwsA(TypeMatcher<ArgumentError>()));
  });
}
