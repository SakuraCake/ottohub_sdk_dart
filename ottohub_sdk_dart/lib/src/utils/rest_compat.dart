/// 服务端 REST 迁移兼容工具(2026-09)。
///
/// OttoHub 服务端已把旧版接口(`/blog/new_blog_list`、`/user/get_user_detail`
/// 等)迁移为 REST 路径路由(`/blog/latest`、`/user/{uid}` 等),且数值
/// 字段改为字符串返回。此处的帮助函数负责:
/// - 从响应中按新形状取出列表;
/// - 把字符串形态的数值字段归一化为 int,匹配 json_serializable 模型。
library;

/// 把 [map] 中 [keys] 列出的字符串数值字段归一化为 int(其余键原样保留)。
Map<String, dynamic> coerceStringInts(Map<String, dynamic> map, List<String> keys) =>
    <String, dynamic>{
      ...map,
      for (final key in keys)
        if (map[key] is String) key: int.tryParse(map[key] as String) ?? 0,
    };

/// 从响应中取出名为 [key] 的顶层列表(新 REST 形状:`{status, blog_list: []}`)。
List<Map<String, dynamic>> topLevelListOf(Map<String, dynamic> response, String key) {
  final list = response[key];
  if (list is! List<dynamic>) return const [];
  return list.whereType<Map<String, dynamic>>().toList();
}
