import 'package:health_gauge/screens/tag/add_tag_dialog.dart';
import 'package:health_gauge/utils/json_serializable_utils.dart';

class TagLabel {
  int iD;
  String labelName;
  num minRange;
  num maxRange;
  num defaultValue;
  num precisionDigit;
  int totalRecords;
  int pageNumber;
  int pageSize;
  String unitName;
  String imageName;
  int userID;
  int fKTagLabelTypeID;
  String suggestion;
  String createdDateTime;
  String createdDateTimeStamp;
  bool isAutoLoad;
  String shortDescription;
  TagVType tagVType;

  TagLabel({
    required this.iD,
    required this.labelName,
    required this.minRange,
    required this.maxRange,
    required this.defaultValue,
    required this.precisionDigit,
    required this.totalRecords,
    required this.pageNumber,
    required this.pageSize,
    required this.unitName,
    required this.imageName,
    required this.userID,
    required this.fKTagLabelTypeID,
    required this.suggestion,
    required this.createdDateTime,
    required this.createdDateTimeStamp,
    required this.isAutoLoad,
    required this.shortDescription,
    this.tagVType = TagVType.slider,
  });

  factory TagLabel.fromJson(Map<String, dynamic> json) {
    var precision = JsonSerializableUtils.instance.checkNum(json['PrecisionDigit']);
    var tagType =
        JsonSerializableUtils.instance.checkInt(json['FKTagLabelTypeID'], defaultValue: 1);
    return TagLabel(
      iD: JsonSerializableUtils.instance.checkInt(json['ID']),
      labelName: JsonSerializableUtils.instance.checkString(json['LabelName']),
      minRange: JsonSerializableUtils.instance.checkNum(json['MinRange']),
      maxRange: JsonSerializableUtils.instance.checkNum(json['MaxRange']),
      defaultValue: JsonSerializableUtils.instance.checkNum(json['DefaultValue']),
      precisionDigit: precision,
      totalRecords: JsonSerializableUtils.instance.checkInt(json['TotalRecords']),
      pageNumber: JsonSerializableUtils.instance.checkInt(json['PageNumber']),
      pageSize: JsonSerializableUtils.instance.checkInt(json['PageSize']),
      unitName: JsonSerializableUtils.instance.checkString(json['UnitName']),
      imageName: JsonSerializableUtils.instance.checkString(json['ImageName']),
      userID: JsonSerializableUtils.instance.checkInt(json['UserID']),
      fKTagLabelTypeID:
          JsonSerializableUtils.instance.checkInt(json['FKTagLabelTypeID'], defaultValue: 1),
      suggestion: JsonSerializableUtils.instance.checkString(json['Suggestion']),
      createdDateTime: JsonSerializableUtils.instance.checkString(json['CreatedDateTime']),
      createdDateTimeStamp:
          JsonSerializableUtils.instance.checkString(json['CreatedDateTimeStamp']),
      isAutoLoad: JsonSerializableUtils.instance.checkBool(json['IsAutoLoad']),
      shortDescription: JsonSerializableUtils.instance.checkString(json['Short_description']),
      tagVType: tagType == 1 ? TagVType.slider : TagVType.range,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ID'] = iD;
    data['LabelName'] = labelName;
    data['MinRange'] = minRange;
    data['MaxRange'] = maxRange;
    data['DefaultValue'] = defaultValue;
    data['PrecisionDigit'] = precisionDigit;
    data['TotalRecords'] = totalRecords;
    data['PageNumber'] = pageNumber;
    data['PageSize'] = pageSize;
    data['UnitName'] = unitName;
    data['ImageName'] = imageName;
    data['UserID'] = userID;
    data['FKTagLabelTypeID'] = fKTagLabelTypeID;
    data['Suggestion'] = suggestion;
    data['CreatedDateTime'] = createdDateTime;
    data['CreatedDateTimeStamp'] = createdDateTimeStamp;
    data['IsAutoLoad'] = isAutoLoad;
    data['Short_description'] = shortDescription;
    return data;
  }
}
