import 'package:json_annotation/json_annotation.dart';

part 'store_sleep_record_detail_request.g.dart';

@JsonSerializable()
class StoreSleepRecordDetailRequest extends Object {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'userid')
  String? userId;

  @JsonKey(name: 'username')
  String? username;

  @JsonKey(name: 'sleepDate')
  String? sleepDate;

  @JsonKey(name: 'sleepTotalTime')
  int? sleepTotalTime;

  @JsonKey(name: 'sleepDeepTime')
  int? sleepDeepTime;

  @JsonKey(name: 'sleepLightTime')
  int? sleepLightTime;

  @JsonKey(name: 'sleepStayupTime')
  int? sleepStayupTime;

  @JsonKey(name: 'sleepWalkingNumber')
  int? sleepWalkingNumber;

  @JsonKey(name: 'sleepData')
  List<SleepData>? sleepData;

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  StoreSleepRecordDetailRequest({
    this.userId,
    this.id,
    this.username,
    this.sleepData,
    this.sleepDate,
    this.sleepDeepTime,
    this.sleepLightTime,
    this.sleepStayupTime,
    this.sleepTotalTime,
    this.sleepWalkingNumber,
    this.createdDateTimeStamp,
  });

  factory StoreSleepRecordDetailRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$StoreSleepRecordDetailRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StoreSleepRecordDetailRequestToJson(this);
}

@JsonSerializable()
class SleepData extends Object {
  @JsonKey(name: 'sleep_type')
  String? sleepType;

  @JsonKey(name: 'startTime')
  String? startTime;

  SleepData({
    this.sleepType,
    this.startTime,
  });

  factory SleepData.fromJson(Map<String, dynamic> srcJson) =>
      _$SleepDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SleepDataToJson(this);
}
