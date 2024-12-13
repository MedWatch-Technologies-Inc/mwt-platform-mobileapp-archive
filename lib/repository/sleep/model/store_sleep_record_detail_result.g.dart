// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_sleep_record_detail_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreSleepRecordDetailResult _$StoreSleepRecordDetailResultFromJson(Map json) =>
    StoreSleepRecordDetailResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      id: (json['IDs'] as List<dynamic>?)?.map((e) => e as int).toList(),
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$StoreSleepRecordDetailResultToJson(
        StoreSleepRecordDetailResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
      'IDs': instance.id,
    };
