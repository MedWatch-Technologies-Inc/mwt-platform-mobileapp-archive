// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupListResult _$GroupListResultFromJson(Map json) => GroupListResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) =>
              GroupListData.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$GroupListResultToJson(GroupListResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

GroupListData _$GroupListDataFromJson(Map json) => GroupListData(
      id: json['Id'] as int?,
      groupName: json['GroupName'] as String?,
      groupParticipants: json['GroupParticipants'] as String?,
      maskedGroupName: json['MaskedGroupName'] as String?,
      groupFirstLetter: json['GroupFirstLetter'] as String?,
      lastMessageAndDateGroup: json['LastMessageandDateGroup'] as String?,
      lastSentDateGroup: json['LastSentDateGroup'] as String?,
      lastSentMessageGroup: json['LastSentMessageGroup'] as String?,
    );

Map<String, dynamic> _$GroupListDataToJson(GroupListData instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'GroupName': instance.groupName,
      'GroupParticipants': instance.groupParticipants,
      'MaskedGroupName': instance.maskedGroupName,
      'GroupFirstLetter': instance.groupFirstLetter,
      'LastSentMessageGroup': instance.lastSentMessageGroup,
      'LastSentDateGroup': instance.lastSentDateGroup,
      'LastMessageandDateGroup': instance.lastMessageAndDateGroup,
    };
