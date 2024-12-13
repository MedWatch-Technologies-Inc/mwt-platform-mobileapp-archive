// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_firmware_version_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetFirmwareVersionListResult _$GetFirmwareVersionListResultFromJson(Map json) =>
    GetFirmwareVersionListResult(
      result: json['Result'] as bool?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => GetFirmwareVersionListData.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$GetFirmwareVersionListResultToJson(
        GetFirmwareVersionListResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

GetFirmwareVersionListData _$GetFirmwareVersionListDataFromJson(Map json) =>
    GetFirmwareVersionListData(
      iD: json['ID'] as int?,
      versionNo: json['VersionNo'] as String?,
      versionname: json['Versionname'] as String?,
      dateofuploading: json['Dateofuploading'] as String?,
      description: json['Description'] as String?,
      downloadurl: json['Downloadurl'] as String?,
      fkFirmwareTypeId: json['fk_FirmwareTypeId'] as int?,
      userID: json['UserID'] as int?,
      pageNumber: json['PageNumber'] as int?,
      pageSize: json['PageSize'] as int?,
      totalRecords: json['TotalRecords'] as int?,
      firmwareType: json['FirmwareType'] as String?,
    );

Map<String, dynamic> _$GetFirmwareVersionListDataToJson(
        GetFirmwareVersionListData instance) =>
    <String, dynamic>{
      'ID': instance.iD,
      'VersionNo': instance.versionNo,
      'Versionname': instance.versionname,
      'Dateofuploading': instance.dateofuploading,
      'Description': instance.description,
      'Downloadurl': instance.downloadurl,
      'fk_FirmwareTypeId': instance.fkFirmwareTypeId,
      'UserID': instance.userID,
      'PageNumber': instance.pageNumber,
      'PageSize': instance.pageSize,
      'TotalRecords': instance.totalRecords,
      'FirmwareType': instance.firmwareType,
    };
