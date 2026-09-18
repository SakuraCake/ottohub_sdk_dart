import '../base_api.dart';
import '../models/old_api/old_comment_models.dart';

/// 旧版评论模块接口。
abstract class IOldCommentApi {
  /// 获取博客评论列表。
  Future<List<BlogComment>> getBlogCommentList({required int bid, int? parentBcid, int? offset, int? num, int? cidAsc});

  /// 获取视频评论列表。
  Future<List<VideoComment>> getVideoCommentList({required int vid, int? parentVcid, int? offset, int? num, int? cidAsc});

  /// 评论博客。
  Future<CommentResult> commentBlog({required int bid, required int parentBcid, required String content});

  /// 评论视频。
  Future<CommentResult> commentVideo({required int vid, required int parentVcid, required String content});

  /// 删除博客评论。
  Future<void> deleteBlogComment(int bcid);

  /// 删除视频评论。
  Future<void> deleteVideoComment(int vcid);

  /// 举报博客评论。
  Future<void> reportBlogComment(int bcid, {required String reason});

  /// 举报视频评论。
  Future<void> reportVideoComment(int vcid, {required String reason});

  /// 获取待审核博客评论列表。
  Future<List<AuditBlogComment>> getAuditBlogCommentList({int? offset, int? num});

  /// 获取待审核视频评论列表。
  Future<List<AuditVideoComment>> getAuditVideoCommentList({int? offset, int? num});

  /// 审批通过博客评论。
  Future<void> approveBlogComment(int bcid);

  /// 审批通过视频评论。
  Future<void> approveVideoComment(int vcid);

  /// 驳回博客评论。
  Future<void> rejectBlogComment(int bcid, {required String reason});

  /// 驳回视频评论。
  Future<void> rejectVideoComment(int vcid, {required String reason});
}

class OldCommentApi extends BaseApi implements IOldCommentApi {
  OldCommentApi(super.dio, super.getToken, {super.config});

  /// 评论列表/发布接口已由服务端迁移为 REST 风格(2026-09 验证:
  /// 旧 /comment/video_comment_list 等路由返回 nginx 404),本类按
  /// ottohub.cn 站点前端实际调用的路由对齐。列表项的 id 类字段新端点
  /// 返回字符串,[normalizeComment] 统一回 int 以匹配生成模型。

  /// 字符串形态的 id/count 字段 → int(模型为 int)。
  static Map<String, dynamic> normalizeComment(Map<String, dynamic> e) =>
      <String, dynamic>{
        ...e,
        for (final key in const [
          'bcid',
          'vcid',
          'parent_bcid',
          'parent_vcid',
          'uid',
          'child_comment_num',
          'if_my_comment',
          'is_pinned',
          'pin_order',
        ])
          if (e[key] is String) key: int.tryParse(e[key] as String) ?? 0,
      };

  static List<Map<String, dynamic>> _commentListOf(
    Map<String, dynamic> response,
  ) {
    final data = response['data'];
    if (data is! Map<String, dynamic>) return const [];
    final list = data['comment_list'];
    if (list is! List<dynamic>) return const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(normalizeComment)
        .toList();
  }

  static Map<String, dynamic> _resultOf(Map<String, dynamic> response) {
    final data = response['data'];
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  @override
  Future<List<BlogComment>> getBlogCommentList({
    required int bid,
    int? parentBcid,
    int? offset,
    int? num,
    int? cidAsc,
  }) async {
    final response = await get('/comment/blogs/$bid', queryParameters: {
      'parent_bcid': parentBcid ?? 0,
      // 服务端必填,首页传 0。
      'offset': offset ?? 0,
      'num': ?num,
      'cid_asc': ?cidAsc,
    });
    return _commentListOf(response).map(BlogComment.fromJson).toList();
  }

  @override
  Future<List<VideoComment>> getVideoCommentList({
    required int vid,
    int? parentVcid,
    int? offset,
    int? num,
    int? cidAsc,
  }) async {
    final response = await get('/comment/videos/$vid', queryParameters: {
      // 服务端必填,根评论传 0。
      'parent_vcid': parentVcid ?? 0,
      // 服务端必填,首页传 0。
      'offset': offset ?? 0,
      'num': ?num,
      'cid_asc': ?cidAsc,
    });
    return _commentListOf(response).map(VideoComment.fromJson).toList();
  }

  @override
  Future<CommentResult> commentBlog({
    required int bid,
    required int parentBcid,
    required String content,
  }) async {
    final response = await post('/comment/blogs/$bid', auth: true, data: {
      'parent_bcid': parentBcid,
      'content': content,
    });
    return CommentResult.fromJson(_resultOf(response));
  }

  @override
  Future<CommentResult> commentVideo({
    required int vid,
    required int parentVcid,
    required String content,
  }) async {
    final response = await post('/comment/videos/$vid', auth: true, data: {
      'parent_vcid': parentVcid,
      'content': content,
    });
    return CommentResult.fromJson(_resultOf(response));
  }

  @override
  Future<void> deleteBlogComment(int bcid) async {
    await delete('/comment/blog-comments/$bcid', auth: true);
  }

  @override
  Future<void> deleteVideoComment(int vcid) async {
    await delete('/comment/video-comments/$vcid', auth: true);
  }

  @override
  Future<void> reportBlogComment(int bcid, {required String reason}) async {
    await post('/comment/report_blog_comment', auth: true,
        data: {'bcid': bcid, 'reason': reason});
  }

  @override
  Future<void> reportVideoComment(int vcid, {required String reason}) async {
    await post('/comment/report_video_comment', auth: true,
        data: {'vcid': vcid, 'reason': reason});
  }

  @override
  Future<List<AuditBlogComment>> getAuditBlogCommentList({
    int? offset,
    int? num,
  }) async {
    final response = await get('/comment/audit_blog_comment_list', auth: true,
        queryParameters: {
          'offset': ?offset,
          'num': ?num,
        });
    final list = (response['data'] as Map<String, dynamic>)['comment_list']
        as List<dynamic>;
    return list
        .map((e) => AuditBlogComment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<AuditVideoComment>> getAuditVideoCommentList({
    int? offset,
    int? num,
  }) async {
    final response = await get('/comment/audit_video_comment_list', auth: true,
        queryParameters: {
          'offset': ?offset,
          'num': ?num,
        });
    final list = (response['data'] as Map<String, dynamic>)['comment_list']
        as List<dynamic>;
    return list
        .map((e) => AuditVideoComment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> approveBlogComment(int bcid) async {
    await put('/comment/approve_blog_comment', auth: true, data: {'bcid': bcid});
  }

  @override
  Future<void> approveVideoComment(int vcid) async {
    await put('/comment/approve_video_comment', auth: true, data: {'vcid': vcid});
  }

  @override
  Future<void> rejectBlogComment(int bcid, {required String reason}) async {
    await put('/comment/reject_blog_comment', auth: true,
        data: {'bcid': bcid, 'reason': reason});
  }

  @override
  Future<void> rejectVideoComment(int vcid, {required String reason}) async {
    await put('/comment/reject_video_comment', auth: true,
        data: {'vcid': vcid, 'reason': reason});
  }
}
