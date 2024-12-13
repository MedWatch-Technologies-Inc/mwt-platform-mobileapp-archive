// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_device_info_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreDeviceInfoRequest _$StoreDeviceInfoRequestFromJson(Map json) =>
    StoreDeviceInfoRequest(
      userID: json['UserID'] as String?,
      iD: json['ID'] as int?,
      blockStatus: json['BlockStatus'] as String?,
      deviceAddress: json['DeviceAddress'] as String?,
      deviceName: json['DeviceName'] as String?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as int?,
    );

Map<String, dynamic> _$StoreDeviceInfoRequestToJson(
        StoreDeviceInfoRequest instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'DeviceName': instance.deviceName,
      'DeviceAddress': instance.deviceAddress,
      'BlockStatus': instance.blockStatus,
      'ID': instance.iD,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
    };
