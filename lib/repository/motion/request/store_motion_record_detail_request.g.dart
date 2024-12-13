// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_motion_record_detail_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreMotionRecordDetailRequest _$StoreMotionRecordDetailRequestFromJson(
        Map json) =>
    StoreMotionRecordDetailRequest(
      userid: json['userid'] as String?,
      motionCalorie: json['motionCalorie'] as num?,
      motionDate: json['motionDate'] as String?,
      motionDistance: json['motionDistance'] as num?,
      motionSteps: json['motionSteps'] as int?,
      data: json['data'] as List<dynamic>?,
      motionDateStamp: json['motionDateStamp'] as String?,
      createdDateStamp: json['CreatedDateTimeStamp'] as String?,
    );

Map<String, dynamic> _$StoreMotionRecordDetailRequestToJson(
        StoreMotionRecordDetailRequest instance) =>
    <String, dynamic>{
      'userid': instance.userid,
      'motionCalorie': instance.motionCalorie,
      'motionDate': instance.motionDate,
      'motionDistance': instance.motionDistance,
      'motionSteps': instance.motionSteps,
      'data': instance.data,
      'motionDateStamp': instance.motionDateStamp,
      'CreatedDateTimeStamp': instance.createdDateStamp,
    };
