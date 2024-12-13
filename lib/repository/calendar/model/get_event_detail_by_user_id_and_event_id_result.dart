import 'package:health_gauge/repository/calendar/model/get_event_list_by_user_id_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_event_detail_by_user_id_and_event_id_result.g.dart';

@JsonSerializable()
class GetEventDetailByUserIdAndEventIdResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  GetEventDetailByUserIdAndEventIdData? data;

  GetEventDetailByUserIdAndEventIdResult({
    this.result,
    this.response,
    this.data,
  });

  factory GetEventDetailByUserIdAndEventIdResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$GetEventDetailByUserIdAndEventIdResultFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$GetEventDetailByUserIdAndEventIdResultToJson(this);

  static GetEventDetailByUserIdAndEventIdResult mapper(GetEventDetailByUserIdAndEventIdResult obj) {
    var model = GetEventDetailByUserIdAndEventIdResult();
    model
      ..result = obj.result
      ..response = obj.response
      ..data =  obj.data;
    return model;
  }

}

@JsonSerializable()
class GetEventDetailByUserIdAndEventIdData extends Object {

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'information')
  String? information;

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

  @JsonKey(name: 'allDay')
  bool? allDay;

  @JsonKey(name: 'Notes')
  String? notes;

  @JsonKey(name: 'Color')
  String? color;

  @JsonKey(name: 'AlertId')
  int? alertId;

  @JsonKey(name: 'RepeatId')
  int? repeatId;

  @JsonKey(name: 'InvitedIds')
  List<int>? invitedIds;

  @JsonKey(name: 'StartDateTimeStamp')
  String? startDateTimeStamp;

  @JsonKey(name: 'EndDateTimeStamp')
  String? endDateTimeStamp;

  GetEventDetailByUserIdAndEventIdData({
    this.information,
    this.location,
    this.url,
    this.setRemindersID,
    this.info,
    this.fKUserID,
    this.start,
    this.end,
    this.startTime,
    this.endTime,
    this.allDay,
    this.notes,
    this.color,
    this.alertId,
    this.repeatId,
    this.invitedIds,
    this.startDateTimeStamp,
    this.endDateTimeStamp,
    this.title
  });

  factory GetEventDetailByUserIdAndEventIdData.fromJson(Map<String, dynamic> srcJson) =>
      _$GetEventDetailByUserIdAndEventIdDataFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$GetEventDetailByUserIdAndEventIdDataToJson(this);
}
