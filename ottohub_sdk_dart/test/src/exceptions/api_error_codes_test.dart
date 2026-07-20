import 'package:test/test.dart';
import 'package:ottohub_sdk_dart/ottohub_sdk_dart.dart';

void main() {
  group('ApiErrorCodes - General', () {
    test('constants are defined', () {
      expect(GeneralErrorCodes.missingArgument, 'missing_argument');
      expect(GeneralErrorCodes.errorToken, 'error_token');
      expect(GeneralErrorCodes.systemError, 'system_error');
      expect(GeneralErrorCodes.tooManyRequests, 'too_many_requests');
      expect(GeneralErrorCodes.errorType, 'error_type');
      expect(GeneralErrorCodes.errorUid, 'error_uid');
      expect(GeneralErrorCodes.tooBigNum, 'too_big_num');
      expect(GeneralErrorCodes.error, 'error');
      expect(GeneralErrorCodes.noPermission, 'no_permission');
      expect(GeneralErrorCodes.warn, 'warn');
    });
  });

  group('ApiErrorCodes - Auth', () {
    test('constants are defined', () {
      expect(AuthErrorCodes.errorPassword, 'error_password');
      expect(AuthErrorCodes.errorPw, 'error_pw');
      expect(AuthErrorCodes.mismatchPw, 'mismatch_pw');
      expect(AuthErrorCodes.emailExist, 'email_exist');
      expect(AuthErrorCodes.emailUnexist, 'email_unexist');
      expect(AuthErrorCodes.errorEmail, 'error_email');
      expect(AuthErrorCodes.errorQqEmail, 'error_qq_email');
      expect(AuthErrorCodes.errorVerificationCode, 'error_verification_code');
    });
  });

  group('ApiErrorCodes - Video', () {
    test('constants are defined', () {
      expect(VideoErrorCodes.errorVid, 'error_vid');
      expect(VideoErrorCodes.missingArgumentToken, 'missing_argument_token');
      expect(VideoErrorCodes.titleTooLong, 'title_too_long');
      expect(VideoErrorCodes.introTooLong, 'intro_too_long');
      expect(VideoErrorCodes.tagTooMany, 'tag_too_many');
      expect(VideoErrorCodes.errorCategory, 'error_category');
      expect(VideoErrorCodes.errorTag, 'error_tag');
      expect(VideoErrorCodes.errorFile, 'error_file');
      expect(VideoErrorCodes.tooBigFile, 'too_big_file');
      expect(VideoErrorCodes.channelNotFound, 'channel_not_found');
      expect(VideoErrorCodes.notChannelMember, 'not_channel_member');
      expect(VideoErrorCodes.channelSectionNotFound, 'channel_section_not_found');
      expect(VideoErrorCodes.channelSectionNotBelongToChannel,
          'channel_section_not_belong_to_channel');
      expect(
          VideoErrorCodes.videoNotFoundOrNotOwned, 'video_not_found_or_not_owned');
    });
  });

  group('ApiErrorCodes - Following', () {
    test('constants are defined', () {
      expect(FollowingErrorCodes.errorFollowingUid, 'error_following_uid');
      expect(FollowingErrorCodes.tooManyFollowings, 'too_many_followings');
    });
  });

  group('ApiErrorCodes - Block', () {
    test('constants are defined', () {
      expect(BlockErrorCodes.missingBlockedId, 'Missing blocked_id parameter');
      expect(BlockErrorCodes.cannotBlockYourself, 'Cannot block yourself');
      expect(BlockErrorCodes.userNotFound, 'User not found');
      expect(BlockErrorCodes.userAlreadyBlocked, 'User already blocked');
      expect(BlockErrorCodes.blockRecordNotFound, 'Block record not found');
      expect(BlockErrorCodes.cannotUnblockYourself, 'Cannot unblock yourself');
      expect(BlockErrorCodes.tokenRequired, 'Token required');
    });
  });

  group('ApiErrorCodes - Danmaku', () {
    test('constants are defined', () {
      expect(DanmakuErrorCodes.errorDanmakuId, 'error_danmaku_id');
      expect(DanmakuErrorCodes.errorTime, 'error_time');
      expect(DanmakuErrorCodes.errorMode, 'error_mode');
      expect(DanmakuErrorCodes.errorColor, 'error_color');
      expect(DanmakuErrorCodes.errorFontSize, 'error_font_size');
      expect(DanmakuErrorCodes.textTooLong, 'text_too_long');
      expect(DanmakuErrorCodes.textTooShort, 'text_too_short');
      expect(DanmakuErrorCodes.renderTooLong, 'render_too_long');
    });
  });

  group('ApiErrorCodes - Moderation', () {
    test('constants are defined', () {
      expect(ModerationErrorCodes.notReviewer, 'not_reviewer');
      expect(ModerationErrorCodes.errorVid, 'error_vid');
      expect(ModerationErrorCodes.errorBid, 'error_bid');
      expect(ModerationErrorCodes.errorVcid, 'error_vcid');
      expect(ModerationErrorCodes.errorBcid, 'error_bcid');
      expect(ModerationErrorCodes.errorDanmakuId, 'error_danmaku_id');
      expect(ModerationErrorCodes.errorUid, 'error_uid');
      expect(ModerationErrorCodes.cannotReviewOwnContent,
          'cannot_review_own_content');
      expect(
          ModerationErrorCodes.cannotReviewOwnReport, 'cannot_review_own_report');
    });
  });

  group('ApiErrorCodes - Channel', () {
    test('constants are defined', () {
      expect(ChannelErrorCodes.permissionDenied, 'permission_denied');
      expect(ChannelErrorCodes.resourceNotFound, 'resource_not_found');
      expect(ChannelErrorCodes.invalidParameter, 'invalid_parameter');
    });
  });

  group('ApiErrorCodes - OldApi', () {
    test('constants are defined', () {
      expect(OldApiErrorCodes.errorVid, 'error_vid');
      expect(OldApiErrorCodes.errorBid, 'error_bid');
      expect(OldApiErrorCodes.errorCid, 'error_cid');
      expect(OldApiErrorCodes.errorFid, 'error_fid');
      expect(OldApiErrorCodes.favoriteAlready, 'favorite_already');
      expect(OldApiErrorCodes.favoriteCountFull, 'favorite_count_full');
    });
  });


}
