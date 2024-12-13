// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bp_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBPDataResponse _$GetBPDataResponseFromJson(Map json) => GetBPDataResponse(
      json['Result'] as bool,
      json['Response'] as int,
      (json['Data'] is List ) ? (json['Data'] as List<dynamic>)
          .map((e) => BpDataModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList() : [],
    );

Map<String, dynamic> _$GetBPDataResponseToJson(GetBPDataResponse instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data.map((e) => e.toJson()).toList(),
    };

BpDataModel _$BpDataModelFromJson(Map json) => BpDataModel(
      json['ID'] as int,
      json['userId'] as int,
      json['date'] as String,
      json['sys'] as int,
      json['dia'] as int,
    );

Map<String, dynamic> _$BpDataModelToJson(BpDataModel instance) =>
    <String, dynamic>{
      'ID': instance.iD,
      'userId': instance.userId,
      'date': instance.date,
      'sys': instance.sys,
      'dia': instance.dia,
    };
