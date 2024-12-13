// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_tag_record_detail_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreTagRecordDetailRequest _$StoreTagRecordDetailRequestFromJson(Map json) =>
    StoreTagRecordDetailRequest(
      date: json['date'] as String?,
      note: json['note'] as String?,
      time: json['time'] as String?,
      type: json['type'] as String?,
      userId: json['userId'] as String?,
          location: json['Location'] as String?,
      value: (json['value'] as num?)?.toDouble(),
      unitSelectedType: json['UnitSelectedType'] as String,
      attachFile: (json['AttachFile'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as String?,
    );

Map<String, dynamic> _$StoreTagRecordDetailRequestToJson(
        StoreTagRecordDetailRequest instance) =>
    <String, dynamic>{
      'date': instance.date,
      'note': instance.note,
      'time': instance.time,
      'type': instance.type,
      'userId': instance.userId,
      'Location': instance.location,
      'value': instance.value,
      'UnitSelectedType': instance.unitSelectedType,
      'AttachFile': instance.attachFile,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
    };
