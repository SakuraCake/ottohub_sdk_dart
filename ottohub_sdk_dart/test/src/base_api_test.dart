import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ottohub_sdk_dart/ottohub_sdk_dart.dart';
import 'package:ottohub_sdk_dart/src/base_api.dart';

class MockDio extends Mock implements Dio {}

class _TestApi extends BaseApi {
  _TestApi(
    super.dio,
    super.getToken, {
    super.config,
  });
}

void main() {
  late MockDio mockDio;
  String? token;

  _TestApi createApi({
    bool wrapHttpErrors = false,
    bool relaxedResponse = false,
    bool relaxedTypes = false,
  }) {
    return _TestApi(
      mockDio,
      () => token,
      config: BaseApiConfig(
        wrapHttpErrors: wrapHttpErrors,
        relaxedResponse: relaxedResponse,
        relaxedTypes: relaxedTypes,
      ),
    );
  }

  Response<T> responseOf<T>(T data, {int statusCode = 200}) {
    return Response(
      requestOptions: RequestOptions(path: '/test'),
      data: data,
      statusCode: statusCode,
    );
  }

  setUp(() {
    mockDio = MockDio();
    token = null;
  });

  group('BaseApiConfig', () {
    test('defaults are false', () {
      final api = createApi();
      expect(api.config.wrapHttpErrors, false);
      expect(api.config.relaxedResponse, false);
      expect(api.config.relaxedTypes, false);
    });

    test('can be overridden', () {
      final api = createApi(
        wrapHttpErrors: true,
        relaxedResponse: true,
        relaxedTypes: true,
      );
      expect(api.config.wrapHttpErrors, true);
      expect(api.config.relaxedResponse, true);
      expect(api.config.relaxedTypes, true);
    });

    test('strict mode is all false', () {
      expect(BaseApiConfig.strict.wrapHttpErrors, false);
      expect(BaseApiConfig.strict.relaxedResponse, false);
      expect(BaseApiConfig.strict.relaxedTypes, false);
    });
  });

  group('_validate', () {
    test('valid response returns data map', () async {
      final api = createApi();
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => responseOf({'status': 'success', 'data': {'key': 'val'}}));
      final result = await api.get('/test');
      expect(result, {'status': 'success', 'data': {'key': 'val'}});
    });

    test('error response throws ApiException', () async {
      final api = createApi();
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => responseOf({'status': 'error', 'message': 'error_token'}));
      expect(
        () async => api.get('/test'),
        throwsA(isA<ApiException>().having((e) => e.errorCode, 'errorCode', 'error_token')),
      );
    });

    test('non-Map response throws ApiException in strict mode', () async {
      final api = createApi();
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => responseOf('not a map'));
      expect(
        () async => api.get('/test'),
        throwsA(isA<ApiException>()),
      );
    });

    test('non-Map response returns empty map in relaxedResponse mode', () async {
      final api = createApi(relaxedResponse: true);
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => responseOf(['item1', 'item2']));
      final result = await api.get('/test');
      expect(result, <String, dynamic>{});
    });
  });

  group('wrapHttpErrors', () {
    test('false mode does not wrap DioException', () async {
      final api = createApi(wrapHttpErrors: false);
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: responseOf({'error': 'bad'}, statusCode: 500),
          ));
      expect(
        () async => api.get('/test'),
        throwsA(isA<DioException>()),
      );
    });

    test('true mode wraps DioException into ApiException', () async {
      final api = createApi(wrapHttpErrors: true);
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: responseOf({'error': 'bad'}, statusCode: 500),
          ));
      expect(
        () async => api.get('/test'),
        throwsA(isA<ApiException>().having((e) => e.httpStatus, 'httpStatus', 500)),
      );
    });

    test('401 maps to errorToken', () async {
      final api = createApi(wrapHttpErrors: true);
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.badResponse,
            response: responseOf({}, statusCode: 401),
          ));
      expect(
        () async => api.get('/test'),
        throwsA(isA<ApiException>().having((e) => e.errorCode, 'errorCode', 'error_token')),
      );
    });

    test('connection timeout maps to timeout', () async {
      final api = createApi(wrapHttpErrors: true);
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionTimeout,
          ));
      expect(
        () async => api.get('/test'),
        throwsA(isA<ApiException>().having((e) => e.errorCode, 'errorCode', 'timeout')),
      );
    });

    test('connection error maps to network_error', () async {
      final api = createApi(wrapHttpErrors: true);
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionError,
          ));
      expect(
        () async => api.get('/test'),
        throwsA(isA<ApiException>().having((e) => e.errorCode, 'errorCode', 'network_error')),
      );
    });
  });
}
