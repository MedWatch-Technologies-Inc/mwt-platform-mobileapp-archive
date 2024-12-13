// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hr_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HRResponse _$GetHRResponseFromJson(Map json) => HRResponse(
  json['Result'] as bool,
  json['Response'] as int,
  (json['Data'] is List ) ? (json['Data'] as List<dynamic>)
      .map((e) => SyncHRModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList() : [],
);

Map<String, dynamic> _$GetHRResponseToJson(HRResponse instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data.map((e) => e.toJsonDB()).toList(),
    };
