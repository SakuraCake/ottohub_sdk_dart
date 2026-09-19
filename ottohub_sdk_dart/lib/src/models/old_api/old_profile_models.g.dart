// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'old_profile_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteBlogItem _$FavoriteBlogItemFromJson(
  Map<String, dynamic> json,
) => FavoriteBlogItem(
  bid: const StringToIntConverter().fromJson(json['bid']),
  uid: const StringToIntConverter().fromJson(json['uid']),
  title: json['title'] as String,
  content: json['content'] as String?,
  time: json['time'] as String,
  likeCount: const StringToIntConverter().fromJson(json['like_count']),
  favoriteCount: const StringToIntConverter().fromJson(json['favorite_count']),
  viewCount: const StringToIntConverter().fromJson(json['view_count']),
  isDeleted: const StringToNullableIntConverter().fromJson(json['is_deleted']),
  auditStatus: const StringToNullableIntConverter().fromJson(
    json['audit_status'],
  ),
  avatarUrl: json['avatar_url'] as String?,
  thumbnails: (json['thumbnails'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$FavoriteBlogItemToJson(FavoriteBlogItem instance) =>
    <String, dynamic>{
      'bid': ?const StringToIntConverter().toJson(instance.bid),
      'uid': ?const StringToIntConverter().toJson(instance.uid),
      'title': instance.title,
      'content': ?instance.content,
      'time': instance.time,
      'like_count': ?const StringToIntConverter().toJson(instance.likeCount),
      'favorite_count': ?const StringToIntConverter().toJson(
        instance.favoriteCount,
      ),
      'view_count': ?const StringToIntConverter().toJson(instance.viewCount),
      'is_deleted': ?const StringToNullableIntConverter().toJson(
        instance.isDeleted,
      ),
      'audit_status': ?const StringToNullableIntConverter().toJson(
        instance.auditStatus,
      ),
      'avatar_url': ?instance.avatarUrl,
      'thumbnails': ?instance.thumbnails,
    };

FavoriteVideoItem _$FavoriteVideoItemFromJson(Map<String, dynamic> json) =>
    FavoriteVideoItem(
      vid: const StringToIntConverter().fromJson(json['vid']),
      uid: const StringToIntConverter().fromJson(json['uid']),
      title: json['title'] as String,
      time: json['time'] as String,
      likeCount: const StringToIntConverter().fromJson(json['like_count']),
      favoriteCount: const StringToIntConverter().fromJson(
        json['favorite_count'],
      ),
      viewCount: const StringToIntConverter().fromJson(json['view_count']),
      isDeleted: (json['is_deleted'] as num?)?.toInt(),
      auditStatus: (json['audit_status'] as num?)?.toInt(),
      coverUrl: json['cover_url'] as String?,
      username: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$FavoriteVideoItemToJson(FavoriteVideoItem instance) =>
    <String, dynamic>{
      'vid': ?const StringToIntConverter().toJson(instance.vid),
      'uid': ?const StringToIntConverter().toJson(instance.uid),
      'title': instance.title,
      'time': instance.time,
      'like_count': ?const StringToIntConverter().toJson(instance.likeCount),
      'favorite_count': ?const StringToIntConverter().toJson(
        instance.favoriteCount,
      ),
      'view_count': ?const StringToIntConverter().toJson(instance.viewCount),
      'is_deleted': ?instance.isDeleted,
      'audit_status': ?instance.auditStatus,
      'cover_url': ?instance.coverUrl,
      'username': ?instance.username,
      'avatar_url': ?instance.avatarUrl,
    };

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  uid: const StringToIntConverter().fromJson(json['uid']),
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  qq: json['qq'] as String?,
  username: json['username'] as String? ?? '',
  time: json['time'] as String?,
  sex: json['sex'] as String?,
  intro: json['intro'] as String?,
  honour: json['honour'] as String?,
  experience: const StringToNullableIntConverter().fromJson(json['experience']),
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'uid': ?const StringToIntConverter().toJson(instance.uid),
      'email': ?instance.email,
      'phone': ?instance.phone,
      'qq': ?instance.qq,
      'username': instance.username,
      'time': ?instance.time,
      'sex': ?instance.sex,
      'intro': ?instance.intro,
      'honour': ?instance.honour,
      'experience': ?const StringToNullableIntConverter().toJson(
        instance.experience,
      ),
    };

ManageBlogItem _$ManageBlogItemFromJson(Map<String, dynamic> json) =>
    ManageBlogItem(
      bid: (json['bid'] as num).toInt(),
      uid: (json['uid'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String?,
      time: json['time'] as String,
      likeCount: (json['like_count'] as num).toInt(),
      favoriteCount: (json['favorite_count'] as num).toInt(),
      viewCount: (json['view_count'] as num).toInt(),
      isDeleted: (json['is_deleted'] as num?)?.toInt(),
      auditStatus: (json['audit_status'] as num?)?.toInt(),
      avatarUrl: json['avatar_url'] as String?,
      thumbnails: (json['thumbnails'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      collection: json['collection'] as String?,
      collectionSortOrder: (json['collection_sort_order'] as num?)?.toInt(),
      channelId: (json['channel_id'] as num?)?.toInt(),
      channelDetail: json['channel_detail'] == null
          ? null
          : ChannelDetail.fromJson(
              json['channel_detail'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ManageBlogItemToJson(ManageBlogItem instance) =>
    <String, dynamic>{
      'bid': instance.bid,
      'uid': instance.uid,
      'title': instance.title,
      'content': ?instance.content,
      'time': instance.time,
      'like_count': instance.likeCount,
      'favorite_count': instance.favoriteCount,
      'view_count': instance.viewCount,
      'is_deleted': ?instance.isDeleted,
      'audit_status': ?instance.auditStatus,
      'avatar_url': ?instance.avatarUrl,
      'thumbnails': ?instance.thumbnails,
      'collection': ?instance.collection,
      'collection_sort_order': ?instance.collectionSortOrder,
      'channel_id': ?instance.channelId,
      'channel_detail': ?instance.channelDetail,
    };

ManageVideoItem _$ManageVideoItemFromJson(Map<String, dynamic> json) =>
    ManageVideoItem(
      vid: (json['vid'] as num).toInt(),
      uid: (json['uid'] as num).toInt(),
      title: json['title'] as String,
      time: json['time'] as String,
      likeCount: (json['like_count'] as num).toInt(),
      favoriteCount: (json['favorite_count'] as num).toInt(),
      viewCount: (json['view_count'] as num).toInt(),
      isDeleted: (json['is_deleted'] as num?)?.toInt(),
      auditStatus: (json['audit_status'] as num?)?.toInt(),
      coverUrl: json['cover_url'] as String?,
      collection: json['collection'] as String?,
      collectionSortOrder: (json['collection_sort_order'] as num?)?.toInt(),
      channelId: (json['channel_id'] as num?)?.toInt(),
      channelDetail: json['channel_detail'] == null
          ? null
          : ChannelDetail.fromJson(
              json['channel_detail'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ManageVideoItemToJson(ManageVideoItem instance) =>
    <String, dynamic>{
      'vid': instance.vid,
      'uid': instance.uid,
      'title': instance.title,
      'time': instance.time,
      'like_count': instance.likeCount,
      'favorite_count': instance.favoriteCount,
      'view_count': instance.viewCount,
      'is_deleted': ?instance.isDeleted,
      'audit_status': ?instance.auditStatus,
      'cover_url': ?instance.coverUrl,
      'collection': ?instance.collection,
      'collection_sort_order': ?instance.collectionSortOrder,
      'channel_id': ?instance.channelId,
      'channel_detail': ?instance.channelDetail,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  videoNum: const StringToIntConverter().fromJson(json['video_num']),
  blogNum: const StringToIntConverter().fromJson(json['blog_num']),
  followingsCount: const StringToIntConverter().fromJson(
    json['followings_count'],
  ),
  fansCount: const StringToIntConverter().fromJson(json['fans_count']),
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'video_num': const StringToIntConverter().toJson(instance.videoNum),
  'blog_num': const StringToIntConverter().toJson(instance.blogNum),
  'followings_count': const StringToIntConverter().toJson(
    instance.followingsCount,
  ),
  'fans_count': const StringToIntConverter().toJson(instance.fansCount),
};

BlogDraft _$BlogDraftFromJson(Map<String, dynamic> json) =>
    BlogDraft(content: json['content'] as String?);

Map<String, dynamic> _$BlogDraftToJson(BlogDraft instance) => <String, dynamic>{
  'content': ?instance.content,
};
