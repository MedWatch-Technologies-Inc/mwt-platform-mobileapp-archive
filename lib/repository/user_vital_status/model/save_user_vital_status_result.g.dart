// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_user_vital_status_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveUserVitalStatusResult _$SaveUserVitalStatusResultFromJson(Map json) =>
    SaveUserVitalStatusResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      iD: json['ID'] as List<dynamic>?,
    );

Map<String, dynamic> _$SaveUserVitalStatusResultToJson(
        SaveUserVitalStatusResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'ID': instance.iD,
    };
