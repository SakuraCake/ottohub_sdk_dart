import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/src/models/following/active_follower.dart';

void main() {
  group('ActiveFollower', () {
    test('parses active follower from API', () {
      final json = {
        'uid': 123,
        'username': 'user123',
        'avatar_url': 'https://example.com/avatar.jpg',
        'latest_activity_time': '2023-01-01 12:00:00',
      };

      final af = ActiveFollower.fromJson(json);

      expect(af.uid, 123);
      expect(af.username, 'user123');
      expect(af.avatarUrl, 'https://example.com/avatar.jpg');
      expect(af.latestActivityTime, '2023-01-01 12:00:00');
    });

    test('round-trip toJson uses snake_case', () {
      final af = ActiveFollower(
        uid: 1,
        username: 'u',
        avatarUrl: 'https://example.com/a.jpg',
        latestActivityTime: '2023-01-01',
      );

      final json = af.toJson();

      expect(json['latest_activity_time'], '2023-01-01');
      expect(json.containsKey('latestActivityTime'), isFalse);
    });
  });
}

