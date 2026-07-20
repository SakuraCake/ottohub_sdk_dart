import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ottohub_sdk_dart/ottohub_sdk_dart.dart';
import 'package:ottohub_sdk_dart/src/apis/following_api.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  setUp(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('FollowingApi POST methods', () {
    test('toggleFollow sends POST to /following/follow/{uid}', () async {
      final mockDio = _MockDio();
      final api = FollowingApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/following/follow/42');
        return Response(
          data: {
            'status': 'success',
            'data': {'new_fans_count': 15, 'follow_status': 2},
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.toggleFollow(42);
      expect(result.newFansCount, 15);
      expect(result.followStatus, 2);
    });
  });

  group('FollowingApi GET methods', () {
    test('getStatus sends GET to /following/status/{uid} with token', () async {
      final mockDio = _MockDio();
      final api = FollowingApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final params = invocation.namedArguments[#queryParameters] as Map;
        expect(path, '/following/status/7');
        expect(params['token'], 'tok');
        return Response(
          data: {'status': 'success', 'data': {'follow_status': 3}},
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getStatus(7);
      expect(result.followStatus, 3);
    });

    test('getFollowingList sends GET to /following/list/{uid}', () async {
      final mockDio = _MockDio();
      final api = FollowingApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final params = invocation.namedArguments[#queryParameters] as Map;
        expect(path, '/following/list/123');
        expect(params['offset'], 0);
        expect(params['num'], 18);
        return Response(
          data: {
            'status': 'success',
            'data': {
              'user_list': [
                {
                  'uid': 1,
                  'username': 'u1',
                  'intro': 'intro1',
                  'avatar_url': 'https://a.jpg',
                  'follow_status': 2,
                },
              ],
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getFollowingList(123, offset: 0, num: 18);
      expect(result.userList.length, 1);
      expect(result.userList[0].uid, 1);
      expect(result.userList[0].username, 'u1');
    });

    test('getFansList sends GET to /following/fans/{uid}', () async {
      final mockDio = _MockDio();
      final api = FollowingApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/following/fans/456');
        return Response(
          data: {
            'status': 'success',
            'data': {'user_list': []},
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getFansList(456);
      expect(result.userList, isEmpty);
    });

    test('getTimeline sends GET to /following/timeline', () async {
      final mockDio = _MockDio();
      final api = FollowingApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final params = invocation.namedArguments[#queryParameters] as Map;
        expect(path, '/following/timeline');
        expect(params['num'], 20);
        expect(params['offset'], 0);
        return Response(
          data: {
            'status': 'success',
            'data': {
              'timeline_list': [
                {
                  'content_type': 'video',
                  'vid': 789,
                  'uid': 123,
                  'title': 'Video',
                  'time': '2023-01-01',
                  'like_count': 100,
                  'favorite_count': 50,
                  'view_count': 1000,
                  'cover_url': 'https://c.jpg',
                  'username': 'u',
                  'avatar_url': 'https://a.jpg',
                },
              ],
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getTimeline(offset: 0, num: 20);
      expect(result.timelineList.length, 1);
      expect(result.timelineList[0].contentType, 'video');
    });

    test('getUserTimeline sends GET to /following/timeline/{uid}', () async {
      final mockDio = _MockDio();
      final api = FollowingApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/following/timeline/789');
        return Response(
          data: {
            'status': 'success',
            'data': {'timeline_list': []},
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getUserTimeline(789);
      expect(result.timelineList, isEmpty);
    });

    test('getActiveFollowers sends GET to /following/active/{uid}', () async {
      final mockDio = _MockDio();
      final api = FollowingApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/following/active/321');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'user_list': [
                {
                  'uid': 1,
                  'username': 'u',
                  'avatar_url': 'https://a.jpg',
                  'latest_activity_time': '2023-01-01',
                },
              ],
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getActiveFollowers(321);
      expect(result.length, 1);
      expect(result[0].uid, 1);
      expect(result[0].latestActivityTime, '2023-01-01');
    });
  });

  group('FollowingApi error handling', () {
    test('error response throws ApiException', () async {
      final mockDio = _MockDio();
      final api = FollowingApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {'status': 'error', 'message': 'error_token'},
                requestOptions: RequestOptions(path: '/following/status/1'),
              ));

      expect(
        () => api.getStatus(1),
        throwsA(isA<ApiException>()),
      );
    });
  });
}

