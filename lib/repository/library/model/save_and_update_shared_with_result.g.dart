// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_and_update_shared_with_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveAndUpdateSharedWithResult _$SaveAndUpdateSharedWithResultFromJson(
        Map json) =>
    SaveAndUpdateSharedWithResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
      iD: json['ID'] as int?,
    );

Map<String, dynamic> _$SaveAndUpdateSharedWithResultToJson(
        SaveAndUpdateSharedWithResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
      'ID': instance.iD,
    };
