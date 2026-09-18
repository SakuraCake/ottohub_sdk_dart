import '../base_api.dart';
import '../utils/rest_compat.dart';
import '../models/old_api/old_blog_models.dart';

/// 旧版博客模块接口。
abstract class IOldBlogApi {
  /// 获取随机博客列表。
  Future<List<BlogSummary>> getRandomBlogList({int? num});

  /// 获取最新博客列表。
  Future<List<BlogSummary>> getNewBlogList({int? offset, int? num});

  /// 获取热门博客列表。
  Future<List<BlogSummary>> getPopularBlogList({int? timeLimit, int? offset, int? num});

  /// 搜索博客。
  Future<List<BlogSummary>> searchBlogList({required String searchTerm, int? num});

  /// 根据博客 ID 获取博客。
  Future<List<BlogSummary>> getBlogById(int bid);

  /// 获取指定用户的博客列表。
  Future<List<BlogSummary>> getUserBlogList({required int uid, int? offset, int? num});

  /// 获取待审核的博客列表。
  Future<List<BlogAuditItem>> getAuditBlogList({int? offset, int? num});

  /// 获取博客详情。
  Future<BlogDetail> getBlogDetail(int bid);

  /// 获取相关博客列表。
  Future<List<BlogSummary>> getRelatedBlogList({required int bid, int? num, int? offset});
}

/// 新 REST 博客响应的数值字段为字符串,归一化后交给生成模型。
BlogSummary _blogFromJson(Map<String, dynamic> e) => BlogSummary.fromJson(
      coerceStringInts(e, const [
        'bid',
        'uid',
        'like_count',
        'favorite_count',
        'view_count',
        'comment_count',
      ]),
    );

class OldBlogApi extends BaseApi implements IOldBlogApi {
  OldBlogApi(super.dio, super.getToken, {super.config});

  @override
  Future<List<BlogSummary>> getRandomBlogList({int? num}) async {
    final response = await get('/blog/random', queryParameters: {'num': ?num});
    return topLevelListOf(response, 'blog_list')
        .map(_blogFromJson)
        .toList();
  }

  @override
  Future<List<BlogSummary>> getNewBlogList({int? offset, int? num}) async {
    final response = await get('/blog/latest', queryParameters: {
      'offset': offset ?? 0,
      'num': ?num,
    });
    return topLevelListOf(response, 'blog_list')
        .map(_blogFromJson)
        .toList();
  }

  @override
  Future<List<BlogSummary>> getPopularBlogList({
    int? timeLimit,
    int? offset,
    int? num,
  }) async {
    final response = await get('/blog/popular', queryParameters: {
      'time_limit': ?timeLimit,
      'offset': offset ?? 0,
      'num': ?num,
    });
    return topLevelListOf(response, 'blog_list')
        .map(_blogFromJson)
        .toList();
  }

  @override
  Future<List<BlogSummary>> searchBlogList({
    required String searchTerm,
    int? num,
  }) async {
    final response = await get('/blog/search_blog_list', queryParameters: {
      'search_term': searchTerm,
      'num': ?num,
    });
    final list =
        (response['data'] as Map<String, dynamic>)['blog_list'] as List<dynamic>;
    return list.map((e) => BlogSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<BlogSummary>> getBlogById(int bid) async {
    final response = await get('/blog/id_blog_list',
        queryParameters: {'bid': bid});
    final list =
        (response['data'] as Map<String, dynamic>)['blog_list'] as List<dynamic>;
    return list.map((e) => BlogSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<BlogSummary>> getUserBlogList({
    required int uid,
    int? offset,
    int? num,
  }) async {
    final response =
        await get('/blog/users/$uid/blogs', queryParameters: {
      'offset': offset ?? 0,
      'num': ?num,
    });
    return topLevelListOf(response, 'blog_list')
        .map(_blogFromJson)
        .toList();
  }

  @override
  Future<List<BlogAuditItem>> getAuditBlogList({int? offset, int? num}) async {
    final response = await get('/blog/audit_blog_list', auth: true, queryParameters: {
      'offset': ?offset,
      'num': ?num,
    });
    final list =
        (response['data'] as Map<String, dynamic>)['blog_list'] as List<dynamic>;
    return list.map((e) => BlogAuditItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<BlogDetail> getBlogDetail(int bid) async {
    // 2026-09 服务端迁移:新路由 /blog/{bid}/detail,字段位于响应顶层。
    final response = await get('/blog/$bid/detail');
    return BlogDetail.fromJson(coerceStringInts(response, const [
      'bid',
      'uid',
      'like_count',
      'favorite_count',
      'view_count',
      'comment_count',
      'if_like',
      'if_favorite',
    ]));
  }

  @override
  Future<List<BlogSummary>> getRelatedBlogList({
    required int bid,
    int? num,
    int? offset,
  }) async {
    final response = await get('/blog/related_blog_list', queryParameters: {
      'bid': bid,
      'num': ?num,
      'offset': ?offset,
    });
    final list =
        (response['data'] as Map<String, dynamic>)['blog_list'] as List<dynamic>;
    return list.map((e) => BlogSummary.fromJson(e as Map<String, dynamic>)).toList();
  }
}
