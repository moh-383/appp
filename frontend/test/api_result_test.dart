import 'package:flutter_test/flutter_test.dart';
import 'package:appp/core/api/rover_api.dart';

void main() {
  test('ApiResult.success marks ok', () {
    final result = ApiResult.success({'a': 1}, 200);
    expect(result.ok, isTrue);
    expect(result.data?['a'], 1);
    expect(result.statusCode, 200);
  });

  test('ApiResult.failure marks error', () {
    final result = ApiResult.failure('boom', 502);
    expect(result.ok, isFalse);
    expect(result.error, 'boom');
    expect(result.statusCode, 502);
  });
}
