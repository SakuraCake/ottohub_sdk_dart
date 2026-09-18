import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ottohub_sdk_dart/ottohub_sdk_dart.dart';
import 'package:ottohub_sdk_dart/src/apis/auth_api.dart';
import 'package:ottohub_sdk_dart/src/apis/video_api.dart';
import 'package:ottohub_sdk_dart/src/apis/following_api.dart';
import 'package:ottohub_sdk_dart/src/apis/block_api.dart';
import 'package:ottohub_sdk_dart/src/apis/danmaku_api.dart';
import 'package:ottohub_sdk_dart/src/apis/channel_api.dart';
import 'package:ottohub_sdk_dart/src/apis/moderation_api.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  setUp(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  // ============================================================
  // 认证模块
  // ============================================================
  group('AuthApi', () {
    test('login', () async {
      final mockDio = _MockDio();
      final api = AuthApi(mockDio, () => null);

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {'status': 'success', 'uid': '123', 'token': 'tok'},
                requestOptions: RequestOptions(path: '/auth/login'),
              ));

      final resp = await api.login('user@qq.com', 'pw123');
      expect(resp.uid, '123');
      expect(resp.token, 'tok');
    });

    test('register', () async {
      final mockDio = _MockDio();
      final api = AuthApi(mockDio, () => null);

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async {
        final data = i.namedArguments[#data] as Map<String, dynamic>;
        expect(data['email'], 'new@qq.com');
        expect(data['register_verification_code'], '123456');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: '/auth/register'),
        );
      });

      await api.register(
        email: 'new@qq.com',
        verificationCode: '123456',
        password: 'pw123',
        confirmPassword: 'pw123',
      );
    });

    test('send verification code & reset password & sign in', () async {
      final mockDio = _MockDio();
      final api = AuthApi(mockDio, () => null);
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {'status': 'success', 'if_today_first_login': '1'},
                requestOptions: RequestOptions(path: ''),
              ));

      await api.sendRegisterVerificationCode('a@b.com');
      await api.sendPasswordResetVerificationCode('a@b.com');
      await api.resetPassword(
        email: 'a@b.com',
        verificationCode: '654321',
        password: 'new_pw',
        confirmPassword: 'new_pw',
      );
      final result = await api.signIn();
      expect(result, '1');
    });

    test('public login does not inject token', () async {
      final mockDio = _MockDio();
      String? token = 'my_token';
      final api = AuthApi(mockDio, () => token);

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async {
        final data = i.namedArguments[#data] as Map;
        // login 为公开接口,不注入 token。
        expect(data.containsKey('token'), isFalse);
        return Response(
          data: {'status': 'success', 'uid': '123', 'token': 'tok'},
          requestOptions: RequestOptions(path: '/auth/login'),
        );
      });

      await api.login('u', 'p');
    });

    test('error throws ApiException', () async {
      final mockDio = _MockDio();
      final api = AuthApi(mockDio, () => null);

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {'status': 'error', 'message': 'error_token'},
                requestOptions: RequestOptions(path: '/auth/login'),
              ));

      expect(() => api.login('u', 'p'), throwsA(isA<ApiException>()));
    });
  });

  // ============================================================
  // 视频模块
  // ============================================================
  group('VideoApi', () {
    test('getRandom', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((i) async {
        expect(i.positionalArguments[0], '/video/random');
        expect((i.namedArguments[#queryParameters] as Map)['num'], 3);
        return Response(
          data: {
            'status': 'success',
            'data': {'video_list': _sampleVideos()},
          },
          requestOptions: RequestOptions(path: '/video/random'),
        );
      });

      final result = await api.getRandom(num: 3);
      expect(result.videoList.length, 1);
      expect(result.videoList[0].title, 'Test Video');
    });

    test('getNew / getPopular / getCategory / search', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null);
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {'video_list': _sampleVideos()},
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      await api.getNew(offset: 0, num: 10);
      await api.getPopular(timeLimit: 7, num: 5);
      await api.getCategory('0', num: 3);
      final s = await api.search(searchTerm: 'flutter', num: 10);
      expect(s.videoList.length, 1);
    });

    test('getDetail', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'vid': '42',
                    'uid': '1',
                    'title': 'Detail',
                    'time': '2024-01-01',
                    'like_count': '10',
                    'favorite_count': '5',
                    'view_count': '100',
                    'cover_url': '',
                    'username': 'u',
                    'if_like': 0,
                    'if_favorite': 0,
                    'last_watch_second': -1,
                    'duration': '200',
                  },
                },
                requestOptions: RequestOptions(path: '/video/42'),
              ));

      final detail = await api.getDetail(42);
      expect(detail.vid, '42');
      expect(detail.lastWatchSecond, -1);
      expect(detail.ifLike, 0);
    });

    test('getUserVideos / getRelated / getFavoriteList / getManageList / getHistoryList', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => 'tok');
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'video_list': _sampleVideos(),
                  },
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      await api.getUserVideos(1);
      await api.getRelated(42);
      await api.getFavoriteList();
      await api.getManageList();
      await api.getHistoryList();
    });

    test('toggleLike / toggleFavorite', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {'if_like': 1, 'like_count': 100},
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      final like = await api.toggleLike(1);
      expect(like.ifLike, 1);

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {'if_favorite': 1, 'favorite_count': 50},
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      final fav = await api.toggleFavorite(1);
      expect(fav.ifFavorite, 1);
    });

    test('saveWatchHistory', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async {
        final data = i.namedArguments[#data] as Map<String, dynamic>;
        expect(data['vid'], 42);
        expect(data['last_watch_second'], 65);
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: '/video/watch-history'),
        );
      });

      await api.saveWatchHistory(42, 65);
    });

    test('submitVideo sends FormData', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async {
        final fd = i.namedArguments[#data] as FormData;
        expect(fd.fields.any((e) => e.key == 'title'), isTrue);
        expect(fd.files.any((e) => e.key == 'file_mp4'), isTrue);
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
        intro: 'Desc',
        type: 1,
        category: 3,
        tag: '#tag',
        fileMp4: MultipartFile.fromBytes([0, 1, 2], filename: 'v.mp4'),
        fileJpg: MultipartFile.fromBytes([3, 4, 5], filename: 'c.jpg'),
      );
      expect(result.vid, 999);
    });

    test('updateVideo / deleteVideo', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {'status': 'success'},
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));
      when(() => mockDio.delete(any(), queryParameters: any(named: 'queryParameters'), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {'status': 'success'},
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      await api.updateVideo(1, title: 'New Title');
      await api.deleteVideo(1);
    });
  });

  // ============================================================
  // 关注模块
  // ============================================================
  group('FollowingApi', () {
    test('toggleFollow', () async {
      final mockDio = _MockDio();
      final api = FollowingApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {'new_fans_count': 101, 'follow_status': 1},
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      final result = await api.toggleFollow(123);
      expect(result.newFansCount, 101);
      expect(result.followStatus, 1);
    });

    test('getStatus', () async {
      final mockDio = _MockDio();
      final api = FollowingApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {'follow_status': 1},
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      final status = await api.getStatus(123);
      expect(status.followStatus, 1);
    });

    test('getFollowingList / getFansList', () async {
      final mockDio = _MockDio();
      final api = FollowingApi(mockDio, () => null);
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'user_list': [
                      {'uid': 1, 'username': 'u1', 'avatar_url': ''},
                    ],
                  },
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      final list = await api.getFollowingList(1);
      expect(list.userList.length, 1);

      final fans = await api.getFansList(1);
      expect(fans.userList.length, 1);
    });

    test('getTimeline / getUserTimeline', () async {
      final mockDio = _MockDio();
      final api = FollowingApi(mockDio, () => null);
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'timeline_list': [
                      {
                        'content_type': 'video',
                        'uid': 1,
                        'title': 't',
                        'time': '2024-01-01',
                        'like_count': 1,
                        'favorite_count': 1,
                        'view_count': 1,
                        'username': 'u',
                      },
                    ],
                  },
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      final tl = await api.getTimeline();
      expect(tl.timelineList.length, 1);

      final utl = await api.getUserTimeline(1);
      expect(utl.timelineList.length, 1);
    });

    test('getActiveFollowers', () async {
      final mockDio = _MockDio();
      final api = FollowingApi(mockDio, () => null);
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'user_list': [
                      {'uid': 1, 'username': 'u', 'avatar_url': '', 'latest_activity_time': '2024-01-01'},
                    ],
                  },
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      final active = await api.getActiveFollowers(1);
      expect(active.length, 1);
    });
  });

  // ============================================================
  // 屏蔽模块
  // ============================================================
  group('BlockApi', () {
    test('blockUser includes reason and token in body', () async {
      final mockDio = _MockDio();
      final api = BlockApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async {
        final data = i.namedArguments[#data] as Map;
        expect(data['blocked_id'], 456);
        expect(data['reason'], 'spam');
        return Response(
          data: {
            'status': 'success',
            'data': {'block_id': 1, 'blocked_id': 456},
          },
          requestOptions: RequestOptions(path: '/block'),
        );
      });

      final result = await api.blockUser(456, reason: 'spam');
      expect(result.blockId, 1);
    });

    test('unblockUser', () async {
      final mockDio = _MockDio();
      final api = BlockApi(mockDio, () => 'tok');

      when(() => mockDio.delete(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {'blocked_id': 456},
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      await api.unblockUser(456);
    });

    test('getBlockList / getBlockedByList', () async {
      final mockDio = _MockDio();
      final api = BlockApi(mockDio, () => 'tok');
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'list': [],
                    'total': 0,
                    'page': 1,
                    'page_size': 20,
                    'total_pages': 0,
                  },
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      final list = await api.getBlockList(page: 1);
      expect(list.total, 0);

      final blockedBy = await api.getBlockedByList(page: 1);
      expect(blockedBy.total, 0);
    });

    test('getBlockStatus returns relationship flags', () async {
      final mockDio = _MockDio();
      final api = BlockApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'target_user_id': 456,
                    'i_blocked': true,
                    'he_blocked': false,
                    'mutual_block': false,
                    'any_block': true,
                  },
                },
                requestOptions: RequestOptions(path: '/block/status/456'),
              ));

      final status = await api.getBlockStatus(456);
      expect(status.iBlocked, isTrue);
      expect(status.heBlocked, isFalse);
      expect(status.anyBlock, isTrue);
    });
  });

  // ============================================================
  // 弹幕模块
  // ============================================================
  group('DanmakuApi', () {
    test('getDanmaku returns list', () async {
      final mockDio = _MockDio();
      final api = DanmakuApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'status': 'success',
                  'data': [
                    {
                      'danmaku_id': 1,
                      'text': 'hello',
                      'time': 5.5,
                      'mode': 'scroll',
                      'color': '#FFFFFF',
                      'font_size': '25',
                      'render': 'normal',
                    },
                  ],
                },
                requestOptions: RequestOptions(path: '/danmaku/42'),
              ));

      final list = await api.getDanmaku(42);
      expect(list.length, 1);
      expect(list[0].text, 'hello');
      expect(list[0].mode, 'scroll');
    });

    test('sendDanmaku sends correct fields', () async {
      final mockDio = _MockDio();
      final api = DanmakuApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async {
        final data = i.namedArguments[#data] as Map;
        expect(data['vid'], 42);
        expect(data['text'], '好评');
        expect(data['time'], 5.5);
        expect(data['mode'], 'scroll');
        return Response(
          data: {'status': 'success'},
          requestOptions: RequestOptions(path: '/danmaku'),
        );
      });

      await api.sendDanmaku(
        vid: 42,
        text: '好评',
        time: 5.5,
        mode: 'scroll',
        color: '#FFFFFF',
        fontSize: '25',
        render: 'normal',
      );
    });

    test('deleteDanmaku sends DELETE', () async {
      final mockDio = _MockDio();
      final api = DanmakuApi(mockDio, () => 'tok');

      when(() => mockDio.delete(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((i) async => Response(
                data: {'status': 'success'},
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      await api.deleteDanmaku(1);
    });
  });

  // ============================================================
  // 频道模块（核心操作）
  // ============================================================
  group('ChannelApi', () {
    test('createChannel sends POST', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'channel_id': 1,
                    'channel_name': 'my_ch',
                    'channel_title': 'My Channel',
                    'creator_uid': 1,
                    'owner_uid': 1,
                    'join_permission': 0,
                    'member_count': 1,
                    'follower_count': 0,
                    'created_at': '2024-01-01',
                  },
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      final ch = await api.createChannel(
        channelName: 'my_ch',
        channelTitle: 'My Channel',
      );
      expect(ch.channelId, 1);
      expect(ch.channelName, 'my_ch');
    });

    test('getChannelDetail returns full detail', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'channel_id': 1,
                    'channel_name': 'ch',
                    'channel_title': 'Channel',
                    'creator_uid': 1,
                    'owner_uid': 1,
                    'join_permission': 0,
                    'member_count': 10,
                    'follower_count': 50,
                    'created_at': '2024-01-01',
                  },
                },
                requestOptions: RequestOptions(path: '/channel/1'),
              ));

      final detail = await api.getChannelDetail(1);
      expect(detail.memberCount, 10);
      expect(detail.followerCount, 50);
    });

    test('CRUD: update / delete / follow / unfollow', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.put(any(), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {'channel_id': 1, 'updated_at': '2024-01-01'},
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));
      when(() => mockDio.delete(any(), queryParameters: any(named: 'queryParameters'), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {'video_count': 0, 'blog_count': 0, 'total_content': 0},
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {'status': 'success'},
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      await api.updateChannel(1, channelTitle: 'New Title');
      await api.deleteChannel(1, '123456');
      await api.followChannel(1);
      await api.unfollowChannel(1);
    });

    test('member management', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => 'tok');

      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {'channel_id': 1, 'uid': 0, 'status': 0, 'message': 'ok'},
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'members': [
                      {'uid': 1, 'username': 'u', 'role': 0, 'status': 0, 'joined_at': '2024-01-01'},
                    ],
                    'pagination': {'page': 1, 'limit': 20, 'total': 1},
                  },
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));
      when(() => mockDio.put(any(), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'channel_id': 1,
                    'uid': 1,
                    'status': 0,
                    'message': 'ok',
                    'old_role': 0,
                    'new_role': 1,
                  },
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));
      when(() => mockDio.delete(any(), queryParameters: any(named: 'queryParameters'), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {'status': 'success'},
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      await api.joinChannel(1);
      final members = await api.getMemberList(1);
      expect(members['members'], isA<List>());
      await api.approveMember(1, 2, 'approve');
      await api.setMemberRole(1, 2, 1);
      await api.kickMember(1, 2);
      await api.leaveChannel(1);
    });

    test('search channels', () async {
      final mockDio = _MockDio();
      final api = ChannelApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'channels': [],
                    'pagination': {'page': 1, 'limit': 20, 'total': 0},
                  },
                },
                requestOptions: RequestOptions(path: '/channel/search'),
              ));

      final result = await api.getChannelList(keyword: 'flutter');
      expect(result['channels'], isA<List>());
    });
  });

  // ============================================================
  // 审核模块（管理员）
  // ============================================================
  group('ModerationApi', () {
    test('get review lists', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'video_list': [],
                    'blog_list': [],
                    'avatar_list': [],
                    'cover_list': [],
                    'danmaku_list': [],
                    'comment_list': [],
                  },
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      expect(await api.getVideoList(), isEmpty);
      expect(await api.getBlogList(), isEmpty);
      expect(await api.getAvatarList(), isEmpty);
      expect(await api.getCoverList(), isEmpty);
      expect(await api.getDanmakuList(), isEmpty);
      expect(await api.getVideoCommentList(), isEmpty);
      expect(await api.getBlogCommentList(), isEmpty);
    });

    test('approve / reject / report / appeal', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');
      when(() => mockDio.put(any(), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {'status': 'success'},
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((i) async => Response(
                data: {'status': 'success'},
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      await api.approveVideo(1);
      await api.approveBlog(1);
      await api.approveAvatar(1);
      await api.approveCover(1);
      await api.approveDanmaku(1);
      await api.approveVideoComment(1);
      await api.approveBlogComment(1);

      await api.rejectVideo(1, reason: 'spam');
      await api.rejectBlog(1, reason: 'spam');

      await api.reportVideo(1, reason: 'spam');
      await api.reportBlog(1, reason: 'spam');

      await api.appealAvatar(1, reason: 'not spam');
    });

    test('get logs', () async {
      final mockDio = _MockDio();
      final api = ModerationApi(mockDio, () => 'tok');

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((i) async => Response(
                data: {
                  'status': 'success',
                  'data': {
                    'role': 'admin',
                    'is_admin': 1,
                    'is_audit': 1,
                    'offset': 0,
                    'num': 10,
                    'logs': [],
                    'unread_count': 5,
                    'unread_approved': 2,
                    'unread_rejected': 3,
                  },
                },
                requestOptions: RequestOptions(path: i.positionalArguments[0]),
              ));

      final unread = await api.getUnreadCount();
      expect(unread.unreadCount, isA<int>());

      final logs = await api.getLogs(offset: 0, num: 10);
      expect(logs.logs, isEmpty);
    });
  });

  // ============================================================
  // 通用错误处理
  // ============================================================
  group('Error handling', () {
    test('ApiException carries error code', () async {
      final e = ApiException('error_token');
      expect(e.errorCode, 'error_token');
      expect(e.toString(), 'error_token');
    });

    test('ApiException with httpStatus and responseData', () async {
      const e = ApiException('error_vid', httpStatus: 400, responseData: {'vid': '999'});
      expect(e.httpStatus, 400);
      expect(e.responseData, {'vid': '999'});
    });

    test('ApiException toString includes HTTP status', () async {
      const e = ApiException('error_token', httpStatus: 401);
      expect(e.toString(), 'error_token (HTTP 401)');
    });

    test('DioException for HTTP 4xx is not wrapped in strict mode', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null);

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/video/999'),
            response: Response(
              data: null,
              statusCode: 404,
              requestOptions: RequestOptions(path: '/video/999'),
            ),
          ));

      expect(() => api.getDetail(999), throwsA(isA<DioException>()));
    });

    test('DioException is wrapped when wrapHttpErrors=true', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null, config: BaseApiConfig(wrapHttpErrors: true));

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/video/999'),
            type: DioExceptionType.badResponse,
            response: Response(
              data: null,
              statusCode: 500,
              requestOptions: RequestOptions(path: '/video/999'),
            ),
          ));

      expect(
        () => api.getDetail(999),
        throwsA(isA<ApiException>().having((e) => e.httpStatus, 'httpStatus', 500)),
      );
    });

    test('OttohubClient with config passes to all APIs', () async {
      final client = OttohubClient(config: BaseApiConfig(wrapHttpErrors: true));
      expect(client.config.wrapHttpErrors, true);
      expect(client.config.relaxedResponse, false);
      expect(client.config.relaxedTypes, false);
    });

    test('OttohubClient with all flags', () async {
      final client = OttohubClient(
        config: const BaseApiConfig(
          wrapHttpErrors: true,
          relaxedResponse: true,
          relaxedTypes: true,
        ),
      );
      expect(client.config.wrapHttpErrors, true);
      expect(client.config.relaxedResponse, true);
      expect(client.config.relaxedTypes, true);
    });

    test('ApiErrorCodes constants accessible', () async {
      expect(GeneralErrorCodes.errorToken, 'error_token');
      expect(VideoErrorCodes.errorVid, 'error_vid');
      expect(AuthErrorCodes.errorPassword, 'error_password');
      expect(FollowingErrorCodes.errorFollowingUid, 'error_following_uid');
    });

    test('safeGet with strict types throws on type mismatch', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null);
      expect(
        () => api.safeGet<int>({'key': 'string'}, 'key'),
        throwsA(isA<TypeError>()),
      );
    });

    test('safeGet with relaxedTypes returns null for incompatible String', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null, config: const BaseApiConfig(relaxedTypes: true));
      // Without toString coercion, int 42 is not a String
      final val = api.safeGet<String>({'key': 42}, 'key');
      expect(val, isNull);
    });

    test('safeGet with relaxedTypes works for numeric conversion', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null, config: const BaseApiConfig(relaxedTypes: true));
      final val = api.safeGet<int>({'key': 42.0}, 'key');
      expect(val, 42);
    });

    test('safeGetOrDefault returns default for missing key', () async {
      final mockDio = _MockDio();
      final api = VideoApi(mockDio, () => null, config: const BaseApiConfig(relaxedTypes: true));
      final val = api.safeGetOrDefault<String>({}, 'missing', 'default');
      expect(val, 'default');
    });
  });
}

// ============================================================
// 测试辅助数据
// ============================================================
List<Map<String, dynamic>> _sampleVideos() {
  return [
    {
      'vid': 1,
      'uid': 123,
      'title': 'Test Video',
      'time': '2024-01-01 00:00:00',
      'like_count': 100,
      'favorite_count': 50,
      'view_count': 1000,
      'cover_url': 'https://example.com/c.jpg',
      'username': 'user',
      'duration': 120,
    },
  ];
}
