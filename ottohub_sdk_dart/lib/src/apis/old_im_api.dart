import '../base_api.dart';
import '../models/old_api/old_im_models.dart';

/// 旧版 IM 消息模块接口。
abstract class IOldImApi {
  /// 获取新消息数量。
  Future<IMNewMessageNum> getNewMessageNum();

  /// 获取已读消息列表。
  Future<List<IMMessage>> getReadMessageList({int? offset, int? num});

  /// 获取未读消息列表。
  Future<List<IMMessage>> getUnreadMessageList({int? offset, int? num});

  /// 获取已发送消息列表。
  Future<List<IMMessage>> getSentMessageList({int? offset, int? num});

  /// 发送消息。
  Future<void> sendMessage({required int receiver, required String message});

  /// 将消息标记为已读。
  Future<IMReadMessage> readMessage(int msgId);

  /// 一键已读全部系统消息。
  Future<void> readAllSystemMessage();

  /// 删除消息。
  Future<void> deleteMessage(int msgId);

  /// 评论/回复通知列表(2026-09 新端点)。
  ///
  /// [kind]: 1=评论 2=回复;[contentType]: 1=视频 2=博客(过滤用,可空)。
  Future<List<IMNoticeItem>> getCommentReplies({
    required int offset,
    int num = 20,
    int? kind,
    int? contentType,
  });

  /// 提及(@)通知列表(2026-09 新端点)。
  Future<List<IMNoticeItem>> getMentions({
    required int offset,
    int num = 20,
    int? contentType,
  });

  /// 获取好友列表。
  Future<List<IMFriend>> getFriendList({int? offset, int? num, int? ifTimeDesc});

  /// 获取好友消息列表。
  Future<List<IMMessage>> getFriendMessages({required int friendUid, int? offset, int? num, int? ifTimeDesc});
}

class OldImApi extends BaseApi implements IOldImApi {
  OldImApi(super.dio, super.getToken, {super.config});

  static Map<String, dynamic> _noticeFromRaw(Map<String, dynamic> e) =>
      <String, dynamic>{
        'rid': e['rid'],
        'sender_uid': e['sender_uid'],
        'sender_username': e['sender_username'],
        'sender_avatar_url': e['sender_avatar_url'],
        'time': e['time'],
        'is_read': e['is_read'],
        'content_type': e['content_type'],
        'content_id': e['content_id'],
        'content_title': e['content_title'],
        'content': e['content'],
        if (e['kind'] != null) 'kind': e['kind'],
        if (e['excerpt'] != null) 'excerpt': e['excerpt'],
        if (e['context_type'] != null) 'context_type': e['context_type'],
      };

  static List<IMNoticeItem> _noticeListOf(Map<String, dynamic> response) {
    final list = response['message_list'];
    if (list is! List<dynamic>) return const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(_noticeFromRaw)
        .map(IMNoticeItem.fromJson)
        .toList();
  }

  @override
  Future<List<IMNoticeItem>> getCommentReplies({
    required int offset,
    int num = 20,
    int? kind,
    int? contentType,
  }) async {
    final response = await get('/im/comment-replies', auth: true, queryParameters: {
      'offset': offset,
      'num': num,
      'kind': ?kind,
      'content_type': ?contentType,
    });
    return _noticeListOf(response);
  }

  @override
  Future<List<IMNoticeItem>> getMentions({
    required int offset,
    int num = 20,
    int? contentType,
  }) async {
    final response = await get('/im/mentions', auth: true, queryParameters: {
      'offset': offset,
      'num': num,
      'content_type': ?contentType,
    });
    return _noticeListOf(response);
  }

  @override
  Future<IMNewMessageNum> getNewMessageNum() async {
    final response = await get('/im/new_message_num', auth: true);
    return IMNewMessageNum.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<IMMessage>> getReadMessageList({int? offset, int? num}) async {
    final response = await get('/im/read_message_list', auth: true, queryParameters: {
      'offset': ?offset,
      'num': ?num,
    });
    final list = (response['data'] as Map<String, dynamic>)['read_message_list']
        as List<dynamic>;
    return list.map((e) => IMMessage.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<IMMessage>> getUnreadMessageList({int? offset, int? num}) async {
    final response = await get('/im/unread_message_list', auth: true, queryParameters: {
      'offset': ?offset,
      'num': ?num,
    });
    final list =
        (response['data'] as Map<String, dynamic>)['unread_message_list']
            as List<dynamic>;
    return list.map((e) => IMMessage.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<IMMessage>> getSentMessageList({int? offset, int? num}) async {
    final response = await get('/im/sent_message_list', auth: true, queryParameters: {
      'offset': ?offset,
      'num': ?num,
    });
    final list = (response['data'] as Map<String, dynamic>)['sent_message_list']
        as List<dynamic>;
    return list.map((e) => IMMessage.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> sendMessage({
    required int receiver,
    required String message,
  }) async {
    await post('/im/send_message', auth: true, data: {
      'receiver': receiver,
      'message': message,
    });
  }

  @override
  Future<IMReadMessage> readMessage(int msgId) async {
    final response =
        await post('/im/read_message', auth: true, data: {'msg_id': msgId});
    return IMReadMessage.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> readAllSystemMessage() async {
    await post('/im/read_all_system_message', auth: true);
  }

  @override
  Future<void> deleteMessage(int msgId) async {
    await post('/im/delete_message', auth: true, data: {'msg_id': msgId});
  }

  @override
  Future<List<IMFriend>> getFriendList({
    int? offset,
    int? num,
    int? ifTimeDesc,
  }) async {
    final response = await get('/im/friend_list', auth: true, queryParameters: {
      'offset': ?offset,
      'num': ?num,
      'if_time_desc': ?ifTimeDesc,
    });
    final list =
        (response['data'] as Map<String, dynamic>)['user_list'] as List<dynamic>;
    return list.map((e) => IMFriend.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<IMMessage>> getFriendMessages({
    required int friendUid,
    int? offset,
    int? num,
    int? ifTimeDesc,
  }) async {
    final response = await get('/im/friend_message', auth: true, queryParameters: {
      'friend_uid': friendUid,
      'offset': ?offset,
      'num': ?num,
      'if_time_desc': ?ifTimeDesc,
    });
    final list = (response['data'] as Map<String, dynamic>)['message_list']
        as List<dynamic>;
    return list.map((e) => IMMessage.fromJson(e as Map<String, dynamic>)).toList();
  }
}
