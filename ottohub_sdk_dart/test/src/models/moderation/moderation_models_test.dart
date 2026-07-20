import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/src/models/moderation/moderation_item.dart';
import 'package:ottohub_sdk_dart/src/models/moderation/moderation_log.dart';

void main() {
  group('ModerationVideo', () {
    test('parses video review item', () {
      final json = {
        'vid': 123,
        'uid': 456,
        'title': '视频标题',
        'intro': '简介',
        'tag': '标签1,标签2',
        'cover_url': 'https://example.com/cover.jpg',
        'video_url': 'https://example.com/video.mp4',
        'report_reason': '违规内容',
      };
      final item = ModerationVideo.fromJson(json);
      expect(item.vid, 123);
      expect(item.title, '视频标题');
      expect(item.reportReason, '违规内容');
    });

    test('toJson uses snake_case', () {
      final item = ModerationVideo(
        vid: 1,
        uid: 2,
        title: 'test',
      );
      final json = item.toJson();
      expect(json['vid'], 1);
      expect(json['cover_url'], isNull);
    });
  });

  group('ModerationBlog', () {
    test('parses blog review item', () {
      final json = {
        'bid': 123,
        'title': '动态标题',
        'content': '动态内容',
      };
      final item = ModerationBlog.fromJson(json);
      expect(item.bid, 123);
      expect(item.content, '动态内容');
    });
  });

  group('ModerationAvatar', () {
    test('parses avatar review item', () {
      final json = {
        'uid': 123,
        'username': '用户',
        'avatar_url': 'https://example.com/avatar.jpg',
      };
      final item = ModerationAvatar.fromJson(json);
      expect(item.uid, 123);
      expect(item.username, '用户');
    });
  });

  group('ModerationCover', () {
    test('parses cover review item', () {
      final json = {
        'uid': 123,
        'username': '用户',
        'cover_url': 'https://example.com/cover.jpg',
      };
      final item = ModerationCover.fromJson(json);
      expect(item.coverUrl, 'https://example.com/cover.jpg');
    });
  });

  group('ModerationDanmaku', () {
    test('parses danmaku review item', () {
      final json = {
        'danmaku_id': 123,
        'text': '弹幕文本',
        'time': 10.5,
        'mode': 1,
        'color': '#FFFFFF',
        'font_size': 25,
        'render': '',
      };
      final item = ModerationDanmaku.fromJson(json);
      expect(item.danmakuId, 123);
      expect(item.mode, 1);
      expect(item.fontSize, 25);
    });
  });

  group('ModerationVideoComment', () {
    test('parses video comment review item', () {
      final json = {
        'vcid': 123,
        'parent_vcid': 0,
        'vid': 789,
        'uid': 456,
        'content': '评论内容',
        'time': '2024-01-01 12:00:00',
        'username': '用户',
      };
      final item = ModerationVideoComment.fromJson(json);
      expect(item.vcid, 123);
      expect(item.vid, 789);
    });
  });

  group('ModerationBlogComment', () {
    test('parses blog comment review item', () {
      final json = {
        'bcid': 123,
        'parent_bcid': 0,
        'bid': 456,
        'uid': 456,
        'content': '评论内容',
        'time': '2024-01-01 12:00:00',
        'username': '用户',
      };
      final item = ModerationBlogComment.fromJson(json);
      expect(item.bcid, 123);
      expect(item.bid, 456);
    });
  });

  group('LogUnreadCount', () {
    test('parses unread count', () {
      final json = {
        'unread_count': 5,
        'unread_approved': 3,
        'unread_rejected': 2,
      };
      final item = LogUnreadCount.fromJson(json);
      expect(item.unreadCount, 5);
      expect(item.unreadApproved, 3);
      expect(item.unreadRejected, 2);
    });
  });

  group('TargetDetail', () {
    test('parses target detail', () {
      final json = {
        'type': 'video',
        'target_id': 456,
        'title': '标题',
        'cover_url': 'https://...',
        'video_url': 'https://...',
      };
      final item = TargetDetail.fromJson(json);
      expect(item.type, 'video');
      expect(item.targetId, 456);
    });
  });

  group('ModerationLog', () {
    test('parses full log entry', () {
      final json = {
        'log_id': 1001,
        'operator_uid': 9001,
        'operator_username': 'reviewer',
        'owner_uid': 123,
        'owner_username': 'alice',
        'audit_type': 'video',
        'action': 2,
        'reject_reason': '不符合规范',
        'target_id': 456,
        'is_read': 0,
        'is_unread': 1,
        'created_at': '2026-02-12 13:00:00',
        'view_role': 'user',
      };
      final item = ModerationLog.fromJson(json);
      expect(item.logId, 1001);
      expect(item.auditType, 'video');
      expect(item.action, 2);
      expect(item.isUnread, 1);
    });
  });

  group('ModerationLogListData', () {
    test('parses log list response', () {
      final json = {
        'role': 'user',
        'is_admin': 0,
        'is_audit': 0,
        'offset': 0,
        'num': 20,
        'logs': [
          {
            'log_id': 1001,
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
      };
      final item = ModerationLogListData.fromJson(json);
      expect(item.role, 'user');
      expect(item.logs.length, 1);
      expect(item.logs[0].logId, 1001);
    });
  });
}

