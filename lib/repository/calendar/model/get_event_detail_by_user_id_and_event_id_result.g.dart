// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_event_detail_by_user_id_and_event_id_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetEventDetailByUserIdAndEventIdResult
    _$GetEventDetailByUserIdAndEventIdResultFromJson(Map json) =>
        GetEventDetailByUserIdAndEventIdResult(
          result: json['Result'] as bool?,
          response: json['Response'] as int?,
          data: json['Data'] == null
              ? null
              : GetEventDetailByUserIdAndEventIdData.fromJson(
                  Map<String, dynamic>.from(json['Data'] as Map)),
        );

Map<String, dynamic> _$GetEventDetailByUserIdAndEventIdResultToJson(
        GetEventDetailByUserIdAndEventIdResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.toJson(),
    };

GetEventDetailByUserIdAndEventIdData
    _$GetEventDetailByUserIdAndEventIdDataFromJson(Map json) =>
        GetEventDetailByUserIdAndEventIdData(
          information: json['information'] as String?,
          location: json['location'] as String?,
          url: json['url'] as String?,
          setRemindersID: json['SetRemindersID'] as int?,
          info: json['Info'] as String?,
          fKUserID: json['FKUserID'] as int?,
          start: json['start'] as String?,
          end: json['end'] as String?,
          startTime: json['StartTime'] as String?,
          endTime: json['EndTime'] as String?,
          allDay: json['allDay'] as bool?,
          notes: json['Notes'] as String?,
          color: json['Color'] as String?,
          alertId: json['AlertId'] as int?,
          repeatId: json['RepeatId'] as int?,
          invitedIds: (json['InvitedIds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList(),
          startDateTimeStamp: json['StartDateTimeStamp'] as String?,
          endDateTimeStamp: json['EndDateTimeStamp'] as String?,
          title: json['title'] as String?,
        );

Map<String, dynamic> _$GetEventDetailByUserIdAndEventIdDataToJson(
        GetEventDetailByUserIdAndEventIdData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'information': instance.information,
      'location': instance.location,
      'url': instance.url,
      'SetRemindersID': instance.setRemindersID,
      'Info': instance.info,
      'FKUserID': instance.fKUserID,
      'start': instance.start,
      'end': instance.end,
      'StartTime': instance.startTime,
      'EndTime': instance.endTime,
      'allDay': instance.allDay,
      'Notes': instance.notes,
      'Color': instance.color,
      'AlertId': instance.alertId,
      'RepeatId': instance.repeatId,
      'InvitedIds': instance.invitedIds,
      'StartDateTimeStamp': instance.startDateTimeStamp,
      'EndDateTimeStamp': instance.endDateTimeStamp,
    };
