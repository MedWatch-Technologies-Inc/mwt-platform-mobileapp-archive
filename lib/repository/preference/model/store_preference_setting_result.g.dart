// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_preference_setting_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorePreferenceSettingResult _$StorePreferenceSettingResultFromJson(Map json) =>
    StorePreferenceSettingResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$StorePreferenceSettingResultToJson(
        StorePreferenceSettingResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
    };
