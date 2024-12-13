// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_tag_record_detail_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreTagRecordDetailResult _$StoreTagRecordDetailResultFromJson(Map json) =>
    StoreTagRecordDetailResult(
      result: json['Result'] as bool?,
      message: json['Message'] as String?,
      iD: json['ID'] as int?,
    );

Map<String, dynamic> _$StoreTagRecordDetailResultToJson(
        StoreTagRecordDetailResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Message': instance.message,
      'ID': instance.iD,
    };
