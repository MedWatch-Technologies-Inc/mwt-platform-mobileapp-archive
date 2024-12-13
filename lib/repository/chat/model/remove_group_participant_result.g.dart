// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_group_participant_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveGroupParticipantResult _$RemoveGroupParticipantResultFromJson(Map json) =>
    RemoveGroupParticipantResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$RemoveGroupParticipantResultToJson(
        RemoveGroupParticipantResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
    };
