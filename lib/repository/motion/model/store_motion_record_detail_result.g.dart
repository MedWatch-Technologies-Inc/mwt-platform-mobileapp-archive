// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_motion_record_detail_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreMotionRecordDetailResult _$StoreMotionRecordDetailResultFromJson(
        Map json) =>
    StoreMotionRecordDetailResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      iD: (json['ID'] as List<dynamic>?)?.map((e) => e as int).toList(),
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$StoreMotionRecordDetailResultToJson(
        StoreMotionRecordDetailResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'ID': instance.iD,
      'Message': instance.message,
    };
