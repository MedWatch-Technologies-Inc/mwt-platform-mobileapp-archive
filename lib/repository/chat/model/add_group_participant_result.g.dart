// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_group_participant_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddGroupParticipantResult _$AddGroupParticipantResultFromJson(Map json) =>
    AddGroupParticipantResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$AddGroupParticipantResultToJson(
        AddGroupParticipantResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
    };
