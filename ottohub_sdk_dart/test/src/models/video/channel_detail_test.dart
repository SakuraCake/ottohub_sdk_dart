import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/src/models/video/channel_detail.dart';

void main() {
  group('ChannelDetail', () {
    test('parses manage-list format (int channel_id, description, cover_url)', () {
      final json = {
        'channel_id': 1,
        'channel_name': '频道名称',
        'channel_title': '频道标题',
        'description': '频道描述',
        'cover_url': 'https://example.com/cover.jpg',
      };

      final cd = ChannelDetail.fromJson(json);

      expect(cd.channelId, '1');
      expect(cd.channelName, '频道名称');
      expect(cd.channelTitle, '频道标题');
      expect(cd.description, '频道描述');
      expect(cd.coverUrl, 'https://example.com/cover.jpg');
    });

    test('parses video-detail format (string channel_id, channel_description, channel_cover_url)', () {
      final json = {
        'channel_id': '',
        'channel_name': '',
        'channel_title': '',
        'channel_description': '',
        'channel_cover_url': '',
      };

      final cd = ChannelDetail.fromJson(json);

      expect(cd.channelId, '');
      expect(cd.channelName, '');
      expect(cd.channelTitle, '');
      expect(cd.description, '');
      expect(cd.coverUrl, '');
    });

    test('round-trip toJson uses manage-list naming', () {
      final cd = ChannelDetail(
        channelId: '1',
        channelName: 'name',
        channelTitle: 'title',
        description: 'desc',
        coverUrl: 'https://example.com/c.jpg',
      );

      final json = cd.toJson();

      expect(json['channel_id'], '1');
      expect(json['channel_name'], 'name');
      expect(json['description'], 'desc');
      expect(json['cover_url'], 'https://example.com/c.jpg');
    });
  });
}

