// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_device_settings_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDeviceSettingResult _$GetDeviceSettingResultFromJson(Map json) => GetDeviceSettingResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: json['Data'] != null ? DeviceSettingModel.fromJson(json['Data']) : null,
    );

Map<String, dynamic> _$GetDeviceSettingResultToJson(GetDeviceSettingResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.toJson(),
    };
