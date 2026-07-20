import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/src/models/video/video_summary.dart';

void main() {
  group('VideoSummary', () {
    test('parses full list item from random/new/popular API', () {
      final json = {
        'vid': 1,
        'uid': 123,
        'title': '视频标题',
        'time': '2023-01-01 00:00:00',
        'like_count': 100,
        'favorite_count': 50,
        'view_count': 1000,
        'duration': 120,
        'cover_url': 'https://example.com/cover.jpg',
        'username': '用户名',
        'avatar_url': 'https://example.com/avatar.jpg',
      };

      final item = VideoSummary.fromJson(json);

      expect(item.vid, 1);
      expect(item.uid, 123);
      expect(item.title, '视频标题');
      expect(item.time, '2023-01-01 00:00:00');
      expect(item.likeCount, 100);
      expect(item.favoriteCount, 50);
      expect(item.viewCount, 1000);
      expect(item.duration, 120);
      expect(item.coverUrl, 'https://example.com/cover.jpg');
      expect(item.username, '用户名');
      expect(item.avatarUrl, 'https://example.com/avatar.jpg');
    });

    test('parses search result with extra fields', () {
      final json = {
        'vid': 1,
        'uid': 123,
        'title': '搜索视频',
        'time': '2023-01-01 00:00:00',
        'like_count': 100,
        'favorite_count': 50,
        'view_count': 1000,
        'cover_url': 'https://example.com/cover.jpg',
        'username': '用户',
        'avatar_url': null,
        'duration': 120,
        'intro': '简介内容',
        'tag': '#标签1#标签2',
        'collection': '合集名称',
        'type': 1,
        'category': '分类名',
      };

      final item = VideoSummary.fromJson(json);

      expect(item.intro, '简介内容');
      expect(item.tag, '#标签1#标签2');
      expect(item.collection, '合集名称');
      expect(item.type, 1);
      expect(item.category, '分类名');
      expect(item.avatarUrl, isNull);
    });

    test('parses manage-list item with channel detail', () {
      final json = {
        'vid': 1,
        'uid': 123,
        'title': '管理视频',
        'time': '2023-01-01 00:00:00',
        'like_count': 100,
        'favorite_count': 50,
        'view_count': 1000,
        'cover_url': 'https://example.com/cover.jpg',
        'username': '用户',
        'avatar_url': 'https://example.com/avatar.jpg',
        'duration': 120,
        'collection': '合集',
        'collection_sort_order': 0,
        'channel_id': 1,
        'channel_detail': {
          'channel_id': 1,
          'channel_name': '频道名称',
          'channel_title': '频道标题',
          'description': '频道描述',
          'cover_url': 'https://example.com/channel_cover.jpg',
        },
      };

      final item = VideoSummary.fromJson(json);

      expect(item.collection, '合集');
      expect(item.collectionSortOrder, 0);
      expect(item.channelId, 1);

      final cd = item.channelDetail;
      expect(cd, isNotNull);
      expect(cd!.channelId, '1');
      expect(cd.channelName, '频道名称');
      expect(cd.channelTitle, '频道标题');
      expect(cd.description, '频道描述');
      expect(cd.coverUrl, 'https://example.com/channel_cover.jpg');
    });

    test('round-trip toJson produces snake_case keys', () {
      final item = VideoSummary(
        vid: 1,
        uid: 123,
        title: 'title',
        time: '2023-01-01',
        likeCount: 10,
        favoriteCount: 5,
        viewCount: 100,
        duration: 60,
        coverUrl: 'https://example.com/c.jpg',
        username: 'user',
      );

      final json = item.toJson();

      expect(json['vid'], 1);
      expect(json['uid'], 123);
      expect(json.containsKey('like_count'), isTrue);
      expect(json.containsKey('likeCount'), isFalse);
    });
  });
}

