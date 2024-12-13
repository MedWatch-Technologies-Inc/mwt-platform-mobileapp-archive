import 'package:health_gauge/utils/json_serializable_utils.dart';
import 'package:intl/intl.dart';

class TagDetail {
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

  TagDetail({
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

  factory TagDetail.fromJson(Map<String, dynamic> json) {
    return TagDetail(
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
      attachFiles:
          List.of(json['AttachFiles']).map((i) => (json['AttachFiles'] ?? '').toString()).toList(),
      date: JsonSerializableUtils.instance.checkString(json['Date']),
      time: JsonSerializableUtils.instance.checkString(json['Time']),
      fkTagLabelTypeID: JsonSerializableUtils.instance.checkNum(json['FKTagLabelTypeID']),
      location: JsonSerializableUtils.instance.checkString(json['Location']),
      shortDescription: JsonSerializableUtils.instance.checkString(json['Short_description']),
    );
  }

  factory TagDetail.fromAddJson(Map<String, dynamic> json) {
    int timestamp = json['CreatedDateTimeStamp'] ?? DateTime.now().millisecondsSinceEpoch;
    var dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
    return TagDetail(
      id: JsonSerializableUtils.instance.checkNum(json['tagID']),
      location: JsonSerializableUtils.instance.checkString(json['Location']),
      createdDateTime: JsonSerializableUtils.instance.checkString(dateTime),
      createdDateTimeTimestamp:
          JsonSerializableUtils.instance.checkString(json['CreatedDateTimeStamp']),
      attachFiles:
          List.of(json['AttachFile']).map((i) => (json['AttachFile'] ?? '').toString()).toList(),
      unitSelectedType: JsonSerializableUtils.instance.checkString(json['UnitSelectedType']),
      tagValue: JsonSerializableUtils.instance.checkNum(json['value']),
      fkUserID: JsonSerializableUtils.instance.checkNum(json['userId']),
      typeName: JsonSerializableUtils.instance.checkString(json['type']),
      time: JsonSerializableUtils.instance.checkString(json['time']),
      notes: JsonSerializableUtils.instance.checkString(json['note']),
      date: JsonSerializableUtils.instance.checkString(json['date']),
      tagImage: JsonSerializableUtils.instance.checkString(json['TagImage']),
      fkTagLabelID: JsonSerializableUtils.instance.checkNum(json['FKTagLabelID']),
      tagLabelName: JsonSerializableUtils.instance.checkString(json['TagLabelName']),
      fkTagLabelTypeID: JsonSerializableUtils.instance.checkNum(json['FKTagLabelTypeID']),
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
      'AttachFiles': attachFiles.map((e) => e.toString()).toList(),
      'Date': date,
      'Time': time,
      'FKTagLabelTypeID': fkTagLabelTypeID,
      'Location': location,
      'Short_description': shortDescription,
    };
  }
}
