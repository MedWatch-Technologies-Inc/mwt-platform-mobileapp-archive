// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bp_h_reponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BPHistoryResponse _$GetBPDataResponseFromJson(Map json) => BPHistoryResponse(
      json['Result'] as bool,
      json['Response'] as int,
      (json['Data'] is List ) ? (json['Data'] as List<dynamic>)
          .map((e) => BPHistoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList() : [],
    );

Map<String, dynamic> _$GetBPDataResponseToJson(BPHistoryResponse instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data.map((e) => e.toJson()).toList(),
    };
