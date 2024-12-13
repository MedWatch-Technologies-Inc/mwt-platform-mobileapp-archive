import 'dart:convert';

import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:http/http.dart';

class Tag {
  int? id;
  String? apiId;
  String? userId;
  String? unit;
  String? icon;
  String? label;
  String? keyword;
  String? patchLocation;
  String shortDescription;

  double? min;
  double? max;
  double? defaultValue;
  double? precision;

  int? isRemove;
  int? isSync;
  int? isDefault;
  int? tagType;
  bool? isAutoLoad;

  Tag({
    this.id,
    this.userId,
    this.icon,
    this.label,
    this.min,
    this.max,
    this.defaultValue,
    this.precision,
    this.isRemove,
    this.patchLocation,
    this.isSync,
    this.isDefault,
    this.tagType,
    this.isAutoLoad,
    this.keyword,
    this.shortDescription = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'UserId': userId,
      'IdForApi': apiId,
      'Icon': icon,
      'Unit': unit,
      'Label': label,
      'Min': min,
      'Max': max,
      'Default': defaultValue,
      'Precision': precision,
      'IsRemove': isRemove ?? 0,
      'isSync': isSync ?? 0,
      'isDefault': isDefault ?? 0,
      'TagType': tagType ?? 0,
      'IsAutoLoad': isAutoLoad == true ? 1 : 0,
      'keyword': keyword,
      'Short_description': shortDescription,
      // 'PatchLocation': patchLocation ?? '',
    };
  }

  fromMap(Map map) async {
    if (check('Id', map)) {
      id = map['Id'];
    }
    if (check('keyword', map)) {
      keyword = map['keyword'];
    }
    if (check('ID', map)) {
      id = map['ID'];
      apiId = map['ID'].toString();
    }
    if (check('IdForApi', map)) {
      apiId = map['IdForApi'];
    }
    if (check('Unit', map)) {
      unit = map['Unit'];
    }
    if (check('PatchLocation', map)) {
      patchLocation = map['PatchLocation'];
    }
    if (check('UserId', map)) {
      userId = map['UserId'].toString();
    }
    if (check('UserID', map)) {
      userId = map['UserID'].toString();
    }
    if (check('Icon', map)) {
      icon = map['Icon'];
    }
    if (check('ImageName', map)) {
      icon = map['ImageName'];
    }
    if (icon != null && icon!.contains('http') && (Uri.tryParse(icon!)?.isAbsolute ?? false)) {
      try {
        Response result = await get(Uri.parse(icon!));
        print('byteResponse :: ${result.body}');
        icon = base64Encode(result.bodyBytes);
      } catch (e) {
        print(e);
      }
    }
    if (check('Label', map)) {
      label = map['Label'];
    }
    if (check('LabelName', map)) {
      label = map['LabelName'];
    }
    if (check('Min', map)) {
      min = double.parse(map['Min'].toString());
    }
    if (check('MinRange', map)) {
      min = double.parse(map['MinRange'].toString());
    }
    if (check('Max', map)) {
      max = double.parse(map['Max'].toString());
    }
    if (check('MaxRange', map)) {
      max = double.parse(map['MaxRange'].toString());
    }
    if (check('Default', map)) {
      defaultValue = double.parse(map['Default'].toString());
    }
    if (check('DefaultValue', map)) {
      defaultValue = double.parse(map['DefaultValue'].toString());
    }
    if (check('Precision', map)) {
      precision = double.parse(map['Precision'].toString());
    }
    if (check('PrecisionDigit', map)) {
      precision = double.parse(map['PrecisionDigit'].toString());
    }
    if (check('IsRemove', map)) {
      isRemove = map['IsRemove'];
    }
    if (check('isSync', map)) {
      isSync = map['isSync'];
    }
    if (check('isDefault', map)) {
      isDefault = map['isDefault'];
    }
    if (check('IsDefault', map)) {
      isDefault = map['IsDefault'];
    }

    if (check('TagType', map)) {
      tagType = map['TagType'];
    }
    if (check('IsAutoLoad', map)) {
      if (map['IsAutoLoad'] == 1 || map['IsAutoLoad'] == true)
        isAutoLoad = true;
      else
        isAutoLoad = false;
    }
    if (check('Short_description', map)) {
      shortDescription = map['Short_description'];
    }

    try {
      if (check('FKTagLabelTypeID', map)) {
        tagType = map['FKTagLabelTypeID'];
      }
    } catch (e) {
      print(e);
    }

    try {
      if (tagType == TagType.Alcohol.value) {
        unit = stringLocalization.getText(StringLocalization.glass);
      } else {
        if (check('UnitName', map)) {
          unit = map['UnitName'];
        }
      }
    } catch (e) {
      print(e);
    }
    return this;
  }

  bool check(String key, Map map) {
    if (map[key] != null) {
      if (map[key] is String && map[key] == 'null') {
        return false;
      }
      return true;
    }
    return false;
  }

  Map<String, dynamic> toTagLabelMap(Map<String, dynamic> json) {
    return {
      'ID': json['Id'],
      'LabelName': json['Label'],
      'MinRange': json['Min'],
      'MaxRange': json['Max'],
      'PrecisionDigit': json['Precision'],
      'DefaultValue': json['Default'],
      'UnitName': json['Unit'],
      'ImageName': json['Icon'],
      'UserID': json['UserId'],
      'FKTagLabelTypeID': json['TagType'],
      'IsAutoLoad': json['IsAutoLoad'],
      'Short_description': json['Short_description'],
    };
  }
}
