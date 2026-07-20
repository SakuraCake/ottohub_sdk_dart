import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/src/models/following/following_user.dart';

void main() {
  group('FollowingUser', () {
    test('parses user from list/fans API', () {
      final json = {
        'uid': 123,
        'username': 'user123',
        'intro': '简介',
        'avatar_url': 'https://example.com/avatar.jpg',
        'follow_status': 2,
      };

      final user = FollowingUser.fromJson(json);

      expect(user.uid, 123);
      expect(user.username, 'user123');
      expect(user.intro, '简介');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      expect(user.followStatus, 2);
    });

    test('handles missing follow_status when no token', () {
      final json = {
        'uid': 456,
        'username': 'user456',
        'intro': '简介',
        'avatar_url': 'https://example.com/avatar.jpg',
      };

      final user = FollowingUser.fromJson(json);

      expect(user.uid, 456);
      expect(user.followStatus, isNull);
    });

    test('round-trip toJson uses snake_case', () {
      final user = FollowingUser(
        uid: 123,
        username: 'user',
        intro: 'hi',
        avatarUrl: 'https://example.com/a.jpg',
        followStatus: 4,
      );

      final json = user.toJson();

      expect(json['uid'], 123);
      expect(json['follow_status'], 4);
      expect(json.containsKey('followStatus'), isFalse);
    });
  });
}

