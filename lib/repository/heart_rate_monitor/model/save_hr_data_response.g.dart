// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_hr_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveHrDataResponse _$SaveHrDataResponseFromJson(Map json) => SaveHrDataResponse(
      json['Result'] as bool,
      (json['ID'] ?? []) as List<dynamic>,
      json['Message'] as String,
    );

Map<String, dynamic> _$SaveHrDataResponseToJson(SaveHrDataResponse instance) =>
    <String, dynamic>{
      'Result': instance.result,

      'ID': instance.iD,
      'Message': instance.message,
    };
