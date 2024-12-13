// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_tag_label_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTagLabelListResult _$GetTagLabelListResultFromJson(Map json) => GetTagLabelListResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => GetTagLabelListData.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$GetTagLabelListResultToJson(GetTagLabelListResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

GetTagLabelListData _$GetTagLabelListDataFromJson(Map json) => GetTagLabelListData(
      iD: json['ID'] as int?,
      labelName: json['LabelName'] as String?,
      minRange: (json['MinRange'] as num?)?.toDouble(),
      maxRange: (json['MaxRange'] as num?)?.toDouble(),
      defaultValue: (json['DefaultValue'] as num?)?.toDouble(),
      precisionDigit: (json['PrecisionDigit'] as num?)?.toDouble(),
      totalRecords: json['TotalRecords'] as int?,
      pageNumber: json['PageNumber'] as int?,
      pageSize: json['PageSize'] as int?,
      unitName: json['UnitName'] as String?,
      imageName: json['ImageName'] as String?,
      userID: json['UserID'] as int?,
      fKTagLabelTypeID: json['FKTagLabelTypeID'] as int?,
      createdDateTime: json['CreatedDateTime'] as String?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as String?,
      isAutoLoad: json['IsAutoLoad'] as bool?,
      shortDescription: json['Short_description'] ?? '',
    );

Map<String, dynamic> _$GetTagLabelListDataToJson(GetTagLabelListData instance) => <String, dynamic>{
      'ID': instance.iD,
      'LabelName': instance.labelName,
      'MinRange': instance.minRange,
      'MaxRange': instance.maxRange,
      'DefaultValue': instance.defaultValue,
      'PrecisionDigit': instance.precisionDigit,
      'TotalRecords': instance.totalRecords,
      'PageNumber': instance.pageNumber,
      'PageSize': instance.pageSize,
      'UnitName': instance.unitName,
      'ImageName': instance.imageName,
      'UserID': instance.userID,
      'FKTagLabelTypeID': instance.fKTagLabelTypeID,
      'CreatedDateTime': instance.createdDateTime,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
      'IsAutoLoad': instance.isAutoLoad,
      'Short_description': instance.shortDescription,
    };
