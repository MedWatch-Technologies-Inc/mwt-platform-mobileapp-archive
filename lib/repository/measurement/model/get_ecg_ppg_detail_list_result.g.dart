// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_ecg_ppg_detail_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetEcgPpgDetailListResult _$GetEcgPpgDetailListResultFromJson(Map json) =>
    GetEcgPpgDetailListResult(
      json['Result'] as bool,
      json['Response'] as int,
      EcgPpgHistoryModel.fromJson(
          Map<String, dynamic>.from(json['Data'] as Map)),
    );

Map<String, dynamic> _$GetEcgPpgDetailListResultToJson(
        GetEcgPpgDetailListResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.ecgPpgHistoryModel.toJson(),
    };

EcgPpgHistoryModel _$EcgPpgHistoryModelFromJson(Map json) => EcgPpgHistoryModel(
      json['ID'] as int,
      json['UserID'] as int,
      json['FileName'] as String,
      json['DataStoreServer'] as String,
      (json['filteredEcgPoints'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['filteredPpgPoints'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['ecg_elapsed_time'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['ppg_elapsed_time'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$EcgPpgHistoryModelToJson(EcgPpgHistoryModel instance) =>
    <String, dynamic>{
      'ID': instance.iD,
      'UserID': instance.userID,
      'FileName': instance.fileName,
      'DataStoreServer': instance.dataStoreServer,
      'filteredEcgPoints': instance.filteredEcgPoints,
      'filteredPpgPoints': instance.filteredPpgPoints,
      'ecg_elapsed_time': instance.ecgElapsedTime,
      'ppg_elapsed_time': instance.ppgElapsedTime,
    };
