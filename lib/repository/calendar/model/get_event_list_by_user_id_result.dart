import 'package:json_annotation/json_annotation.dart';

part 'get_event_list_by_user_id_result.g.dart';

@JsonSerializable()
class GetEventListByUserIdResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<GetEventListByUserIdData>? data;

  GetEventListByUserIdResult({
    this.result,
    this.response,
    this.data,
  });

  factory GetEventListByUserIdResult.fromJson(Map<String, dynamic> srcJson) =>
      _$GetEventListByUserIdResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetEventListByUserIdResultToJson(this);
}

@JsonSerializable()
class GetEventListByUserIdData extends Object {
  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'location')
  String? location;

  @JsonKey(name: 'url')
  String? url;

  @JsonKey(name: 'SetRemindersID')
  int? setRemindersID;

  @JsonKey(name: 'Info')
  String? info;

  @JsonKey(name: 'FKUserID')
  int? fKUserID;

  @JsonKey(name: 'start')
  String? start;

  @JsonKey(name: 'end')
  String? end;

  @JsonKey(name: 'StartTime')
  String? startTime;

  @JsonKey(name: 'EndTime')
  String? endTime;

  @JsonKey(name: 'AlertId')
  int? alertId;

  @JsonKey(name: 'RepeatId')
  int? repeatId;

  @JsonKey(name: 'InvitedIds')
  List<dynamic>? invitedIds;

  @JsonKey(name: 'StartDateTimeStamp')
  String? startDateTimeStamp;

  @JsonKey(name: 'EndDateTimeStamp')
  String? endDateTimeStamp;

  // @JsonKey(name: 'notes')
  // String? notes;
  //
  // @JsonKey(name: 'AllDayCheck')
  // String? AllDayCheck;

  GetEventListByUserIdData({
    this.title,
    this.location,
    this.url,
    this.setRemindersID,
    this.info,
    this.fKUserID,
    this.start,
    this.end,
    this.startTime,
    this.endTime,
    this.alertId,
    this.repeatId,
    this.invitedIds,
    this.endDateTimeStamp,
    this.startDateTimeStamp,
  //  this.notes
  });

  factory GetEventListByUserIdData.fromJson(Map<String, dynamic> srcJson) =>
      _$GetEventListByUserIdDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetEventListByUserIdDataToJson(this);
}






// @JsonSerializable()
// class GetEventListByUserIdAndEventData extends Object {
//   @JsonKey(name: 'title')
//   String? title;
//
//   @JsonKey(name: 'location')
//   String? location;
//
//   @JsonKey(name: 'url')
//   String? url;
//
//   @JsonKey(name: 'SetRemindersID')
//   int? setRemindersID;
//
//   @JsonKey(name: 'Info')
//   String? info;
//
//   @JsonKey(name: 'FKUserID')
//   int? fKUserID;
//
//   @JsonKey(name: 'start')
//   String? start;
//
//   @JsonKey(name: 'end')
//   String? end;
//
//   @JsonKey(name: 'StartTime')
//   String? startTime;
//
//   @JsonKey(name: 'EndTime')
//   String? endTime;
//
//   @JsonKey(name: 'AlertId')
//   int? alertId;
//
//   @JsonKey(name: 'RepeatId')
//   int? repeatId;
//
//   @JsonKey(name: 'InvitedIds')
//   List<dynamic>? invitedIds;
//
//   @JsonKey(name: 'StartDateTimeStamp')
//   String? startDateTimeStamp;
//
//   @JsonKey(name: 'EndDateTimeStamp')
//   String? endDateTimeStamp;
//
//   @JsonKey(name: 'notes')
//   String? notes;
//
//   @JsonKey(name: 'AllDayCheck')
//   int? allDay;
//
//   GetEventListByUserIdAndEventData({
//     this.title,
//     this.location,
//     this.url,
//     this.setRemindersID,
//     this.info,
//     this.fKUserID,
//     this.start,
//     this.end,
//     this.startTime,
//     this.endTime,
//     this.alertId,
//     this.repeatId,
//     this.invitedIds,
//     this.endDateTimeStamp,
//     this.startDateTimeStamp,
//     this.notes,
//     this.allDay
//   });
//
//   factory GetEventListByUserIdAndEventData.fromJson(Map<String, dynamic> srcJson) =>
//       _$GetEventListByUserIdAndEventDataFromJson(srcJson);
//
//   Map<String, dynamic> toJson() => _$GetEventListByUserIdAndEventDataToJson(this);
// }
//
