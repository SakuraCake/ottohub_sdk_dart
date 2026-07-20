import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/ottohub_sdk_dart.dart';

void main() {
  group('ApiException', () {
    test('basic errorCode', () {
      const e = ApiException('error_token');
      expect(e.errorCode, 'error_token');
      expect(e.httpStatus, isNull);
      expect(e.responseData, isNull);
      expect(e.innerException, isNull);
    });

    test('with httpStatus', () {
      const e = ApiException('error_token', httpStatus: 401);
      expect(e.errorCode, 'error_token');
      expect(e.httpStatus, 401);
    });

    test('with responseData', () {
      final e = ApiException('error_vid', responseData: {'vid': '999'});
      expect(e.responseData, {'vid': '999'});
    });

    test('with innerException', () {
      final inner = Exception('inner');
      final e = ApiException('system_error', innerException: inner);
      expect(e.innerException, inner);
    });

    test('toString includes errorCode', () {
      const e = ApiException('error_token');
      expect(e.toString(), 'error_token');
    });

    test('toString includes httpStatus', () {
      const e = ApiException('error_token', httpStatus: 401);
      expect(e.toString(), 'error_token (HTTP 401)');
    });

    test('toString includes innerException', () {
      final e = ApiException('system_error', innerException: Exception('fail'));
      expect(e.toString(), contains('fail'));
    });

    test('const constructor works', () {
      const e = ApiException('missing_argument');
      expect(e, isA<ApiException>());
    });
  });
}
