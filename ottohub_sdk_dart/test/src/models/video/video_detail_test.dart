import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/src/models/video/video_detail.dart';

void main() {
  group('VideoDetail', () {
    test('parses full video detail from API', () {
      final json = {
        'status': 'success',
        'data': {
          'vid': '1',
          'uid': '1',
          'title': '视频标题',
          'intro': '视频简介',
          'type': '3',
          'category': '3',
          'tag': '#标签1#标签2',
          'time': '2023-01-01 00:00:00',
          'like_count': '100',
          'favorite_count': '50',
          'view_count': '1000',
          'cover_url': 'https://example.com/cover.jpg',
          'video_url': 'https://example.com/video.mp4',
          'audio_url': 'https://example.com/audio.mp3',
          'username': '用户昵称',
          'userintro': '用户个性签名',
          'avatar_url': 'https://example.com/avatar.jpg',
          'if_like': 0,
          'if_favorite': 0,
          'video_width': '1440',
          'video_height': '1080',
          'video_sar': '0:1',
          'video_dar': '0:1',
          'duration': '223',
          'comment_count': '5',
          'video_m3u8_url': '',
          'channel_id': 0,
          'channel_detail': {
            'channel_id': '',
            'channel_name': '',
            'channel_title': '',
            'channel_description': '',
            'channel_cover_url': '',
          },
          'last_watch_second': -1,
        },
      };

      final detail = VideoDetail.fromJson(json['data'] as Map<String, dynamic>);

      expect(detail.vid, '1');
      expect(detail.uid, '1');
      expect(detail.title, '视频标题');
      expect(detail.intro, '视频简介');
      expect(detail.tag, '#标签1#标签2');
      expect(detail.ifLike, 0);
      expect(detail.ifFavorite, 0);
      expect(detail.duration, 223);
      expect(detail.lastWatchSecond, -1);

      expect(detail.channelDetail, isNotNull);
      expect(detail.channelDetail!.channelId, '');
    });

    test('handles last_watch_second as -1 (watched)', () {
      final json = {
        'vid': '1',
        'uid': '1',
        'title': 't',
        'time': '2023-01-01',
        'like_count': '0',
        'favorite_count': '0',
        'view_count': '0',
        'cover_url': '',
        'username': 'u',
        'if_like': 0,
        'if_favorite': 0,
        'last_watch_second': -1,
        'duration': '100',
      };

      final detail = VideoDetail.fromJson(json);
      expect(detail.lastWatchSecond, -1);
    });

    test('handles positive last_watch_second', () {
      final json = {
        'vid': '1',
        'uid': '1',
        'title': 't',
        'time': '2023-01-01',
        'like_count': '0',
        'favorite_count': '0',
        'view_count': '0',
        'cover_url': '',
        'username': 'u',
        'if_like': 0,
        'if_favorite': 0,
        'last_watch_second': 65,
        'duration': '100',
      };

      final detail = VideoDetail.fromJson(json);
      expect(detail.lastWatchSecond, 65);
    });

    test('round-trip toJson preserves snake_case', () {
      final detail = VideoDetail(
        vid: '1',
        uid: '1',
        title: 't',
        time: '2023-01-01',
        likeCount: 0,
        favoriteCount: 0,
        viewCount: 0,
        coverUrl: '',
        username: 'u',
        ifLike: 0,
        ifFavorite: 0,
        lastWatchSecond: -1,
        duration: 100,
      );

      final json = detail.toJson();

      expect(json['vid'], '1');
      expect(json.containsKey('last_watch_second'), isTrue);
      expect(json.containsKey('lastWatchSecond'), isFalse);
    });
  });
}

