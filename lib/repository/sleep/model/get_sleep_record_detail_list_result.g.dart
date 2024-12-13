// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_sleep_record_detail_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSleepRecordDetailListResult _$GetSleepRecordDetailListResultFromJson(
        Map json) =>
    GetSleepRecordDetailListResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => SleepInfoModel.fromJson(e as Map))
          .toList(),
    );

Map<String, dynamic> _$GetSleepRecordDetailListResultToJson(
        GetSleepRecordDetailListResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };
