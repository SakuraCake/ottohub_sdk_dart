import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/src/models/block/block_record.dart';

void main() {
  group('BlockRecord', () {
    test('parses block-list item (with blocked_id)', () {
      final json = {
        'block_id': 1234567890,
        'blocked_id': 123,
        'username': 'user123',
        'avatar': 'https://example.com/avatar.jpg',
        'reason': '骚扰行为',
        'reason_visible': 1,
        'created_at': '2026-03-02 12:00:00',
      };

      final record = BlockRecord.fromJson(json);

      expect(record.blockId, 1234567890);
      expect(record.blockedId, 123);
      expect(record.blockerId, isNull);
      expect(record.username, 'user123');
      expect(record.avatar, 'https://example.com/avatar.jpg');
      expect(record.reason, '骚扰行为');
      expect(record.reasonVisible, 1);
      expect(record.createdAt, '2026-03-02 12:00:00');
    });

    test('parses blocked-by-list item (with blocker_id)', () {
      final json = {
        'block_id': 1234567891,
        'blocker_id': 456,
        'username': 'user456',
        'avatar': 'https://example.com/avatar2.jpg',
        'reason': '',
        'reason_visible': 0,
        'created_at': '2026-03-01 10:00:00',
      };

      final record = BlockRecord.fromJson(json);

      expect(record.blockId, 1234567891);
      expect(record.blockerId, 456);
      expect(record.blockedId, isNull);
      expect(record.reason, '');
      expect(record.reasonVisible, 0);
    });

    test('round-trip toJson uses snake_case', () {
      final record = BlockRecord(
        blockId: 1,
        blockedId: 123,
        username: 'u',
        avatar: 'https://a.jpg',
        createdAt: '2026-01-01',
      );

      final json = record.toJson();

      expect(json['block_id'], 1);
      expect(json['blocked_id'], 123);
      expect(json.containsKey('blockId'), isFalse);
    });
  });
}

