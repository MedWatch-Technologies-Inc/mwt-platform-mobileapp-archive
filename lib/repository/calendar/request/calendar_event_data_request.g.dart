// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event_data_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarEventDataRequest _$CalendarEventDataRequestFromJson(Map json) =>
    CalendarEventDataRequest(
      information: json['Information'] as String?,
      startDate: json['StartDate'] as String?,
      endDate: json['EndDate'] as String?,
      startTime: json['StartTime'] as String?,
      endTime: json['EndTime'] as String?,
      userID: json['UserID'] as int?,
      location: json['Location'] as String?,
      url: json['url'] as String?,
      allDayCheck: json['AllDayCheck'] as int?,
      alertId: json['AlertId'] as int?,
      repeatId: json['RepeatId'] as int?,
      invitedIds: json['InvitedIds'] as List<dynamic>?,
      notes: json['notes'] as String?,
      color: json['Color'] as String?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as String?,
      startDateTimeStamp: json['StartDateTimeStamp'] as String?,
      endDateTimeStamp: json['EndDateTimeStamp'] as String?,
    );

Map<String, dynamic> _$CalendarEventDataRequestToJson(
        CalendarEventDataRequest instance) =>
    <String, dynamic>{
      'Information': instance.information,
      'StartDate': instance.startDate,
      'EndDate': instance.endDate,
      'StartTime': instance.startTime,
      'EndTime': instance.endTime,
      'UserID': instance.userID,
      'Location': instance.location,
      'url': instance.url,
      'AllDayCheck': instance.allDayCheck,
      'AlertId': instance.alertId,
      'RepeatId': instance.repeatId,
      'InvitedIds': instance.invitedIds,
      'notes': instance.notes,
      'Color': instance.color,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
      'StartDateTimeStamp': instance.startDateTimeStamp,
      'EndDateTimeStamp': instance.endDateTimeStamp,
    };
