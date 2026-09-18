// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoDetail _$VideoDetailFromJson(Map<String, dynamic> json) => VideoDetail(
  vid: json['vid'] as String,
  uid: json['uid'] as String,
  title: json['title'] as String,
  intro: json['intro'] as String?,
  type: json['type'] as String?,
  category: json['category'] as String?,
  tag: json['tag'] as String?,
  time: json['time'] as String,
  likeCount: const StringToIntConverter().fromJson(json['like_count']),
  favoriteCount: const StringToIntConverter().fromJson(json['favorite_count']),
  viewCount: const StringToIntConverter().fromJson(json['view_count']),
  coverUrl: json['cover_url'] as String,
  videoUrl: json['video_url'] as String?,
  audioUrl: json['audio_url'] as String?,
  username: json['username'] as String,
  userintro: json['userintro'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  ifLike: const StringToIntConverter().fromJson(json['if_like']),
  ifFavorite: const StringToIntConverter().fromJson(json['if_favorite']),
  videoWidth: const StringToNullableIntConverter().fromJson(
    json['video_width'],
  ),
  videoHeight: const StringToNullableIntConverter().fromJson(
    json['video_height'],
  ),
  videoSar: const StringToNullableIntConverter().fromJson(json['video_sar']),
  videoDar: const StringToNullableIntConverter().fromJson(json['video_dar']),
  duration: const StringToIntConverter().fromJson(json['duration']),
  commentCount: const StringToNullableIntConverter().fromJson(
    json['comment_count'],
  ),
  videoM3u8Url: json['video_m3u8_url'] as String?,
  channelId: const StringToNullableIntConverter().fromJson(json['channel_id']),
  channelDetail: json['channel_detail'] == null
      ? null
      : ChannelDetail.fromJson(json['channel_detail'] as Map<String, dynamic>),
  lastWatchSecond: const StringToNullableIntConverter().fromJson(
    json['last_watch_second'],
  ),
);

Map<String, dynamic> _$VideoDetailToJson(
  VideoDetail instance,
) => <String, dynamic>{
  'vid': instance.vid,
  'uid': instance.uid,
  'title': instance.title,
  'intro': instance.intro,
  'type': instance.type,
  'category': instance.category,
  'tag': instance.tag,
  'time': instance.time,
  'like_count': const StringToIntConverter().toJson(instance.likeCount),
  'favorite_count': const StringToIntConverter().toJson(instance.favoriteCount),
  'view_count': const StringToIntConverter().toJson(instance.viewCount),
  'cover_url': instance.coverUrl,
  'video_url': instance.videoUrl,
  'audio_url': instance.audioUrl,
  'username': instance.username,
  'userintro': instance.userintro,
  'avatar_url': instance.avatarUrl,
  'if_like': const StringToIntConverter().toJson(instance.ifLike),
  'if_favorite': const StringToIntConverter().toJson(instance.ifFavorite),
  'video_width': const StringToNullableIntConverter().toJson(
    instance.videoWidth,
  ),
  'video_height': const StringToNullableIntConverter().toJson(
    instance.videoHeight,
  ),
  'video_sar': const StringToNullableIntConverter().toJson(instance.videoSar),
  'video_dar': const StringToNullableIntConverter().toJson(instance.videoDar),
  'duration': const StringToIntConverter().toJson(instance.duration),
  'comment_count': const StringToNullableIntConverter().toJson(
    instance.commentCount,
  ),
  'video_m3u8_url': instance.videoM3u8Url,
  'channel_id': const StringToNullableIntConverter().toJson(instance.channelId),
  'channel_detail': instance.channelDetail,
  'last_watch_second': const StringToNullableIntConverter().toJson(
    instance.lastWatchSecond,
  ),
};
