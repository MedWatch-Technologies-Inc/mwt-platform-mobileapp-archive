// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_tag_label_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddTagLabelRequest _$AddTagLabelRequestFromJson(Map json) => AddTagLabelRequest(
      userID: json['UserID'] as String?,
      imageName: json['ImageName'] as String?,
      unitName: json['UnitName'] as String?,
      labelName: json['LabelName'] as String?,
      minRange: (json['MinRange'] as num?)?.toDouble(),
      maxRange: (json['MaxRange'] as num?)?.toDouble(),
      defaultValue: (json['DefaultValue'] as num?)?.toDouble(),
      precisionDigit: (json['PrecisionDigit'] as num?)?.toDouble(),
      fKTagLabelTypeID: json['FKTagLabelTypeID'] as int?,
      isAutoLoad: json['IsAutoLoad'] as bool?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as int?,
      shortDescription: json['Short_description'] ?? '',
    );

Map<String, dynamic> _$AddTagLabelRequestToJson(AddTagLabelRequest instance) =>
    <String, dynamic>{
      'UserID': instance.userID,
      'ImageName': instance.imageName,
      'UnitName': instance.unitName,
      'LabelName': instance.labelName,
      'MinRange': instance.minRange,
      'MaxRange': instance.maxRange,
      'DefaultValue': instance.defaultValue,
      'PrecisionDigit': instance.precisionDigit,
      'FKTagLabelTypeID': instance.fKTagLabelTypeID,
      'IsAutoLoad': instance.isAutoLoad,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
      'Short_description': instance.shortDescription,
    };
