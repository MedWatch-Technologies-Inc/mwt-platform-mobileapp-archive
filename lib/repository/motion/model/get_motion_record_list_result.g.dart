// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_motion_record_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMotionRecordListResult _$GetMotionRecordListResultFromJson(Map json) =>
    GetMotionRecordListResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => MotionInfoModel.fromJson(e as Map))
          .toList(),
    );

Map<String, dynamic> _$GetMotionRecordListResultToJson(
        GetMotionRecordListResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };
