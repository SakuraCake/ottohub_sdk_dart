import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/ottohub_sdk_dart.dart';

void main() {
  group('LoginResponse', () {
    test('parses full response from real API', () {
      final json = {
        'uid': '19015',
        'token': 'ZEMr...',
        'avatar_url': 'https://example.com/avatar.jpg',
        'cover_url': 'https://example.com/cover.jpg',
        'if_today_first_login': 'no',
        'email': 'test@qq.com',
        'is_audit': 0,
        'is_admin': 1,
      };

      final resp = LoginResponse.fromJson(json);

      expect(resp.uid, '19015');
      expect(resp.token, 'ZEMr...');
      expect(resp.avatarUrl, 'https://example.com/avatar.jpg');
      expect(resp.coverUrl, 'https://example.com/cover.jpg');
      expect(resp.ifTodayFirstLogin, 'no');
      expect(resp.email, 'test@qq.com');
      expect(resp.isAudit, 0);
      expect(resp.isAdmin, 1);
    });

    test('handles minimal response (only uid + token)', () {
      final json = {
        'uid': '12345',
        'token': 'abc123',
      };

      final resp = LoginResponse.fromJson(json);

      expect(resp.uid, '12345');
      expect(resp.token, 'abc123');
      expect(resp.avatarUrl, isNull);
      expect(resp.coverUrl, isNull);
      expect(resp.ifTodayFirstLogin, isNull);
      expect(resp.email, isNull);
      expect(resp.isAudit, isNull);
      expect(resp.isAdmin, isNull);
    });

    test('round-trip toJson produces snake_case keys', () {
      final resp = LoginResponse(
        uid: '19015',
        token: 'ZEMr...',
      );

      final json = resp.toJson();

      expect(json['uid'], '19015');
      expect(json['token'], 'ZEMr...');
      expect(json.containsKey('avatar_url'), isTrue);
      expect(json.containsKey('avatarUrl'), isFalse);
    });
  });
}

