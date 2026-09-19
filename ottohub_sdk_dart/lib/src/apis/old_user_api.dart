import '../base_api.dart';
import '../models/old_api/old_user_models.dart';
import '../models/old_api/old_engagement_models.dart';
import '../exceptions/api_exception.dart';
import '../utils/rest_compat.dart';

/// 旧版用户模块接口。
abstract class IOldUserApi {
  /// 搜索用户。
  Future<List<UserSummary>> searchUsers({required String searchTerm, int? num});

  /// 根据 UID 获取用户信息。
  Future<List<UserSummary>> getUserById(int uid);

  /// 获取用户详情。
  Future<UserDetail> getUserDetail(int uid);
}

class OldUserApi extends BaseApi implements IOldUserApi {
  OldUserApi(super.dio, super.getToken, {super.config});

  @override
  Future<List<UserSummary>> searchUsers({
    required String searchTerm,
    int? num,
  }) async {
    // 2026-09 REST 迁移:/user/search,offset 必填(首页传 0)。
    final response = await get('/user/search', queryParameters: {
      'search_term': searchTerm,
      'offset': 0,
      'num': ?num,
    });
    final list = topLevelListOf(response, 'user_list');
    return list.map(UserSummary.fromJson).toList();
  }

  @override
  Future<List<UserSummary>> getUserById(int uid) async {
    // 2026-09 REST 迁移:旧 /user/id_user_list 已下线,复用 /user/{uid}
    // 详情端点,包装成单元素列表。
    final response = await get('/user/$uid');
    final data = response['data'];
    if (data is! Map<String, dynamic>) return const [];
    return [UserSummary.fromJson(coerceStringInts(data, const ['uid', 'fans_count', 'followings_count']))];
  }

  @override
  Future<UserDetail> getUserDetail(int uid) async {
    // 2026-09 服务端迁移:旧 /user/get_user_detail 已下线,新路由为
    // REST 风格 /user/{uid},数值字段以字符串返回,需归一化。
    final response = await get('/user/$uid');
    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const ApiException('system_error');
    }
    return UserDetail.fromJson(coerceStringInts(data, const [
      'uid',
      'experience',
      'video_num',
      'blog_num',
      'seiga_num',
      'media_num',
      'followings_count',
      'fans_count',
      'total_view_count',
      'total_like_count',
    ]));
  }
}

/// 旧版互动模块接口。
///
/// 提供博客/视频的点赞、收藏切换功能。
abstract class IOldEngagementApi {
  /// 点赞/取消点赞博客。
  Future<OldLikeToggleResponse> likeBlog(int bid);

  /// 收藏/取消收藏博客。
  Future<OldFavoriteToggleResponse> favoriteBlog(int bid);

  /// 点赞/取消点赞视频。
  Future<OldLikeToggleResponse> likeVideo(int vid);

  /// 收藏/取消收藏视频。
  Future<OldFavoriteToggleResponse> favoriteVideo(int vid);
}

class OldEngagementApi extends BaseApi implements IOldEngagementApi {
  OldEngagementApi(super.dio, super.getToken, {super.config});

  @override
  Future<OldLikeToggleResponse> likeBlog(int bid) async {
    final response = await post('/engagement/like_blog', auth: true, data: {'bid': bid});
    return OldLikeToggleResponse.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<OldFavoriteToggleResponse> favoriteBlog(int bid) async {
    final response =
        await post('/engagement/favorite_blog', auth: true, data: {'bid': bid});
    return OldFavoriteToggleResponse.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<OldLikeToggleResponse> likeVideo(int vid) async {
    final response = await post('/engagement/like_video', auth: true, data: {'vid': vid});
    return OldLikeToggleResponse.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<OldFavoriteToggleResponse> favoriteVideo(int vid) async {
    final response =
        await post('/engagement/favorite_video', auth: true, data: {'vid': vid});
    return OldFavoriteToggleResponse.fromJson(response['data'] as Map<String, dynamic>);
  }
}
