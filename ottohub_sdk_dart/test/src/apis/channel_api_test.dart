import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ottohub_sdk_dart/src/apis/channel_api.dart';
import 'package:ottohub_sdk_dart/ottohub_sdk_dart.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  setUp(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('ChannelApi', () {
    // ── Channel Management ──

    test('createChannel sends POST /channel/create', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/channel/create');
        expect(data['channel_name'], 'techhub');
        expect(data['channel_title'], '技术交流');
        expect(data['token'], 'tok');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'channel_id': 123,
              'channel_name': 'techhub',
              'channel_title': '技术交流',
              'creator_uid': 456,
              'owner_uid': 456,
              'join_permission': 0,
              'member_count': 1,
              'follower_count': 0,
              'created_at': '2024-01-01 12:00:00',
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.createChannel(
          channelName: 'techhub', channelTitle: '技术交流');
      expect(result.channelId, 123);
    });

    test('getChannelDetail sends GET /channel/{id}', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'channel_id': 123,
              'channel_name': 'techhub',
              'channel_title': 'Tech Hub',
              'creator_uid': 456,
              'owner_uid': 456,
              'join_permission': 0,
              'member_count': 10,
              'follower_count': 20,
              'created_at': '2024-01-01 12:00:00',
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getChannelDetail(123);
      expect(result.channelName, 'techhub');
    });

    test('updateChannel sends PUT /channel/{id}', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.put(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/channel/123');
        expect(data['channel_title'], '新标题');
        return Response(
          data: {
            'status': 'success',
            'data': {'channel_id': 123, 'updated_at': '2024-01-15 15:00:00'},
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result =
          await api.updateChannel(123, channelTitle: '新标题');
      expect(result.channelId, 123);
    });

    test('deleteChannel sends DELETE /channel/{id} with verification_code',
        () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.delete(any(),
              queryParameters: any(named: 'queryParameters'),
              data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/channel/123');
        expect(data['verification_code'], '123456');
        return Response(
          data: {
            'status': 'success',
            'data': {'video_count': 25, 'blog_count': 10, 'total_content': 35},
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.deleteChannel(123, '123456');
      expect(result.videoCount, 25);
      expect(result.totalContent, 35);
    });

    test('getChannelList sends GET /channel', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final params =
            invocation.namedArguments[#queryParameters] as Map<String, dynamic>;
        expect(path, '/channel');
        expect(params['page'], 1);
        expect(params['limit'], 20);
        return Response(
          data: {
            'status': 'success',
            'data': {
              'channels': [
                {
                  'channel_id': 1,
                  'channel_name': 'c1',
                  'channel_title': 'C1',
                  'member_count': 5,
                  'follower_count': 10,
                }
              ],
              'pagination': {'page': 1, 'limit': 20, 'total': 1, 'total_pages': 1},
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result =
          await api.getChannelList(page: 1, limit: 20);
      expect((result['channels'] as List).length, 1);
    });

    // ── Members ──

    test('joinChannel sends POST /channel/{id}/members', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/members');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'channel_id': 123,
              'uid': 456,
              'status': 1,
              'message': '已成功加入频道',
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.joinChannel(123);
      expect(result.status, 1);
      expect(result.message, '已成功加入频道');
    });

    test('getMemberList sends GET /channel/{id}/members', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/members');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'members': [
                {
                  'uid': 1,
                  'username': '张三',
                  'role': 0,
                  'status': 1,
                  'joined_at': '2024-01-01 12:00:00',
                }
              ],
              'pagination': {'page': 1, 'limit': 20, 'total': 1, 'total_pages': 1},
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getMemberList(123);
      expect((result['members'] as List).length, 1);
    });

    test('approveMember sends PUT /channel/{id}/members/{uid}', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.put(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/channel/123/members/456');
        expect(data['action'], 'approve');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'channel_id': 123,
              'uid': 456,
              'status': 1,
              'message': '申请已通过',
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.approveMember(123, 456, 'approve');
    });

    test('kickMember sends DELETE /channel/{id}/members/{uid}', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.delete(any(),
              queryParameters: any(named: 'queryParameters'),
              data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/members/456');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.kickMember(123, 456);
    });

    test('leaveChannel sends DELETE /channel/{id}/members/me', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.delete(any(),
              queryParameters: any(named: 'queryParameters'),
              data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/members/me');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.leaveChannel(123);
    });

    test('setMemberRole sends PUT /channel/{id}/members/{uid}/role',
        () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.put(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/channel/123/members/456/role');
        expect(data['role'], 1);
        return Response(
          data: {
            'status': 'success',
            'data': {
              'uid': 456,
              'old_role': 0,
              'new_role': 1,
              'message': '角色已更新',
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.setMemberRole(123, 456, 1);
      expect(result.oldRole, 0);
      expect(result.newRole, 1);
    });

    test('getPendingApplications sends GET /channel/{id}/members/pending',
        () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/members/pending');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'applications': [
                {
                  'uid': 789,
                  'username': '李四',
                  'status': 0,
                  'applied_at': '2024-01-15 10:00:00',
                }
              ],
              'pagination':
                  {'page': 1, 'limit': 20, 'total': 1, 'total_pages': 1},
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getPendingApplications(123);
      expect((result['applications'] as List).length, 1);
    });

    // ── Content ──

    test('getChannelContent sends GET /channel/{id}/content', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/content');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'content': [
                {
                  'type': 'video',
                  'vid': 789,
                  'uid': 456,
                  'title': '视频',
                  'view_count': 100,
                  'created_at': '2024-01-15 12:00:00',
                }
              ],
              'pagination':
                  {'page': 1, 'limit': 20, 'total': 1, 'total_pages': 1},
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getChannelContent(123);
      expect((result['content'] as List).length, 1);
    });

    test('addContentToChannel sends POST /channel/{id}/content', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/channel/123/content');
        expect(data['type'], 'video');
        expect(data['content_id'], 789);
        return Response(
          data: {
            'status': 'success',
            'data': {
              'channel_id': 123,
              'channel_section_id': 0,
              'type': 'video',
              'content_id': 789,
              'message': '内容已添加到频道',
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result =
          await api.addContentToChannel(123, type: 'video', contentId: 789);
      expect(result.contentId, 789);
    });

    test('removeContentFromChannel sends DELETE /channel/{id}/content/{type}/{cid}',
        () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.delete(any(),
              queryParameters: any(named: 'queryParameters'),
              data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/content/video/789');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.removeContentFromChannel(123, 'video', 789);
    });

    // ── Follow ──

    test('followChannel sends POST /channel/{id}/follow', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/follow');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.followChannel(123);
    });

    test('unfollowChannel sends DELETE /channel/{id}/follow', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.delete(any(),
              queryParameters: any(named: 'queryParameters'),
              data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/follow');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.unfollowChannel(123);
    });

    test('getFollowedChannels sends GET /channel/following', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/following');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'channels': [
                {
                  'channel_id': 1,
                  'channel_name': 'c1',
                  'channel_title': 'C1',
                  'member_count': 5,
                  'follower_count': 10,
                  'followed_at': '2024-01-10 12:00:00',
                }
              ],
              'pagination':
                  {'page': 1, 'limit': 20, 'total': 1, 'total_pages': 1},
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getFollowedChannels();
      expect((result['channels'] as List).length, 1);
    });

    // ── Query ──

    test('getChannelStats sends GET /channel/{id}/stats', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/stats');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'channel_id': 123,
              'member_count': 50,
              'follower_count': 200,
              'video_count': 100,
              'blog_count': 50,
              'total_content_count': 150,
              'today_content_count': 5,
              'week_content_count': 20,
              'month_content_count': 50,
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getChannelStats(123);
      expect(result.totalContentCount, 150);
    });

    test('getChannelHistory sends GET /channel/{id}/history', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        return Response(
          data: {
            'status': 'success',
            'data': {
              'history': [
                {
                  'log_id': 1,
                  'operation_type': 0,
                  'operation_name': '申请加入',
                  'created_at': '2024-01-01 12:00:00',
                }
              ],
              'pagination':
                  {'page': 1, 'limit': 20, 'total': 1, 'total_pages': 1},
            },
          },
          requestOptions: RequestOptions(path: '/channel/123/history'),
        );
      });

      final result = await api.getChannelHistory(123);
      expect((result['history'] as List).length, 1);
    });

    test('getMyChannels sends GET /channel/my/channels', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/my/channels');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'channels': [
                {
                  'channel_id': 1,
                  'channel_name': 'c1',
                  'channel_title': 'C1',
                  'member_count': 5,
                  'follower_count': 10,
                  'role': 2,
                  'status': 1,
                  'joined_at': '2024-01-01 12:00:00',
                }
              ],
              'pagination':
                  {'page': 1, 'limit': 20, 'total': 1, 'total_pages': 1},
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getMyChannels();
      expect((result['channels'] as List).length, 1);
    });

    test('searchChannels sends GET /channel/search', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final params =
            invocation.namedArguments[#queryParameters] as Map<String, dynamic>;
        expect(path, '/channel/search');
        expect(params['keyword'], 'tech');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'channels': [
                {
                  'channel_id': 1,
                  'channel_name': 'techhub',
                  'channel_title': '技术',
                  'member_count': 10,
                  'follower_count': 50,
                  'creator_uid': 456,
                  'owner_uid': 456,
                  'join_permission': 0,
                }
              ],
              'total_count': 1,
              'pagination': {
                'page': 1,
                'limit': 20,
                'total': 1,
                'total_pages': 1,
                'offset': 0,
              },
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.searchChannels('tech');
      expect((result['channels'] as List).length, 1);
      expect(result['total_count'], 1);
    });

    // ── Blacklist ──

    test('blockUser sends POST /channel/{id}/blacklist', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/channel/123/blacklist');
        expect(data['uid'], 999);
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.blockUser(123, 999);
    });

    test('unblockUser sends DELETE /channel/{id}/blacklist/{uid}', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.delete(any(),
              queryParameters: any(named: 'queryParameters'),
              data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/blacklist/999');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.unblockUser(123, 999);
    });

    test('getBlacklist sends GET /channel/{id}/blacklist', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/blacklist');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'blacklist': [
                {
                  'uid': 999,
                  'username': '违规用户',
                  'blacklisted_at': '2024-01-10 10:00:00',
                }
              ],
              'pagination':
                  {'page': 1, 'limit': 20, 'total': 1, 'total_pages': 1},
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getBlacklist(123);
      expect((result['blacklist'] as List).length, 1);
    });

    // ── Sections ──

    test('getSections sends GET /channel/{id}/sections', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/sections');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'sections': [
                {
                  'channel_section_id': 1,
                  'channel_id': 123,
                  'section_name': '教程',
                  'sort_order': 0,
                  'creator_uid': 456,
                  'created_at': '2024-01-15 12:00:00',
                }
              ],
              'total_count': 1,
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getSections(123);
      expect((result['sections'] as List).length, 1);
      expect(result['total_count'], 1);
    });

    test('getSectionDetail sends GET /channel/{id}/sections/{sid}', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/sections/1');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'channel_section_id': 1,
              'channel_id': 123,
              'section_name': '教程',
              'sort_order': 0,
              'creator_uid': 456,
              'created_at': '2024-01-15 12:00:00',
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getSectionDetail(123, 1);
      expect(result.sectionName, '教程');
    });

    test('createSection sends POST /channel/{id}/sections', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/channel/123/sections');
        expect(data['section_name'], '教程');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'channel_section_id': 1,
              'channel_id': 123,
              'section_name': '教程',
              'sort_order': 0,
              'creator_uid': 456,
              'created_at': '2024-01-15 12:00:00',
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result =
          await api.createSection(123, sectionName: '教程');
      expect(result.channelSectionId, 1);
    });

    test('deleteSection sends DELETE /channel/{id}/sections/{sid}', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.delete(any(),
              queryParameters: any(named: 'queryParameters'),
              data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/sections/1');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'channel_section_id': 1,
              'channel_id': 123,
              'section_name': '教程',
              'message': '分区已删除',
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.deleteSection(123, 1);
      expect(result.channelSectionId, 1);
    });

    test('changeContentSection sends PUT /channel/{id}/content/{type}/{cid}/section',
        () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.put(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/channel/123/content/video/789/section');
        expect(data['channel_section_id'], 2);
        return Response(
          data: {
            'status': 'success',
            'data': {
              'channel_id': 123,
              'type': 'video',
              'content_id': 789,
              'old_section_id': 1,
              'new_section_id': 2,
              'message': '内容所属分区已更新',
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.changeContentSection(123, 'video', 789,
          channelSectionId: 2);
    });

    // ── Verification Codes ──

    test('sendDeleteVerificationCode sends POST /channel/{id}/delete_verification_code',
        () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/delete_verification_code');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.sendDeleteVerificationCode(123);
    });

    test('sendTransferVerificationCode sends POST /channel/{id}/transfer_verification_code',
        () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/transfer_verification_code');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.sendTransferVerificationCode(123);
    });

    // ── Timeline ──

    test('getFollowingTimeline sends GET /channel/following/timeline',
        () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/following/timeline');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'timeline': [
                {
                  'content_type': 'video',
                  'vid': 789,
                  'uid': 456,
                  'title': '视频',
                  'time': '2024-01-15 12:00:00',
                  'like_count': 50,
                  'favorite_count': 10,
                  'view_count': 1000,
                  'channel_id': 123,
                  'channel_name': 'techhub',
                  'channel_title': '技术交流社区',
                  'channel_description': '描述',
                  'channel_cover_url': 'https://example.com/cover.jpg',
                }
              ],
              'pagination':
                  {'page': 1, 'limit': 20, 'total': 1, 'total_pages': 1},
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getFollowingTimeline();
      final timeline = result['timeline'] as List;
      expect(timeline.length, 1);
      expect(
          (timeline[0] as ChannelTimelineWithChannelItem).channelId, 123);
    });

    test('getChannelTimeline sends GET /channel/{id}/timeline', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/timeline');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'timeline': [
                {
                  'content_type': 'blog',
                  'bid': 101,
                  'uid': 456,
                  'title': '动态',
                  'time': '2024-01-14 10:00:00',
                  'like_count': 20,
                  'favorite_count': 5,
                  'view_count': 500,
                }
              ],
              'pagination':
                  {'page': 1, 'limit': 20, 'total': 1, 'total_pages': 1},
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getChannelTimeline(123);
      final timeline = result['timeline'] as List;
      expect(timeline.length, 1);
    });

    // ── Notices ──

    test('createNotice sends POST /channel/{id}/notices', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/channel/123/notices');
        expect(data['content'], '公告内容');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'notice_id': 1,
              'channel_id': 123,
              'content': '公告内容',
              'sort_order': 0,
              'creator_uid': 456,
              'created_at': '2024-01-15 20:00:00',
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result =
          await api.createNotice(123, content: '公告内容');
      expect(result.noticeId, 1);
    });

    test('deleteNotice sends DELETE /channel/{id}/notices/{nid}', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.delete(any(),
              queryParameters: any(named: 'queryParameters'),
              data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/notices/1');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'notice_id': 1,
              'channel_id': 123,
              'title': '公告',
              'message': 'notice_deleted',
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.deleteNotice(123, 1);
      expect(result.noticeId, 1);
    });

    test('sortNotice sends PUT /channel/{id}/notices/{nid}/sort', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.put(any(), data: any(named: 'data')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        final data = invocation.namedArguments[#data] as Map<String, dynamic>;
        expect(path, '/channel/123/notices/1/sort');
        expect(data['sort_order'], 0);
        return Response(
          data: {
            'status': 'success',
            'data': {
              'notice_id': 1,
              'channel_id': 123,
              'sort_order': 0,
              'updated_at': '2024-01-15 21:00:00',
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      await api.sortNotice(123, 1, 0);
    });

    test('getNotices sends GET /channel/{id}/notices', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((invocation) async {
        final path = invocation.positionalArguments[0] as String;
        expect(path, '/channel/123/notices');
        return Response(
          data: {
            'status': 'success',
            'data': {
              'notices': [
                {
                  'notice_id': 1,
                  'channel_id': 123,
                  'content': '公告内容',
                  'sort_order': 0,
                  'creator_uid': 456,
                  'created_at': '2024-01-10 20:00:00',
                }
              ],
              'total_count': 1,
            },
          },
          requestOptions: RequestOptions(path: path),
        );
      });

      final result = await api.getNotices(123);
      expect((result['notices'] as List).length, 1);
      expect(result['total_count'], 1);
    });

    // ── Error handling ──

    test('error response throws ApiException', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {'status': 'error', 'message': 'permission_denied'},
                requestOptions: RequestOptions(path: '/channel/123/follow'),
              ));

      expect(() => api.followChannel(123), throwsA(isA<ApiException>()));
    });
  });
}

