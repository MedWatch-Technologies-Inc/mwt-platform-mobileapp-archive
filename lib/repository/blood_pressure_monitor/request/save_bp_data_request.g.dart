// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_bp_data_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveBPDataRequest _$SaveBPDataRequestFromJson(Map json) => SaveBPDataRequest(
      json['userId'] as int,
      (json['bpData'] as List<dynamic>)
          .map((e) => BpData.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$SaveBPDataRequestToJson(SaveBPDataRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'bpData': instance.bpData.map((e) => e.toJson()).toList(),
    };

BpData _$BpDataFromJson(Map json) => BpData(
      json['date'] as String,
      json['sys'] as int,
      json['dia'] as int,
    );

Map<String, dynamic> _$BpDataToJson(BpData instance) => <String, dynamic>{
      'date': instance.date,
      'sys': instance.sys,
      'dia': instance.dia,
    };
