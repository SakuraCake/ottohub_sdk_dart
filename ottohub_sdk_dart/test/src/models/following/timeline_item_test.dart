import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/src/models/following/timeline_item.dart';

void main() {
  group('TimelineItem', () {
    test('parses video-type timeline item', () {
      final json = {
        'content_type': 'video',
        'vid': 789,
        'uid': 123,
        'title': '视频标题',
        'time': '2023-01-01 12:00:00',
        'like_count': 100,
        'favorite_count': 50,
        'view_count': 1000,
        'cover_url': 'https://example.com/cover.jpg',
        'username': 'user123',
        'avatar_url': 'https://example.com/avatar.jpg',
      };

      final item = TimelineItem.fromJson(json);

      expect(item.contentType, 'video');
      expect(item.vid, 789);
      expect(item.uid, 123);
      expect(item.title, '视频标题');
      expect(item.likeCount, 100);
      expect(item.coverUrl, 'https://example.com/cover.jpg');
      expect(item.username, 'user123');
    });

    test('parses blog-type timeline item', () {
      final json = {
        'content_type': 'blog',
        'bid': 456,
        'uid': 789,
        'title': '动态标题',
        'content': '动态内容',
        'time': '2023-01-01 11:30:00',
        'like_count': 50,
        'favorite_count': 20,
        'view_count': 500,
        'username': 'user789',
        'avatar_url': 'https://example.com/avatar2.jpg',
        'thumbnails': ['https://example.com/thumb1.jpg'],
      };

      final item = TimelineItem.fromJson(json);

      expect(item.contentType, 'blog');
      expect(item.bid, 456);
      expect(item.content, '动态内容');
      expect(item.thumbnails, ['https://example.com/thumb1.jpg']);
      expect(item.coverUrl, isNull);
    });

    test('round-trip toJson uses snake_case', () {
      final item = TimelineItem(
        contentType: 'video',
        vid: 789,
        uid: 123,
        title: 't',
        time: '2023-01-01',
        likeCount: 10,
        favoriteCount: 5,
        viewCount: 100,
        coverUrl: 'https://example.com/c.jpg',
        username: 'user',
        avatarUrl: 'https://example.com/a.jpg',
      );

      final json = item.toJson();

      expect(json['content_type'], 'video');
      expect(json['like_count'], 10);
      expect(json.containsKey('contentType'), isFalse);
    });
  });
}

