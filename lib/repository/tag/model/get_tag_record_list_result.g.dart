// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_tag_record_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTagRecordListResult _$GetTagRecordListResultFromJson(Map json) =>
    GetTagRecordListResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => GetTagRecordListData.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$GetTagRecordListResultToJson(
        GetTagRecordListResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

GetTagRecordListData _$GetTagRecordListDataFromJson(Map json) =>
    GetTagRecordListData(
      json['ID'] as int?,
      json['FKTagLabelID'] as int?,
      (json['TagValue'] as num?)?.toDouble(),
      json['Note'] as String?,
      json['FKUserID'] as int?,
      json['TypeName'] as String?,
      json['TotalRecords'] as int?,
      json['PageNumber'] as int?,
      json['PageSize'] as int?,
      json['CreatedDateTime'] as String?,
      json['hdnTagValue'] as int?,
      json['CreatedDateTimeTimestamp'] as String?,
      json['AttachFiles'] as List<dynamic>?,
    );

Map<String, dynamic> _$GetTagRecordListDataToJson(
        GetTagRecordListData instance) =>
    <String, dynamic>{
      'ID': instance.iD,
      'FKTagLabelID': instance.fKTagLabelID,
      'TagValue': instance.tagValue,
      'Note': instance.note,
      'FKUserID': instance.fKUserID,
      'TypeName': instance.typeName,
      'TotalRecords': instance.totalRecords,
      'PageNumber': instance.pageNumber,
      'PageSize': instance.pageSize,
      'CreatedDateTime': instance.createdDateTime,
      'hdnTagValue': instance.hdnTagValue,
      'CreatedDateTimeTimestamp': instance.createdDateTimeTimestamp,
      'AttachFiles': instance.attachFiles,
    };
