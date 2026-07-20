import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ottohub_sdk_dart/ottohub_sdk_dart.dart';
import 'package:ottohub_sdk_dart/src/apis/video_api.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  setUp(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('VideoApi GET methods', () {
    test('getRandom sends correct path and optional num', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final params = invocation.namedArguments[#queryParameters] as Map?;
        expect(path, '/video/random');
        expect(params?['num'], 10);
        return Response(
          data: {
            'status': 'success',
            'data': {'video_list': _sampleList()},
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getRandom(num: 10);
      expect(result.videoList.length, 1);
      expect(result.videoList[0].vid, 1);
    });

    test('getNew sends offset/num/type query params', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final params = invocation.namedArguments[#queryParameters] as Map;
        expect(params['offset'], 0);
        expect(params['num'], 20);
        expect(params['type'], 'video');
        return Response(
          data: {
            'status': 'success',
            'data': {'video_list': _sampleList()},
          },
          requestOptions: RequestOptions(path: '/video/new'),
        );
      });

      await api.getNew(offset: 0, num: 20, type: 'video');
    });

    test('getCategory appends category to path', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/video/category/animation');
        return Response(
          data: {
            'status': 'success',
            'data': {'video_list': _sampleList()},
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.getCategory('animation', num: 10);
    });

    test('search omits 0-valued sort params', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final params = invocation.namedArguments[#queryParameters] as Map;
        expect(params['search_term'], 'cat');
        expect(params['like_count_desc'], 1);
        expect(params.containsKey('vid_desc'), isFalse);
        expect(params.containsKey('view_count_desc'), isFalse);
        expect(params.containsKey('favorite_count_desc'), isFalse);
        return Response(
          data: {
            'status': 'success',
            'data': {
              'video_list': _sampleList(),
              'total_count': 100,
            },
          },
          requestOptions: RequestOptions(path: '/video/search'),
        );
      });

      final result = await api.search(searchTerm: 'cat', likeCountDesc: 1);
      expect(result.totalCount, 100);
    });

    test('getDetail returns VideoDetail from data wrapper', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/video/42');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'vid': '42',
              'uid': '1',
              'title': 'Detail Video',
              'time': '2023-01-01',
              'like_count': '100',
              'favorite_count': '50',
              'view_count': '1000',
              'cover_url': '',
              'username': 'user',
              'if_like': 0,
              'if_favorite': 0,
              'last_watch_second': -1,
              'duration': '200',
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final detail = await api.getDetail(42);
      expect(detail.vid, '42');
      expect(detail.title, 'Detail Video');
      expect(detail.lastWatchSecond, -1);
    });

    test('getFavoriteList injects token in query', () async {
      final mockDio = _MockDio();
      String? currentToken = 'user_token';
      final api = VideoApi(mockDio, () => currentToken);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final params = invocation.namedArguments[#queryParameters] as Map;
        expect(params['token'], 'user_token');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'video_list': _sampleList(),
              'favorite_video_count': 10,
            },
          },
          requestOptions: RequestOptions(path: '/video/favorite-list'),
        );
      });

      final result = await api.getFavoriteList();
      expect(result.favoriteVideoCount, 10);
    });
  });

  group('VideoApi POST methods', () {
    test('toggleFavorite sends POST to /video/favorite/{vid}', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/video/favorite/7');
        return Response(
          data: {
            'status': 'success',
            'data': {'if_favorite': 1, 'favorite_count': 51},
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.toggleFavorite(7);
      expect(result.ifFavorite, 1);
      expect(result.favoriteCount, 51);
    });

    test('toggleLike sends POST to /video/like/{vid}', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/video/like/3');
        return Response(
          data: {
            'status': 'success',
            'data': {'if_like': 0, 'like_count': 99},
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.toggleLike(3);
      expect(result.ifLike, 0);
      expect(result.likeCount, 99);
    });

    test('saveWatchHistory sends POST with vid and last_watch_second', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/video/watch-history');
        expect(data['vid'], 42);
        expect(data['last_watch_second'], 65);
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.saveWatchHistory(42, 65);
    });

    test('submitVideo sends FormData with all required fields', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final data = invocation.namedArguments[#data];
        expect(data, isA<FormData>());
        final fd = data as FormData;
        final fieldKeys = {
          ...fd.fields.map((e) => e.key),
          ...fd.files.map((e) => e.key),
        };
        expect(fieldKeys.contains('title'), isTrue);
        expect(fieldKeys.contains('intro'), isTrue);
        expect(fieldKeys.contains('type'), isTrue);
        expect(fieldKeys.contains('category'), isTrue);
        expect(fieldKeys.contains('tag'), isTrue);
        expect(fieldKeys.contains('file_mp4'), isTrue);
        expect(fieldKeys.contains('file_jpg'), isTrue);
        return Response(
          data: {
            'status': 'success',
            'data': {'vid': 999, 'if_add_experience': 1},
          },
          requestOptions: RequestOptions(path: '/video/submit'),
        );
      });

      final result = await api.submitVideo(
        title: 'My Video',
        intro: 'Description',
        type: 1,
        category: 3,
        tag: '#tag1#tag2',
        fileMp4: MultipartFile.fromBytes([0, 1, 2], filename: 'video.mp4'),
        fileJpg: MultipartFile.fromBytes([3, 4, 5], filename: 'cover.jpg'),
      );
      expect(result.vid, 999);
      expect(result.ifAddExperience, 1);
    });
  });

  group('VideoApi DELETE method', () {
    test('deleteVideo sends DELETE to /video/{vid}', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => 'tok');

      when(() => mockDio.delete(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/video/5');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.deleteVideo(5);
    });
  });

  group('VideoApi error handling', () {
    test('error response throws ApiException', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {'status': 'error', 'message': 'error_vid'},
                requestOptions: RequestOptions(path: '/video/999'),
              ));

      expect(
        () => api.getDetail(999),
        throwsA(isA<ApiException>()),
      );
    });
  });
}

List<Map<String, dynamic>> _sampleList() {
  return [
    {
      'vid': 1,
      'uid': 123,
      'title': 'Video 1',
      'time': '2023-01-01 00:00:00',
      'like_count': 100,
      'favorite_count': 50,
      'view_count': 1000,
      'cover_url': 'https://example.com/c.jpg',
      'username': 'user',
      'duration': 120,
    },
  ];
}

