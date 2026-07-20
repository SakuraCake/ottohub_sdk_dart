import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/src/models/following/follow_toggle_response.dart';
import 'package:ottohub_sdk_dart/src/models/following/follow_status_response.dart';

void main() {
  group('FollowToggleResponse', () {
    test('parses root-level follow toggle response', () {
      final json = {
        'status': 'success',
        'new_fans_count': 15,
        'follow_status': 2,
      };

      final resp = FollowToggleResponse.fromJson(json);

      expect(resp.newFansCount, 15);
      expect(resp.followStatus, 2);
    });

    test('round-trip toJson', () {
      final resp = FollowToggleResponse(
        newFansCount: 15,
        followStatus: 2,
      );

      final json = resp.toJson();

      expect(json['new_fans_count'], 15);
      expect(json['follow_status'], 2);
    });
  });

  group('FollowStatusResponse', () {
    test('parses root-level status response', () {
      final json = {
        'status': 'success',
        'follow_status': 3,
      };

      final resp = FollowStatusResponse.fromJson(json);

      expect(resp.followStatus, 3);
    });

    test('round-trip toJson', () {
      final resp = FollowStatusResponse(followStatus: 0);

      final json = resp.toJson();

      expect(json['follow_status'], 0);
    });
  });
}

