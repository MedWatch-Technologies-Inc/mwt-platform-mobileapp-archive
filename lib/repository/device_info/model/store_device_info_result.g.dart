// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_device_info_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreDeviceInfoResult _$StoreDeviceInfoResultFromJson(Map json) =>
    StoreDeviceInfoResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      iD: json['ID'] as int?,
      message: json['Message'] as String?,
    );

Map<String, dynamic> _$StoreDeviceInfoResultToJson(
        StoreDeviceInfoResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'ID': instance.iD,
      'Message': instance.message,
    };
