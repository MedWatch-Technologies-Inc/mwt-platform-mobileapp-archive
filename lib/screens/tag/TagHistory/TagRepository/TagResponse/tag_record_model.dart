import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/json_serializable_utils.dart';
import 'package:intl/intl.dart';

class TagRecordModel {
  num id;
  num fkTagLabelID;
  num tagValue;
  String note;
  num fkUserID;
  String typeName;
  String createdDateTime;
  // num hdnTagValue;
  int createdDateTimeTimestamp;
  String unitSelectedType;
  String tagImage;
  String tagLabelName;
  List<String> attachFiles;

  final ValueNotifier<bool> showDetails = ValueNotifier(false);

  bool get isShowDetails => showDetails.value;

  set isShowDetails(bool value) {
    showDetails.value = value;
  }

  TagRecordModel({
    required this.id,
    required this.fkTagLabelID,
    required this.tagValue,
    required this.note,
    required this.fkUserID,
    required this.typeName,
    required this.createdDateTime,
    // required this.hdnTagValue,
    required this.createdDateTimeTimestamp,
    required this.unitSelectedType,
    required this.tagImage,
    required this.tagLabelName,
    required this.attachFiles,
  });

  String get getDate => DateFormat(DateUtil.MMMddhhmma)
      .format(DateTime.fromMillisecondsSinceEpoch(createdDateTimeTimestamp));

  String get getTime => DateFormat(DateUtil.hmma)
      .format(DateTime.fromMillisecondsSinceEpoch(createdDateTimeTimestamp));

  factory TagRecordModel.fromJson(Map<String, dynamic> json) {
    return TagRecordModel(
      id: JsonSerializableUtils.instance.checkNum(json['ID']),
      fkTagLabelID: JsonSerializableUtils.instance.checkNum(json['FKTagLabelID']),
      tagValue: JsonSerializableUtils.instance.checkNum(json['TagValue']),
      note: JsonSerializableUtils.instance.checkString(json['Note']),
      fkUserID: JsonSerializableUtils.instance.checkNum(json['FKUserID']),
      typeName: JsonSerializableUtils.instance.checkString(json['TypeName']),
      createdDateTime: JsonSerializableUtils.instance.checkString(json['CreatedDateTime']),
      // hdnTagValue: JsonSerializableUtils.instance.checkNum(json['hdnTagValue']),
      createdDateTimeTimestamp:
      JsonSerializableUtils.instance.checkInt(json['CreatedDateTimeTimestamp']),
      unitSelectedType: JsonSerializableUtils.instance.checkString(json['UnitSelectedType']),
      tagImage: JsonSerializableUtils.instance.checkString(json['TagImage']),
      tagLabelName: JsonSerializableUtils.instance.checkString(json['TagLabelName']),
      attachFiles: (json['AttachFiles'] as List).map((e) => e.toString()).toList(),
    );
  }

  factory TagRecordModel.fromJsonDB(Map<String, dynamic> json) {
    return TagRecordModel(
      id: JsonSerializableUtils.instance.checkNum(json['ID']),
      fkTagLabelID: JsonSerializableUtils.instance.checkNum(json['FKTagLabelID']),
      tagValue: JsonSerializableUtils.instance.checkNum(json['TagValue']),
      note: JsonSerializableUtils.instance.checkString(json['Note']),
      fkUserID: JsonSerializableUtils.instance.checkNum(json['FKUserID']),
      typeName: JsonSerializableUtils.instance.checkString(json['TypeName']),
      createdDateTime: JsonSerializableUtils.instance.checkString(json['CreatedDateTime']),
      // hdnTagValue: JsonSerializableUtils.instance.checkNum(json['hdnTagValue']),
      createdDateTimeTimestamp:
      JsonSerializableUtils.instance.checkInt(json['CreatedDateTimeTimestamp']),
      unitSelectedType: JsonSerializableUtils.instance.checkString(json['UnitSelectedType']),
      tagImage: JsonSerializableUtils.instance.checkString(json['TagImage']),
      tagLabelName: JsonSerializableUtils.instance.checkString(json['TagLabelName']),
      attachFiles: (jsonDecode(json['AttachFiles']) as List).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson({bool isFromDB = false}) {
    return {
      'ID': id,
      'FKTagLabelID': fkTagLabelID,
      'TagValue': tagValue,
      'Note': note,
      'FKUserID': fkUserID,
      'TypeName': typeName,
      'CreatedDateTime': createdDateTime,
      // 'hdnTagValue': hdnTagValue,
      'CreatedDateTimeTimestamp': createdDateTimeTimestamp,
      'UnitSelectedType': unitSelectedType,
      'TagImage': tagImage,
      'TagLabelName': tagLabelName,
      'AttachFiles': isFromDB ? jsonEncode(attachFiles) : attachFiles.map((e) => e.toString()).toList(),
    };
  }
}
