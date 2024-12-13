import 'dart:convert';

import 'package:health_gauge/utils/json_serializable_utils.dart';

class TagRecordDetail {
  num id;
  num fkTagLabelID;
  num tagValue;
  String notes;
  num fkUserID;
  String typeName;
  String createdDateTime;
  String createdDateTimeTimestamp;
  String unitSelectedType;
  String tagImage;
  String tagLabelName;
  List<String> attachFiles;
  String date;
  String time;
  num fkTagLabelTypeID;
  String location;
  String shortDescription;

  TagRecordDetail({
    required this.id,
    required this.fkTagLabelID,
    required this.tagValue,
    required this.notes,
    required this.fkUserID,
    required this.typeName,
    required this.createdDateTime,
    required this.createdDateTimeTimestamp,
    required this.unitSelectedType,
    required this.tagImage,
    required this.tagLabelName,
    required this.attachFiles,
    required this.date,
    required this.time,
    required this.fkTagLabelTypeID,
    required this.location,
    required this.shortDescription,
  });

  factory TagRecordDetail.fromJson(Map<String, dynamic> json) {
    return TagRecordDetail(
      id: JsonSerializableUtils.instance.checkNum(json['ID']),
      fkTagLabelID: JsonSerializableUtils.instance.checkNum(json['FKTagLabelID']),
      tagValue: JsonSerializableUtils.instance.checkNum(json['TagValue']),
      notes: JsonSerializableUtils.instance.checkString(json['Note']),
      fkUserID: JsonSerializableUtils.instance.checkNum(json['FKUserID']),
      typeName: JsonSerializableUtils.instance.checkString(json['TypeName']),
      createdDateTime: JsonSerializableUtils.instance.checkString(json['CreatedDateTime']),
      createdDateTimeTimestamp:
          JsonSerializableUtils.instance.checkString(json['CreatedDateTimeTimestamp']),
      unitSelectedType: JsonSerializableUtils.instance.checkString(json['UnitSelectedType']),
      tagImage: JsonSerializableUtils.instance.checkString(json['TagImage']),
      tagLabelName: JsonSerializableUtils.instance.checkString(json['TagLabelName']),
      attachFiles: json['AttachFiles']!=null ? List.of(json['AttachFiles']).map((i) => (json['AttachFiles'] ?? '').toString()).toList() : [],
      date: JsonSerializableUtils.instance.checkString(json['Date']),
      time: JsonSerializableUtils.instance.checkString(json['Time']),
      fkTagLabelTypeID: JsonSerializableUtils.instance.checkNum(json['FKTagLabelTypeID']),
      location: JsonSerializableUtils.instance.checkString(json['Location']),
      shortDescription: JsonSerializableUtils.instance.checkString(json['Short_description']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'FKTagLabelID': fkTagLabelID,
      'TagValue': tagValue,
      'Note': notes,
      'FKUserID': fkUserID,
      'TypeName': typeName,
      'CreatedDateTime': createdDateTime,
      'CreatedDateTimeTimestamp': createdDateTimeTimestamp,
      'UnitSelectedType': unitSelectedType,
      'TagImage': tagImage,
      'TagLabelName': tagLabelName,
      'AttachFiles': json.encode((attachFiles.map((e) => e.toString()).toList())),
      'Date': date,
      'Time': time,
      'FKTagLabelTypeID': fkTagLabelTypeID,
      'Location': location,
      'Short_description': shortDescription,
    };
  }
}
