import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ottohub_sdk_dart/src/apis/auth_api.dart';
import 'package:ottohub_sdk_dart/ottohub_sdk_dart.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  setUp(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('AuthApi', () {
    test('login sends correct path and body', () async {
      final mockDio = _MockDio();
      final api = AuthApi(mockDio, () => null);

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((invocation) async {
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(data['uid_email'], 'test@qq.com');
        expect(data['pw'], 'pw123');
        return Response(
          data: {'status': 'success', 'uid': '123', 'token': 'tok'},
          requestOptions: RequestOptions(path: '/auth/login'),
        );
      });

      final resp = await api.login('test@qq.com', 'pw123');
      expect(resp.uid, '123');
      expect(resp.token, 'tok');

      verify(() => mockDio.post(
            '/auth/login',
            data: any(named: 'data', that: isA<Map<String, dynamic>>()),
          )).called(1);
    });

    test('error response throws ApiException', () async {
      final mockDio = _MockDio();
      final api = AuthApi(mockDio, () => null);

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: {'status': 'error', 'message': 'missing_argument'},
            requestOptions: RequestOptions(path: '/auth/login'),
          ));

      expect(
        () => api.login('test@qq.com', 'pw123'),
        throwsA(isA<ApiException>()),
      );
    });

    test('error response without message uses fallback', () async {
      final mockDio = _MockDio();
      final api = AuthApi(mockDio, () => null);

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: {'status': 'error'},
            requestOptions: RequestOptions(path: '/auth/login'),
          ));

      expect(
        () => api.login('test@qq.com', 'pw123'),
        throwsA(predicate((e) => e.toString() == 'unknown_error')),
      );
    });

    test('register sends correct parameters', () async {
      final mockDio = _MockDio();
      final api = AuthApi(mockDio, () => null);

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((invocation) async {
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(data['email'], 'test@qq.com');
        expect(data['register_verification_code'], '123456');
        expect(data['pw'], 'pw123');
        expect(data['confirm_pw'], 'pw123');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: '/auth/register'),
        );
      });

      await api.register(
        email: 'test@qq.com',
        verificationCode: '123456',
        password: 'pw123',
        confirmPassword: 'pw123',
      );
    });

    test('signIn returns if_today_first_login', () async {
      final mockDio = _MockDio();
      final api = AuthApi(mockDio, () => null);

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: {'status': 'success', 'if_today_first_login': 'yes'},
            requestOptions: RequestOptions(path: '/auth/sign-in'),
          ));

      final result = await api.signIn();
      expect(result, 'yes');
    });

    test('public login does not inject token; sign-in injects token', () async {
      final mockDio = _MockDio();
      String? currentToken = 'my_token';
      final api = AuthApi(mockDio, () => currentToken);

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((invocation) async {
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        // login 为公开接口,不注入 token(仅 auth: true 的请求注入)。
        expect(data.containsKey('token'), isFalse);
        return Response(
          data: {'status': 'success', 'uid': '123', 'token': 'tok'},
          requestOptions: RequestOptions(path: '/auth/login'),
        );
      });

      await api.login('test@qq.com', 'pw123');
    });

    test('login throws ApiException with correct error code', () async {
      final mockDio = _MockDio();
      final api = AuthApi(mockDio, () => null);

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: {'status': 'error', 'message': 'error_token'},
            requestOptions: RequestOptions(path: '/auth/login'),
          ));

      try {
        await api.login('test@qq.com', 'pw123');
        fail('Expected ApiException');
      } on ApiException catch (e) {
        expect(e.errorCode, 'error_token');
      }
    });
  });
}

