import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ottohub_sdk_dart/src/apis/moderation_api.dart';
import 'package:ottohub_sdk_dart/ottohub_sdk_dart.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  setUp(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('ModerationApi', () {
    // ── Lists ──

    test('getVideoList sends GET /moderation/videos', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/moderation/videos');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'video_list': [
                {
                  'vid': 1,
                  'uid': 100,
                  'title': '视频标题',
                }
              ],
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final list = await api.getVideoList();
      expect(list.length, 1);
      expect(list[0].vid, 1);
    });

    test('getBlogList sends GET /moderation/blogs', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'status': 'success',
                  'data': {'blog_list': []},
                },
                requestOptions: RequestOptions(path: '/moderation/blogs'),
              ));

      final list = await api.getBlogList();
      expect(list, isEmpty);
    });

    test('getAvatarList sends GET /moderation/avatars', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'avatar_list': [
                      {'uid': 1, 'username': 'u', 'avatar_url': 'a.jpg'}
                    ],
                  },
                },
                requestOptions: RequestOptions(path: '/moderation/avatars'),
              ));

      final list = await api.getAvatarList();
      expect(list.length, 1);
    });

    test('getCoverList sends GET /moderation/covers', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'cover_list': [
                      {'uid': 1, 'username': 'u', 'cover_url': 'c.jpg'}
                    ],
                  },
                },
                requestOptions: RequestOptions(path: '/moderation/covers'),
              ));

      final list = await api.getCoverList();
      expect(list.length, 1);
    });

    test('getDanmakuList sends GET /moderation/danmakus', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'danmaku_list': [
                      {
                        'danmaku_id': 1,
                        'text': 't',
                        'time': 1.0,
                        'mode': 1,
                        'color': '#fff',
                        'font_size': 25,
                        'render': '',
                      }
                    ],
                  },
                },
                requestOptions: RequestOptions(path: '/moderation/danmakus'),
              ));

      final list = await api.getDanmakuList();
      expect(list.length, 1);
    });

    test('getVideoCommentList sends GET /moderation/video-comments',
        () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'comment_list': [
                      {
                        'vcid': 1,
                        'parent_vcid': 0,
                        'vid': 789,
                        'uid': 456,
                        'content': '评论',
                        'time': '2024-01-01 12:00:00',
                        'username': 'u',
                      }
                    ],
                  },
                },
                requestOptions:
                    RequestOptions(path: '/moderation/video-comments'),
              ));

      final list = await api.getVideoCommentList();
      expect(list.length, 1);
    });

    test('getBlogCommentList sends GET /moderation/blog-comments', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'comment_list': [
                      {
                        'bcid': 1,
                        'parent_bcid': 0,
                        'bid': 456,
                        'uid': 456,
                        'content': '评论',
                        'time': '2024-01-01 12:00:00',
                        'username': 'u',
                      }
                    ],
                  },
                },
                requestOptions:
                    RequestOptions(path: '/moderation/blog-comments'),
              ));

      final list = await api.getBlogCommentList();
      expect(list.length, 1);
    });

    // ── Approve ──

    test('approveVideo sends PUT /moderation/videos/{vid}/approve', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.put(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/moderation/videos/123/approve');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.approveVideo(123);
    });

    test('approveBlog sends PUT /moderation/blogs/{bid}/approve', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.put(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        expect(invocation.positionalArguments[0], '/moderation/blogs/1/approve');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: '/moderation/blogs/1/approve'),
        );
      });

      await api.approveBlog(1);
    });

    // ── Reject ──

    test('rejectVideo sends PUT with reason', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.put(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/moderation/videos/1/reject');
        expect(data['reason'], '不合规');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.rejectVideo(1, reason: '不合规');
    });

    // ── Report ──

    test('reportBlog sends POST with reason', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/moderation/blogs/1/report');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.reportBlog(1, reason: '违规');
    });

    // ── Appeal ──

    test('appealAvatar sends POST with reason', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/moderation/avatars/1/appeal');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.appealAvatar(1, reason: '误判');
    });

    // ── Logs ──

    test('getUnreadCount sends GET /moderation/logs/unread-count', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/moderation/logs/unread-count');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'unread_count': 5,
              'unread_approved': 3,
              'unread_rejected': 2,
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getUnreadCount();
      expect(result.unreadCount, 5);
    });

    test('getLogs sends GET /moderation/logs', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/moderation/logs');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'role': 'user',
              'is_admin': 0,
              'is_audit': 0,
              'offset': 0,
              'num': 20,
              'logs': [
                {
                  'log_id': 1,
                  'operator_uid': 9001,
                  'owner_uid': 123,
                  'audit_type': 'video',
                  'action': 1,
                  'target_id': 456,
                  'is_read': 0,
                  'is_unread': 1,
                  'created_at': '2026-02-12 13:00:00',
                }
              ],
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getLogs();
      expect(result.logs.length, 1);
      expect(result.role, 'user');
    });

    // ── Error handling ──

    test('error response throws ApiException', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {'status': 'error', 'message': 'not_reviewer'},
                requestOptions: RequestOptions(path: '/moderation/videos'),
              ));

      expect(() => api.getVideoList(), throwsA(isA<ApiException>()));
    });
  });
}

