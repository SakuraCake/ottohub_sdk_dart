import 'package:json_annotation/json_annotation.dart';

part 'old_im_models.g.dart';

/// IM 新消息数。
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class IMNewMessageNum {
  final int newMessageNum;

  const IMNewMessageNum({required this.newMessageNum});

  factory IMNewMessageNum.fromJson(Map<String, dynamic> json) =>
      _$IMNewMessageNumFromJson(json);

  Map<String, dynamic> toJson() => _$IMNewMessageNumToJson(this);
}

/// IM 私信消息。
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class IMMessage {
  final int msgId;
  final int sender;
  final int receiver;
  final String content;
  final String time;
  final String? senderName;
  final String? receiverName;
  final String? senderAvatarUrl;
  final String? receiverAvatarUrl;
  final int? isRead;

  const IMMessage({
    required this.msgId,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.time,
    this.senderName,
    this.receiverName,
    this.senderAvatarUrl,
    this.receiverAvatarUrl,
    this.isRead,
  });

  factory IMMessage.fromJson(Map<String, dynamic> json) =>
      _$IMMessageFromJson(json);

  Map<String, dynamic> toJson() => _$IMMessageToJson(this);
}

/// IM 好友（私信联系人）。
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class IMFriend {
  final int uid;
  final String username;
  final String? intro;
  final String? avatarUrl;
  final String? lastTime;
  final String? lastMessage;
  final int? newMessageNum;

  const IMFriend({
    required this.uid,
    required this.username,
    this.intro,
    this.avatarUrl,
    this.lastTime,
    this.lastMessage,
    this.newMessageNum,
  });

  factory IMFriend.fromJson(Map<String, dynamic> json) =>
      _$IMFriendFromJson(json);

  Map<String, dynamic> toJson() => _$IMFriendToJson(this);
}

/// IM 已读消息标记请求体。
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class IMReadMessage {
  final int sender;
  final int receiver;
  final String content;
  final String? senderName;
  final String? receiverName;

  const IMReadMessage({
    required this.sender,
    required this.receiver,
    required this.content,
    this.senderName,
    this.receiverName,
  });

  factory IMReadMessage.fromJson(Map<String, dynamic> json) =>
      _$IMReadMessageFromJson(json);

  Map<String, dynamic> toJson() => _$IMReadMessageToJson(this);
}

/// 评论通知 / 提及通知条目(2026-09 /im/comment-replies、/im/mentions)。
///
/// 字段与站点前端解析对齐;`kind` 仅评论通知有(1=评论 2=回复),
/// `excerpt`/`contextType` 仅提及通知有。
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class IMNoticeItem {
  /// 通知编号(评论通知为 rid;提及通知场景下与 mid 对应,可为空)。
  final int? rid;

  /// 发送者 UID(评论通知为 sender_uid;提及通知为 mid)。
  final int? senderUid;
  final int? mid;
  final String? senderUsername;
  final String? senderAvatarUrl;

  /// 时间字符串(如 "2026-09-17 23:58:05")。
  final String? time;

  /// 是否已读(0/1)。
  final int? isRead;

  /// 内容类型(1=视频 2=博客)。
  final int? contentType;

  /// 被通知的内容 ID(视频 vid / 博客 bid)。
  final int? contentId;
  final String? contentTitle;

  /// 通知正文(评论通知为评论内容;提及通知为 excerpt/content)。
  final String? content;

  /// 评论通知类型(1=评论 2=回复),仅评论通知。
  final int? kind;

  /// 提及上下文,仅提及通知。
  final String? excerpt;
  final int? contextType;

  const IMNoticeItem({
    this.rid,
    this.senderUid,
    this.mid,
    this.senderUsername,
    this.senderAvatarUrl,
    this.time,
    this.isRead,
    this.contentType,
    this.contentId,
    this.contentTitle,
    this.content,
    this.kind,
    this.excerpt,
    this.contextType,
  });

  factory IMNoticeItem.fromJson(Map<String, dynamic> json) =>
      _$IMNoticeItemFromJson(json);

  Map<String, dynamic> toJson() => _$IMNoticeItemToJson(this);
}
