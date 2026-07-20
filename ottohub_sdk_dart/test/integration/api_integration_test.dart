import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/ottohub_sdk_dart.dart';

void main() {
  late OttohubClient client;

  setUp(() {
    client = OttohubClient();
  });

  group('Public video endpoints', () {
    test('GET /api/video/random returns video list', () async {
      final result = await client.video.getRandom(num: 3);
      expect(result.videoList, isNotEmpty);
      expect(result.videoList.length, lessThanOrEqualTo(3));
      expect(result.videoList[0].vid, isA<int>());
      expect(result.videoList[0].title, isA<String>());
      expect(result.videoList[0].username, isA<String>());
    });

    test('GET /api/video/new returns recent videos', () async {
      final result = await client.video.getNew(offset: 0, num: 5);
      expect(result.videoList, isNotEmpty);
      expect(result.videoList.length, lessThanOrEqualTo(5));
    });

    test('GET /api/video/popular returns popular videos', () async {
      final result = await client.video.getPopular(timeLimit: 7, num: 3);
      expect(result.videoList, isNotEmpty);
    });

    test('GET /api/video/category/{cat} returns categorized videos', () async {
      final result = await client.video.getCategory('0', num: 2);
      expect(result.videoList, isNotEmpty);
    });

    test('GET /api/video/search returns search results', () async {
      final result = await client.video.search(searchTerm: 'test', num: 5);
      expect(result.videoList, isNotEmpty);
      expect(result.totalCount, isA<int>());
    });

    test('GET /api/video/{vid} returns video detail', () async {
      final random = await client.video.getRandom(num: 1);
      final validVid = random.videoList[0].vid;

      final detail = await client.video.getDetail(validVid);
      expect(detail.vid, isA<String>());
      expect(detail.title, isA<String>());
      expect(detail.username, isA<String>());
    });
  });
}

