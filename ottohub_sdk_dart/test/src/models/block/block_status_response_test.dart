import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/src/models/block/block_status_response.dart';

void main() {
  group('BlockStatusResponse', () {
    test('parses block status response', () {
      final json = {
        'data': {
          'target_user_id': 123,
          'i_blocked': true,
          'he_blocked': false,
          'mutual_block': false,
          'any_block': true,
          'my_reason': '骚扰行为',
          'his_reason': '',
          'his_reason_visible': false,
        },
      };

      final resp = BlockStatusResponse.fromJson(json['data'] as Map<String, dynamic>);

      expect(resp.targetUserId, 123);
      expect(resp.iBlocked, isTrue);
      expect(resp.heBlocked, isFalse);
      expect(resp.mutualBlock, isFalse);
      expect(resp.anyBlock, isTrue);
      expect(resp.myReason, '骚扰行为');
      expect(resp.hisReason, '');
      expect(resp.hisReasonVisible, isFalse);
    });

    test('round-trip toJson uses snake_case', () {
      final resp = BlockStatusResponse(
        targetUserId: 1,
        iBlocked: true,
        heBlocked: false,
        mutualBlock: false,
        anyBlock: true,
      );

      final json = resp.toJson();

      expect(json['target_user_id'], 1);
      expect(json['i_blocked'], isTrue);
      expect(json.containsKey('iBlocked'), isFalse);
    });
  });
}

