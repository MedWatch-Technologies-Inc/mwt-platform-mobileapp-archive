// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_event_list_by_user_id_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetEventListByUserIdResult _$GetEventListByUserIdResultFromJson(Map json) =>
    GetEventListByUserIdResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => GetEventListByUserIdData.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$GetEventListByUserIdResultToJson(
        GetEventListByUserIdResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

GetEventListByUserIdData _$GetEventListByUserIdDataFromJson(Map json) =>
    GetEventListByUserIdData(
      title: json['title'] as String?,
      location: json['location'] as String?,
      url: json['url'] as String?,
      setRemindersID: json['SetRemindersID'] as int?,
      info: json['Info'] as String?,
      fKUserID: json['FKUserID'] as int?,
      start: json['start'] as String?,
      end: json['end'] as String?,
      startTime: json['StartTime'] as String?,
      endTime: json['EndTime'] as String?,
      alertId: json['AlertId'] as int?,
      repeatId: json['RepeatId'] as int?,
      invitedIds: json['InvitedIds'] as List<dynamic>?,
      endDateTimeStamp: json['EndDateTimeStamp'] as String?,
      startDateTimeStamp: json['StartDateTimeStamp'] as String?,
    );

Map<String, dynamic> _$GetEventListByUserIdDataToJson(
        GetEventListByUserIdData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'location': instance.location,
      'url': instance.url,
      'SetRemindersID': instance.setRemindersID,
      'Info': instance.info,
      'FKUserID': instance.fKUserID,
      'start': instance.start,
      'end': instance.end,
      'StartTime': instance.startTime,
      'EndTime': instance.endTime,
      'AlertId': instance.alertId,
      'RepeatId': instance.repeatId,
      'InvitedIds': instance.invitedIds,
      'StartDateTimeStamp': instance.startDateTimeStamp,
      'EndDateTimeStamp': instance.endDateTimeStamp,
    };
