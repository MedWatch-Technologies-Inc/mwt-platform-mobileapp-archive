import 'package:json_annotation/json_annotation.dart';

part 'calendar_event_data_request.g.dart';

@JsonSerializable()
class CalendarEventDataRequest extends Object {
  @JsonKey(name: 'Information')
  String? information;

  @JsonKey(name: 'StartDate')
  String? startDate;

  @JsonKey(name: 'EndDate')
  String? endDate;

  @JsonKey(name: 'StartTime')
  String? startTime;

  @JsonKey(name: 'EndTime')
  String? endTime;

  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'Location')
  String? location;

  @JsonKey(name: 'url')
  String? url;

  @JsonKey(name: 'AllDayCheck')
  int? allDayCheck;

  @JsonKey(name: 'AlertId')
  int? alertId;

  @JsonKey(name: 'RepeatId')
  int? repeatId;

  @JsonKey(name: 'InvitedIds')
  List<dynamic>? invitedIds;

  @JsonKey(name: 'notes')
  String? notes;

  @JsonKey(name: 'Color')
  String? color;

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  @JsonKey(name: 'StartDateTimeStamp')
  String? startDateTimeStamp;

  @JsonKey(name: 'EndDateTimeStamp')
  String? endDateTimeStamp;

  CalendarEventDataRequest({
    this.information,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.userID,
    this.location,
    this.url,
    this.allDayCheck,
    this.alertId,
    this.repeatId,
    this.invitedIds,
    this.notes,
    this.color,
    this.createdDateTimeStamp,
    this.startDateTimeStamp,
    this.endDateTimeStamp,
  });

  factory CalendarEventDataRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$CalendarEventDataRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CalendarEventDataRequestToJson(this);
}
