import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ottohub_sdk_dart/src/apis/danmaku_api.dart';
import 'package:ottohub_sdk_dart/ottohub_sdk_dart.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  setUp(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('DanmakuApi', () {
    test('getDanmaku sends GET and parses list from data', () async {
      final mockDio = _MockDio();
      final api = DanmakuApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/danmaku/42');
        return Response(
          data: {
            'status': 'success',
            'code': 0,
            'data': [
              {
                'danmaku_id': 1,
                'text': '弹幕1',
                'time': 10.5,
                'mode': 'scroll',
                'color': '#ffffff',
                'font_size': '25px',
                'render': '',
              },
              {
                'danmaku_id': 2,
                'text': '弹幕2',
                'time': 15.0,
                'mode': 'top',
                'color': '#ff0000',
                'font_size': '20px',
                'render': '',
              },
            ],
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final list = await api.getDanmaku(42);
      expect(list.length, 2);
      expect(list[0].danmakuId, 1);
      expect(list[1].text, '弹幕2');
    });

    test('getDanmaku handles empty list', () async {
      final mockDio = _MockDio();
      final api = DanmakuApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {'status': 'success', 'code': 0, 'data': []},
                requestOptions: RequestOptions(path: '/danmaku/1'),
              ));

      final list = await api.getDanmaku(1);
      expect(list, isEmpty);
    });

    test('sendDanmaku sends POST with all required fields', () async {
      final mockDio = _MockDio();
      final api = DanmakuApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/danmaku');
        expect(data['vid'], 42);
        expect(data['text'], 'hello');
        expect(data['time'], 15.5);
        expect(data['mode'], 'scroll');
        expect(data['color'], 'ffffff');
        expect(data['font_size'], '25px');
        expect(data['render'], '');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.sendDanmaku(
        vid: 42,
        text: 'hello',
        time: 15.5,
        mode: 'scroll',
        color: 'ffffff',
        fontSize: '25px',
        render: '',
      );
    });

    test('deleteDanmaku sends DELETE with token in query', () async {
      final mockDio = _MockDio();
      final api = DanmakuApi(mockDio, () => 'tok');

      when(() => mockDio.delete(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final params = invocation.namedArguments[#queryParameters] as Map;
        expect(path, '/danmaku/99');
        expect(params['token'], 'tok');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.deleteDanmaku(99);
    });

    test('error response throws ApiException', () async {
      final mockDio = _MockDio();
      final api = DanmakuApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {'status': 'error', 'message': 'no_permission'},
                requestOptions: RequestOptions(path: '/danmaku'),
              ));

      expect(
        () => api.sendDanmaku(
          vid: 1,
          text: 't',
          time: 1.0,
          mode: 'scroll',
          color: 'ffffff',
          fontSize: '25px',
          render: '',
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });
}

