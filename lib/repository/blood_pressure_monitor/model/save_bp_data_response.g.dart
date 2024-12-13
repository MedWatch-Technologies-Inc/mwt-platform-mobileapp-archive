// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_bp_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveBPDataResponse _$SaveBPDataResponseFromJson(Map json) => SaveBPDataResponse(
      json['Result'] as bool,
      ((json['ID'] ?? [])as List<dynamic>).map((e) => e as int).toList(),
      json['Message'] as String,
    );

Map<String, dynamic> _$SaveBPDataResponseToJson(SaveBPDataResponse instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'ID': instance.iD,
      'Message': instance.message,
    };
