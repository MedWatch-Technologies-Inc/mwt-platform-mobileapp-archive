// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_chat_history_two_users_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessChatHistoryTwoUsersRequest _$AccessChatHistoryTwoUsersRequestFromJson(
        Map json) =>
    AccessChatHistoryTwoUsersRequest(
      fromUserId: json['fromuserId'] as String?,
      toUserId: json['touserId'] as String?,
    );

Map<String, dynamic> _$AccessChatHistoryTwoUsersRequestToJson(
        AccessChatHistoryTwoUsersRequest instance) =>
    <String, dynamic>{
      'fromuserId': instance.fromUserId,
      'touserId': instance.toUserId,
    };
