import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/src/models/channel/channel_summary.dart';
import 'package:ottohub_sdk_dart/src/models/channel/channel_detail.dart';
import 'package:ottohub_sdk_dart/src/models/channel/channel_member.dart';
import 'package:ottohub_sdk_dart/src/models/channel/channel_content_item.dart';
import 'package:ottohub_sdk_dart/src/models/channel/channel_timeline_item.dart';
import 'package:ottohub_sdk_dart/src/models/channel/channel_stats.dart';
import 'package:ottohub_sdk_dart/src/models/channel/channel_history_item.dart';
import 'package:ottohub_sdk_dart/src/models/channel/channel_section.dart';
import 'package:ottohub_sdk_dart/src/models/channel/channel_notice.dart';
import 'package:ottohub_sdk_dart/src/models/channel/channel_blacklist_entry.dart';
import 'package:ottohub_sdk_dart/src/models/channel/channel_responses.dart';

void main() {
  group('ChannelSummary', () {
    test('parses from JSON', () {
      final json = {
        'channel_id': 123,
        'channel_name': 'techhub',
        'channel_title': '技术交流社区',
        'description': '技术讨论',
        'cover_url': 'https://example.com/cover.jpg',
        'member_count': 50,
        'follower_count': 200,
        'created_at': '2024-01-01 12:00:00',
      };
      final item = ChannelSummary.fromJson(json);
      expect(item.channelId, 123);
      expect(item.channelName, 'techhub');
      expect(item.channelTitle, '技术交流社区');
      expect(item.memberCount, 50);
    });

    test('toJson uses snake_case', () {
      final item = ChannelSummary(
        channelId: 1,
        channelName: 'test',
        channelTitle: 'Test',
        memberCount: 5,
        followerCount: 10,
      );
      final json = item.toJson();
      expect(json['channel_id'], 1);
      expect(json['channel_name'], 'test');
      expect(json.containsKey('channelId'), isFalse);
    });
  });

  group('ChannelDetail', () {
    test('parses full detail JSON', () {
      final json = {
        'channel_id': 123,
        'channel_name': 'techhub',
        'channel_title': '技术交流社区',
        'description': '技术讨论和分享',
        'cover_url': 'https://example.com/cover.jpg',
        'creator_uid': 456,
        'owner_uid': 456,
        'admin_uids': [789, 101],
        'join_permission': 0,
        'member_count': 50,
        'follower_count': 200,
        'created_at': '2024-01-01 12:00:00',
        'is_member': true,
        'user_role': 0,
      };
      final item = ChannelDetail.fromJson(json);
      expect(item.channelId, 123);
      expect(item.creatorUid, 456);
      expect(item.adminUids, [789, 101]);
      expect(item.isMember, isTrue);
      expect(item.userRole, 0);
    });
  });

  group('ChannelMember', () {
    test('parses member JSON', () {
      final json = {
        'uid': 456,
        'username': '张三',
        'avatar_url': 'https://example.com/avatar.jpg',
        'role': 0,
        'status': 1,
        'joined_at': '2024-01-01 12:00:00',
      };
      final item = ChannelMember.fromJson(json);
      expect(item.uid, 456);
      expect(item.role, 0);
      expect(item.status, 1);
    });
  });

  group('ChannelMemberApplication', () {
    test('parses application JSON', () {
      final json = {
        'uid': 456,
        'username': '张三',
        'status': 0,
        'applied_at': '2024-01-15 10:00:00',
      };
      final item = ChannelMemberApplication.fromJson(json);
      expect(item.uid, 456);
      expect(item.status, 0);
    });
  });

  group('ChannelContentItem', () {
    test('parses video content JSON', () {
      final json = {
        'type': 'video',
        'vid': 789,
        'uid': 456,
        'title': '视频标题',
        'cover_url': 'https://example.com/cover.jpg',
        'view_count': 1000,
        'like_count': 50,
        'created_at': '2024-01-15 12:00:00',
      };
      final item = ChannelContentItem.fromJson(json);
      expect(item.type, 'video');
      expect(item.vid, 789);
      expect(item.bid, isNull);
      expect(item.viewCount, 1000);
    });

    test('parses blog content JSON', () {
      final json = {
        'type': 'blog',
        'bid': 101,
        'uid': 456,
        'title': '动态标题',
        'thumbnails': ['https://example.com/thumb.jpg'],
        'view_count': 500,
        'created_at': '2024-01-14 10:00:00',
      };
      final item = ChannelContentItem.fromJson(json);
      expect(item.type, 'blog');
      expect(item.bid, 101);
      expect(item.thumbnails, ['https://example.com/thumb.jpg']);
    });
  });

  group('ChannelTimelineItem', () {
    test('parses timeline item JSON', () {
      final json = {
        'content_type': 'video',
        'vid': 789,
        'uid': 456,
        'title': '视频标题',
        'time': '2024-01-15 12:00:00',
        'like_count': 50,
        'favorite_count': 10,
        'view_count': 1000,
        'cover_url': 'https://example.com/cover.jpg',
        'username': '作者',
      };
      final item = ChannelTimelineItem.fromJson(json);
      expect(item.contentType, 'video');
      expect(item.likeCount, 50);
      expect(item.favoriteCount, 10);
    });
  });

  group('ChannelTimelineWithChannelItem', () {
    test('parses timeline with channel info', () {
      final json = {
        'content_type': 'video',
        'vid': 789,
        'uid': 456,
        'title': '视频标题',
        'time': '2024-01-15 12:00:00',
        'like_count': 50,
        'favorite_count': 10,
        'view_count': 1000,
        'cover_url': 'https://example.com/cover.jpg',
        'channel_id': 123,
        'channel_name': 'techhub',
        'channel_title': '技术交流社区',
        'channel_description': '技术讨论',
        'channel_cover_url': 'https://example.com/channel_cover.jpg',
      };
      final item = ChannelTimelineWithChannelItem.fromJson(json);
      expect(item.channelId, 123);
      expect(item.channelName, 'techhub');
      expect(item, isA<ChannelTimelineItem>());
    });
  });

  group('ChannelStats', () {
    test('parses stats JSON', () {
      final json = {
        'channel_id': 123,
        'member_count': 50,
        'follower_count': 200,
        'video_count': 100,
        'blog_count': 50,
        'total_content_count': 150,
        'today_content_count': 5,
        'week_content_count': 20,
        'month_content_count': 50,
      };
      final item = ChannelStats.fromJson(json);
      expect(item.channelId, 123);
      expect(item.totalContentCount, 150);
      expect(item.todayContentCount, 5);
    });
  });

  group('ChannelHistoryItem', () {
    test('parses history JSON', () {
      final json = {
        'log_id': 1,
        'operation_type': 0,
        'operation_name': '申请加入',
        'operator_uid': null,
        'operator_name': '自己',
        'old_status': null,
        'new_status': 0,
        'old_role': null,
        'new_role': 0,
        'reason': null,
        'created_at': '2024-01-01 12:00:00',
      };
      final item = ChannelHistoryItem.fromJson(json);
      expect(item.logId, 1);
      expect(item.operationType, 0);
      expect(item.operationName, '申请加入');
      expect(item.operatorUid, isNull);
    });
  });

  group('ChannelSection', () {
    test('parses section JSON with content count', () {
      final json = {
        'channel_section_id': 1,
        'channel_id': 123,
        'section_name': '技术教程',
        'description': '技术相关的教程和指南',
        'icon_url': 'https://example.com/icon.jpg',
        'sort_order': 1,
        'creator_uid': 456,
        'created_at': '2024-01-15 12:00:00',
        'is_deleted': 0,
        'content_count': {
          'video_count': 25,
          'blog_count': 10,
          'total_count': 35,
        },
      };
      final item = ChannelSection.fromJson(json);
      expect(item.channelSectionId, 1);
      expect(item.contentCount!.videoCount, 25);
      expect(item.contentCount!.totalCount, 35);
    });
  });

  group('ContentCount', () {
    test('parses content count JSON', () {
      final json = {'video_count': 25, 'blog_count': 10, 'total_count': 35};
      final item = ContentCount.fromJson(json);
      expect(item.videoCount, 25);
      expect(item.totalCount, 35);
    });
  });

  group('SectionStats', () {
    test('parses section stats JSON', () {
      final json = {
        'channel_section_id': 1,
        'channel_id': 123,
        'section_name': '技术教程',
        'video': {
          'approved_count': 25,
          'pending_count': 3,
          'total_views': 15000,
          'total_likes': 500,
        },
        'blog': {
          'approved_count': 10,
          'pending_count': 2,
          'total_views': 5000,
          'total_likes': 200,
        },
        'total': {
          'approved_count': 35,
          'pending_count': 5,
          'total_views': 20000,
          'total_likes': 700,
        },
      };
      final item = SectionStats.fromJson(json);
      expect(item.channelSectionId, 1);
      expect(item.video.approvedCount, 25);
      expect(item.video.pendingCount, 3);
      expect(item.blog.approvedCount, 10);
      expect(item.total.totalViews, 20000);
    });
  });

  group('ChannelNotice', () {
    test('parses notice JSON', () {
      final json = {
        'notice_id': 1,
        'channel_id': 123,
        'title': '维护公告',
        'content': '今晚维护。',
        'sort_order': 0,
        'creator_uid': 456,
        'created_at': '2024-01-10 20:00:00',
        'is_deleted': 0,
      };
      final item = ChannelNotice.fromJson(json);
      expect(item.noticeId, 1);
      expect(item.content, '今晚维护。');
      expect(item.sortOrder, 0);
    });
  });

  group('ChannelBlacklistEntry', () {
    test('parses blacklist JSON', () {
      final json = {
        'uid': 999,
        'username': '违规用户',
        'avatar_url': 'https://example.com/avatar.jpg',
        'reason': '发布违规内容',
        'operator_uid': 789,
        'operator_name': '管理员A',
        'blacklisted_at': '2024-01-10 10:00:00',
      };
      final item = ChannelBlacklistEntry.fromJson(json);
      expect(item.uid, 999);
      expect(item.reason, '发布违规内容');
      expect(item.operatorName, '管理员A');
    });
  });

  group('Response models', () {
    test('UpdateChannelResponse', () {
      final json = {'channel_id': 123, 'updated_at': '2024-01-15 15:00:00'};
      final item = UpdateChannelResponse.fromJson(json);
      expect(item.channelId, 123);
    });

    test('MemberActionResponse', () {
      final json = {
        'channel_id': 123,
        'uid': 456,
        'status': 1,
        'message': '申请已通过',
      };
      final item = MemberActionResponse.fromJson(json);
      expect(item.status, 1);
    });

    test('RoleChangeResponse', () {
      final json = {
        'uid': 456,
        'old_role': 0,
        'new_role': 1,
        'message': '角色已更新',
      };
      final item = RoleChangeResponse.fromJson(json);
      expect(item.oldRole, 0);
      expect(item.newRole, 1);
    });

    test('ContentAddResponse', () {
      final json = {
        'channel_id': 123,
        'channel_section_id': 1,
        'type': 'video',
        'content_id': 789,
        'message': '内容已添加到频道',
      };
      final item = ContentAddResponse.fromJson(json);
      expect(item.type, 'video');
      expect(item.contentId, 789);
    });

    test('SectionContentChangeResponse', () {
      final json = {
        'channel_id': 123,
        'type': 'video',
        'content_id': 789,
        'old_section_id': 1,
        'new_section_id': 2,
        'message': '内容所属分区已更新',
      };
      final item = SectionContentChangeResponse.fromJson(json);
      expect(item.oldSectionId, 1);
      expect(item.newSectionId, 2);
    });

    test('DeleteSectionResponse', () {
      final json = {
        'channel_section_id': 1,
        'channel_id': 123,
        'section_name': '技术教程',
        'transferred_content_count': 25,
        'transfer_to_section_id': 2,
        'message': '分区已删除，内容已转移',
      };
      final item = DeleteSectionResponse.fromJson(json);
      expect(item.transferredContentCount, 25);
      expect(item.transferToSectionId, 2);
    });

    test('DeleteChannelResponse', () {
      final json = {
        'video_count': 25,
        'blog_count': 10,
        'total_content': 35,
      };
      final item = DeleteChannelResponse.fromJson(json);
      expect(item.videoCount, 25);
      expect(item.totalContent, 35);
    });

    test('NoticeCreateResponse', () {
      final json = {
        'notice_id': 1,
        'channel_id': 123,
        'title': '公告',
        'content': '内容',
        'sort_order': 3,
        'creator_uid': 456,
        'created_at': '2024-01-15 20:00:00',
      };
      final item = NoticeCreateResponse.fromJson(json);
      expect(item.noticeId, 1);
      expect(item.sortOrder, 3);
    });

    test('NoticeDeleteResponse', () {
      final json = {
        'notice_id': 1,
        'channel_id': 123,
        'title': '公告',
        'message': 'notice_deleted',
      };
      final item = NoticeDeleteResponse.fromJson(json);
      expect(item.message, 'notice_deleted');
    });

    test('NoticeSortResponse', () {
      final json = {
        'notice_id': 1,
        'channel_id': 123,
        'sort_order': 0,
        'updated_at': '2024-01-15 21:00:00',
      };
      final item = NoticeSortResponse.fromJson(json);
      expect(item.sortOrder, 0);
    });
  });
}

