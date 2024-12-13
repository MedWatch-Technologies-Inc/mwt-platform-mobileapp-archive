import 'package:health_gauge/utils/json_serializable_utils.dart';

class PreConfiguredTag {
  num id;
  String labelName;
  num minRange;
  num maxRange;
  num defaultValue;
  num precisionDigit;
  String unitName;
  String imageName;
  num tagLabelTypeID;
  String createdDateTime;
  String createdDateTimeStamp;

  PreConfiguredTag({
    required this.id,
    required this.labelName,
    required this.minRange,
    required this.maxRange,
    required this.defaultValue,
    required this.precisionDigit,
    required this.unitName,
    required this.imageName,
    required this.tagLabelTypeID,
    required this.createdDateTime,
    required this.createdDateTimeStamp,
  });

  factory PreConfiguredTag.fromJson(Map<String, dynamic> json) {
    num minRange = JsonSerializableUtils.instance.checkNum(json['MinRange']);
    return PreConfiguredTag(
      id: JsonSerializableUtils.instance.checkNum(json['ID']),
      labelName: JsonSerializableUtils.instance.checkString(json['LabelName']),
      minRange: minRange > 0 ? minRange : 1.0,
      maxRange: JsonSerializableUtils.instance.checkNum(json['MaxRange']),
      defaultValue: JsonSerializableUtils.instance.checkNum(json['DefaultValue']),
      precisionDigit: JsonSerializableUtils.instance.checkNum(json['PrecisionDigit']),
      unitName: JsonSerializableUtils.instance.checkString(json['UnitName']),
      imageName: JsonSerializableUtils.instance.checkString(json['ImageName']),
      tagLabelTypeID: JsonSerializableUtils.instance.checkNum(json['FKTagLabelTypeID']),
      createdDateTime: JsonSerializableUtils.instance.checkString(json['CreatedDateTime']),
      createdDateTimeStamp:
          JsonSerializableUtils.instance.checkString(json['CreatedDateTimeStamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'LabelName': labelName,
      'MinRange': minRange,
      'MaxRange': maxRange,
      'DefaultValue': defaultValue,
      'PrecisionDigit': precisionDigit,
      'UnitName': unitName,
      'ImageName': imageName,
      'FKTagLabelTypeID': tagLabelTypeID,
      'CreatedDateTime': createdDateTime,
      'CreatedDateTimeStamp': createdDateTimeStamp,
    };
  }
}


