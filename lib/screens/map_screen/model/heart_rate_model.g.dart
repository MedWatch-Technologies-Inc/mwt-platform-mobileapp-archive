// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heart_rate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeartRateModel _$HeartRateModelFromJson(Map json) => HeartRateModel(
      hr: json['hr'] as int?,
      timeStamp: json['timeStamp'] as int?,
      speed: (json['speed'] as num?)?.toDouble(),
      elevation: (json['elevation'] as num?)?.toDouble(),
      locationData: json['locationData'] == null
          ? null
          : LocationAddressModel.fromJson(
              Map<String, dynamic>.from(json['locationData'] as Map)),
    );

Map<String, dynamic> _$HeartRateModelToJson(HeartRateModel instance) =>
    <String, dynamic>{
      'hr': instance.hr,
      'timeStamp': instance.timeStamp,
      'speed': instance.speed,
      'elevation': instance.elevation,
      'locationData': instance.locationData?.toJson(),
    };
