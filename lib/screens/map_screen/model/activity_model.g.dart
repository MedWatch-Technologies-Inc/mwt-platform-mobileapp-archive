// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map json) => ActivityModel(
      id: json['Id'] as String?,
      userId: json['userId'] as String?,
      imageString: json['imageString'] as String?,
      startTime: json['startTime'] as int?,
      endTime: json['endTime'] as int?,
      totalTime: json['totalTime'] as int?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      desc: json['desc'] as String?,
      activityIntensity: (json['activityIntensity'] as num?)?.toDouble(),
      typeTitle: json['typeTitle'] as String?,
      imageModelList: (json['imageList'] as List<dynamic>?)
          ?.map((e) => ImageModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      heartRateModel: (json['heartRate'] as List<dynamic>?)
          ?.map((e) =>
              HeartRateModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      locationList: (json['locationData'] as List<dynamic>?)
          ?.map((e) => LocationAddressModel.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'userId': instance.userId,
      'imageString': instance.imageString,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'totalTime': instance.totalTime,
      'type': instance.type,
      'title': instance.title,
      'desc': instance.desc,
      'activityIntensity': instance.activityIntensity,
      'typeTitle': instance.typeTitle,
      'imageList': instance.imageModelList?.map((e) => e.toJson()).toList(),
      'heartRate': instance.heartRateModel?.map((e) => e.toJson()).toList(),
      'locationData': instance.locationList?.map((e) => e.toJson()).toList(),
    };
