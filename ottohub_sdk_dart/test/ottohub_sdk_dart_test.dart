import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/ottohub_sdk_dart.dart';

void main() {
  test('package exports OttohubClient', () {
    expect(OttohubClient, isA<Type>());
  });

  test('package exports ApiException', () {
    expect(ApiException, isA<Type>());
  });

  test('package exports LoginResponse', () {
    expect(LoginResponse, isA<Type>());
  });

  test('ApiException stores error code', () {
    final e = ApiException('error_token');
    expect(e.errorCode, 'error_token');
    expect(e.toString(), 'error_token');
  });

  test('package exports all I*Api interfaces', () {
    expect(IAuthApi, isA<Type>());
    expect(IVideoApi, isA<Type>());
    expect(IFollowingApi, isA<Type>());
    expect(IBlockApi, isA<Type>());
    expect(IDanmakuApi, isA<Type>());
    expect(IChannelApi, isA<Type>());
    expect(IModerationApi, isA<Type>());
    expect(IOldBlogApi, isA<Type>());
    expect(IOldCommentApi, isA<Type>());
    expect(IOldImApi, isA<Type>());
    expect(IOldManageApi, isA<Type>());
    expect(IOldProfileApi, isA<Type>());
    expect(IOldCreatorApi, isA<Type>());
    expect(IOldSystemApi, isA<Type>());
    expect(IOldCollectionApi, isA<Type>());
    expect(IOldUserApi, isA<Type>());
    expect(IOldEngagementApi, isA<Type>());
  });

  test('OttohubClient initializes all API modules', () {
    final client = OttohubClient();
    expect(client.auth, isA<IAuthApi>());
    expect(client.video, isA<IVideoApi>());
    expect(client.following, isA<IFollowingApi>());
    expect(client.block, isA<IBlockApi>());
    expect(client.danmaku, isA<IDanmakuApi>());
    expect(client.channel, isA<IChannelApi>());
    expect(client.moderation, isA<IModerationApi>());
    expect(client.oldBlog, isA<IOldBlogApi>());
    expect(client.oldComment, isA<IOldCommentApi>());
    expect(client.oldIm, isA<IOldImApi>());
    expect(client.oldManage, isA<IOldManageApi>());
    expect(client.oldProfile, isA<IOldProfileApi>());
    expect(client.oldCreator, isA<IOldCreatorApi>());
    expect(client.oldSystem, isA<IOldSystemApi>());
    expect(client.oldCollection, isA<IOldCollectionApi>());
    expect(client.oldUser, isA<IOldUserApi>());
    expect(client.oldEngagement, isA<IOldEngagementApi>());
  });

  test('OttohubClient accepts custom baseUrl and Dio', () {
    final client = OttohubClient(token: 'test_token');
    expect(client.token, 'test_token');
  });
}

