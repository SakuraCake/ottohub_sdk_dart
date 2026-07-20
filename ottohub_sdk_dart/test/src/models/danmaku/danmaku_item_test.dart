import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/src/models/danmaku/danmaku_item.dart';

void main() {
  group('DanmakuItem', () {
    test('parses danmaku from API response', () {
      final json = {
        'danmaku_id': 1,
        'text': '这是一条滚幕',
        'time': 10.5,
        'mode': 'scroll',
        'color': '#ffffff',
        'font_size': '25px',
        'render': '',
      };

      final item = DanmakuItem.fromJson(json);

      expect(item.danmakuId, 1);
      expect(item.text, '这是一条滚幕');
      expect(item.time, 10.5);
      expect(item.mode, 'scroll');
      expect(item.color, '#ffffff');
      expect(item.fontSize, '25px');
      expect(item.render, '');
    });

    test('round-trip toJson uses snake_case', () {
      final item = DanmakuItem(
        danmakuId: 1,
        text: 'hello',
        time: 5.0,
        mode: 'top',
        color: 'ffffff',
        fontSize: '20px',
        render: '',
      );

      final json = item.toJson();

      expect(json['danmaku_id'], 1);
      expect(json['font_size'], '20px');
      expect(json.containsKey('fontSize'), isFalse);
    });
  });
}

