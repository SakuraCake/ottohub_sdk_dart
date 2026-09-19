## 0.0.4

- fix: 用户搜索迁移至 `/user/search`(offset 必填);旧 `/user/select_user_list` 已下线。
- fix: 收藏/历史路由迁移:`/video/favorite-list`、`/blog/favorite-list`、
  `/video/history-list`、`/blog/history-list`(列表位于响应顶层,数值字段为字符串)。
- fix: 用户资料统一至 `/profile`;博客搜索/单查/相关迁移至
  `/blog/search`、`/blog/{bid}`、`/blog/related/{bid}`。
## 0.0.3

- fix: 服务端 2026-09 REST 迁移对齐——评论(`/comment/videos/{vid}` 等)、
  用户(`/user/{uid}`)、博客(`/blog/latest`、`/blog/users/{uid}/blogs`、
  `/blog/{bid}/detail`)路由更新;旧 `*_list`/`get_*_detail` 路由已下线。
- fix: 服务端数值字段以字符串返回,`VideoDetail` 全部 int 字段挂
  StringToIntConverter / StringToNullableIntConverter,消除严格强转崩溃。
- fix: `BlogSummary` 补充 `username` 字段。
- fix: token 注入改为仅 `auth: true` 请求携带(公开接口不再附带 token)。
- chore: 新增 `src/utils/rest_compat.dart` 兼容工具;测试同步更新。

## 0.0.2

- 修复 LICENSE 文件（BSD 3-Clause）

## 0.0.1

- 初始版本
- 核心 HTTP 客户端 (`OttohubClient`)，支持自定义 base URL 和 Dio 注入
- **Auth 模块**：登录、注册、验证码、密码重置
- **Video 模块**：获取视频列表（随机/最新/热门/分类）、搜索、详情、用户视频、收藏/点赞切换、上传/更新/删除视频、观看记录
- **Following 模块**：关注/取关、关注列表、粉丝列表、动态时间线、活跃粉丝
- **Block 模块**：屏蔽/取消屏蔽用户、屏蔽列表、被屏蔽列表、屏蔽状态
- **Danmaku 模块**：获取/发送/删除弹幕
- **Channel 模块**：频道 CRUD、成员管理（审批/踢出/角色/申请列表）、内容管理、关注频道、统计、历史、搜索、黑名单、分区管理、时间线、公告、验证码
- **Moderation 模块**：审核列表（视频/博客/头像/封面/弹幕/评论）、审批/驳回/举报/申诉、审核日志
- **旧版 API 模块**：博客、评论、IM 消息、管理、用户资料、创作者、系统、收藏、用户/互动（约 79 个端点）
- 抽象接口设计：所有模块提供 `I*Api` 接口，支持测试替身
- 完整的响应校验和 `ApiException` 错误处理
