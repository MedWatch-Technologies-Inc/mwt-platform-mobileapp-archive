// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_chat_history_group_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessChatHistoryGroupResult _$AccessChatHistoryGroupResultFromJson(Map json) =>
    AccessChatHistoryGroupResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => AccessChatHistoryData.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$AccessChatHistoryGroupResultToJson(
        AccessChatHistoryGroupResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

AccessChatHistoryData _$AccessChatHistoryDataFromJson(Map json) =>
    AccessChatHistoryData(
      messageId: json['MessageId'] as int?,
      message: json['Message'] as String?,
      dateSent: json['DateSent'] as String?,
      fromUsername: json['FromUsername'] as String?,
      dateSentString: json['DateSentString'] as String?,
      toUsername: json['ToUsername'] as String?,
    );

Map<String, dynamic> _$AccessChatHistoryDataToJson(
        AccessChatHistoryData instance) =>
    <String, dynamic>{
      'MessageId': instance.messageId,
      'Message': instance.message,
      'DateSent': instance.dateSent,
      'FromUsername': instance.fromUsername,
      'DateSentString': instance.dateSentString,
      'ToUsername': instance.toUsername,
    };
