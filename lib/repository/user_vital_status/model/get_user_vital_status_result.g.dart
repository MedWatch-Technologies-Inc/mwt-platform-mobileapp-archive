// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_vital_status_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserVitalStatusResult _$GetUserVitalStatusResultFromJson(Map json) =>
    GetUserVitalStatusResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => TempModel.fromJson(e as Map))
          .toList(),
    );

Map<String, dynamic> _$GetUserVitalStatusResultToJson(
        GetUserVitalStatusResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };
