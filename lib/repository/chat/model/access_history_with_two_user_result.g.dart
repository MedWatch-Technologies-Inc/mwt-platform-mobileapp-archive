// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_history_with_two_user_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessHistoryWithTwoUserResult _$AccessHistoryWithTwoUserResultFromJson(
        Map json) =>
    AccessHistoryWithTwoUserResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => AccessHistoryWithTwoUserData.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$AccessHistoryWithTwoUserResultToJson(
        AccessHistoryWithTwoUserResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

AccessHistoryWithTwoUserData _$AccessHistoryWithTwoUserDataFromJson(Map json) =>
    AccessHistoryWithTwoUserData(
      messageId: json['MessageId'] as int?,
      message: json['Message'] as String?,
      dateSent: json['DateSent'] as String?,
      dateSentString: json['DateSentString'] as String?,
      fromUsername: json['FromUsername'] as String?,
      toUsername: json['ToUsername'] as String?,
      id: json['id'] as int?,
      toUserId: json['toUserId'] as int?,
      fromUserId: json['fromUserId'] as int?,
      timestamp: json['timestamp'] as int?,
      isSent: json['isSent'] as int?,
    );

Map<String, dynamic> _$AccessHistoryWithTwoUserDataToJson(
        AccessHistoryWithTwoUserData instance) =>
    <String, dynamic>{
      'MessageId': instance.messageId,
      'Message': instance.message,
      'DateSent': instance.dateSent,
      'DateSentString': instance.dateSentString,
      'FromUsername': instance.fromUsername,
      'ToUsername': instance.toUsername,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'id': instance.id,
      'isSent': instance.isSent,
      'timestamp': instance.timestamp,
    };
