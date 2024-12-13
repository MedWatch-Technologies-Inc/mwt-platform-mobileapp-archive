// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_sleep_record_detail_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreSleepRecordDetailRequest _$StoreSleepRecordDetailRequestFromJson(
        Map json) =>
    StoreSleepRecordDetailRequest(
      userId: json['userid'] as String?,
      id: json['id'] as int?,
      username: json['username'] as String?,
      sleepData: (json['sleepData'] as List<dynamic>?)
          ?.map((e) => SleepData.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      sleepDate: json['sleepDate'] as String?,
      sleepDeepTime: json['sleepDeepTime'] as int?,
      sleepLightTime: json['sleepLightTime'] as int?,
      sleepStayupTime: json['sleepStayupTime'] as int?,
      sleepTotalTime: json['sleepTotalTime'] as int?,
      sleepWalkingNumber: json['sleepWalkingNumber'] as int?,
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as String?,
    );

Map<String, dynamic> _$StoreSleepRecordDetailRequestToJson(
        StoreSleepRecordDetailRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userid': instance.userId,
      'username': instance.username,
      'sleepDate': instance.sleepDate,
      'sleepTotalTime': instance.sleepTotalTime,
      'sleepDeepTime': instance.sleepDeepTime,
      'sleepLightTime': instance.sleepLightTime,
      'sleepStayupTime': instance.sleepStayupTime,
      'sleepWalkingNumber': instance.sleepWalkingNumber,
      'sleepData': instance.sleepData?.map((e) => e.toJson()).toList(),
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
    };

SleepData _$SleepDataFromJson(Map json) => SleepData(
      sleepType: json['sleep_type'] as String?,
      startTime: json['startTime'] as String?,
    );

Map<String, dynamic> _$SleepDataToJson(SleepData instance) => <String, dynamic>{
      'sleep_type': instance.sleepType,
      'startTime': instance.startTime,
    };
