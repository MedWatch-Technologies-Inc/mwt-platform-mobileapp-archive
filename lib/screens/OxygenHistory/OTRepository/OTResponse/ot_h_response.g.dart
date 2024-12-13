// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'ot_h_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTHistoryResponse _$GetOTHDataResponseFromJson(Map json) => OTHistoryResponse(
  json['Result'] as bool,
  json['Response'] as int,
  (json['Data'] is List ) ? (json['Data'] as List<dynamic>)
      .map((e) => OTHistoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList() : [],
);

Map<String, dynamic> _$GetOTHDataResponseToJson(OTHistoryResponse instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data.map((e) => e.toJson()).toList(),
    };
