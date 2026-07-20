import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ottohub_sdk_dart/src/apis/block_api.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  setUp(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('BlockApi', () {
    test('blockUser sends POST to /api/block with body', () async {
      final mockDio = _MockDio();
      final api = BlockApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/block');
        expect(data['blocked_id'], 42);
        expect(data['reason'], 'spam');
        expect(data['reason_visible'], 1);
        return Response(
          data: {
            'status': 'success',
            'message': 'User blocked successfully',
            'data': {
              'block_id': 1234567890,
              'blocked_id': 42,
              'reason': 'spam',
              'reason_visible': 1,
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.blockUser(42, reason: 'spam', reasonVisible: 1);
      expect(result.blockedId, 42);
      expect(result.reason, 'spam');
    });

    test('unblockUser sends DELETE to /api/block/{blocked_id}', () async {
      final mockDio = _MockDio();
      final api = BlockApi(mockDio, () => 'tok');

      when(() => mockDio.delete(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/block/7');
        return Response(
          data: {
            'status': 'success',
            'message': 'User unblocked successfully',
            'data': {'blocked_id': 7},
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.unblockUser(7);
      expect(result.blockedId, 7);
    });

    test('getBlockList sends GET to /api/block/list with page params', () async {
      final mockDio = _MockDio();
      final api = BlockApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final params = invocation.namedArguments[#queryParameters] as Map;
        expect(path, '/block/list');
        expect(params['page'], 2);
        expect(params['page_size'], 10);
        return Response(
          data: {
            'status': 'success',
            'message': 'success',
            'data': {
              'list': [],
              'total': 0,
              'page': 2,
              'page_size': 10,
              'total_pages': 0,
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getBlockList(page: 2, pageSize: 10);
      expect(result.total, 0);
      expect(result.page, 2);
    });

    test('getBlockedByList sends GET to /api/block/blocked/list', () async {
      final mockDio = _MockDio();
      final api = BlockApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/block/blocked/list');
        return Response(
          data: {
            'status': 'success',
            'message': 'success',
            'data': {
              'list': [],
              'total': 0,
              'page': 1,
              'page_size': 20,
              'total_pages': 0,
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getBlockedByList();
      expect(result.list, isEmpty);
    });

    test('getBlockStatus sends GET to /api/block/status/{user_id}', () async {
      final mockDio = _MockDio();
      final api = BlockApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/block/status/5');
        return Response(
          data: {
            'status': 'success',
            'message': 'success',
            'data': {
              'target_user_id': 5,
              'i_blocked': true,
              'he_blocked': false,
              'mutual_block': false,
              'any_block': true,
              'my_reason': 'spam',
              'his_reason': '',
              'his_reason_visible': false,
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getBlockStatus(5);
      expect(result.targetUserId, 5);
      expect(result.iBlocked, isTrue);
      expect(result.anyBlock, isTrue);
    });
  });
}

