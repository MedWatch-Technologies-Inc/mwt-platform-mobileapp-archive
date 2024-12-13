// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_send_group_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessSendGroupResult _$AccessSendGroupResultFromJson(Map json) =>
    AccessSendGroupResult(
      result: json['Result'] as bool?,
      senderUserName: json['senderUserName'] as String?,
      message: json['Message'] as String?,
      groupName: json['groupName'] as String?,
    );

Map<String, dynamic> _$AccessSendGroupResultToJson(
        AccessSendGroupResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'senderUserName': instance.senderUserName,
      'Message': instance.message,
      'groupName': instance.groupName,
    };
