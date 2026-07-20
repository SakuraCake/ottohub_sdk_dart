import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/src/models/block/block_list_data.dart';

void main() {
  group('BlockListData', () {
    test('parses paginated block list response', () {
      final json = {
        'list': [
          {
            'block_id': 1,
            'blocked_id': 123,
            'username': 'u1',
            'avatar': 'https://a.jpg',
            'created_at': '2026-01-01',
          },
        ],
        'total': 5,
        'page': 1,
        'page_size': 20,
        'total_pages': 1,
      };

      final data = BlockListData.fromJson(json);

      expect(data.list.length, 1);
      expect(data.total, 5);
      expect(data.page, 1);
      expect(data.pageSize, 20);
      expect(data.totalPages, 1);
    });

    test('handles empty list', () {
      final json = {
        'list': [],
        'total': 0,
        'page': 1,
        'page_size': 20,
        'total_pages': 0,
      };

      final data = BlockListData.fromJson(json);

      expect(data.list, isEmpty);
      expect(data.total, 0);
    });
  });
}

