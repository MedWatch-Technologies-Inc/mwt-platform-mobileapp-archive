// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_tag_record_detail_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditTagRecordDetailRequest _$EditTagRecordDetailRequestFromJson(Map json) =>
    EditTagRecordDetailRequest(
      id: json['id'] as String?,
      date: json['date'] as String?,
      note: json['note'] as String?,
      time: json['time'] as String?,
      type: json['type'] as String?,
      userId: json['userId'] as String?,
          location: json['Location'] as String?,
      value: (json['value'] as num?)?.toDouble(),
      unitSelectedType: json['UnitSelectedType'] as String?,
      attachFile: (json['AttachFile'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdDateTimeStamp: json['CreatedDateTimeStamp'] as String?,
    );

Map<String, dynamic> _$EditTagRecordDetailRequestToJson(
        EditTagRecordDetailRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'note': instance.note,
      'time': instance.time,
      'type': instance.type,
      'userId': instance.userId,
      'Location': instance.location,
      'value': instance.value,
      'UnitSelectedType': instance.unitSelectedType,
      'CreatedDateTimeStamp': instance.createdDateTimeStamp,
      'AttachFile': instance.attachFile,
    };
