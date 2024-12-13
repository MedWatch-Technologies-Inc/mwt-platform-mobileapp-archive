// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_recognition_activity_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreRecognitionActivityRequest _$StoreRecognitionActivityRequestFromJson(
        Map json) =>
    StoreRecognitionActivityRequest(
      id: json['Id'] as String?,
      userId: json['userId'] as String?,
      startTime: json['startTime'] as int?,
      endTime: json['endTime'] as int?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      desc: json['desc'] as String?,
      activityIntensity: (json['activityIntensity'] as num?)?.toDouble(),
      typeTitle: json['typeTitle'] as String?,
      imageList: (json['imageList'] as List<dynamic>?)
          ?.map((e) => ImageModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      heartRate: (json['heartRate'] as List<dynamic>?)
          ?.map((e) => HeartRate.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      locationData: (json['locationData'] as List<dynamic>?)
          ?.map(
              (e) => LocationData.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    )..totalTime = json['totalTime'] as int?;

Map<String, dynamic> _$StoreRecognitionActivityRequestToJson(
        StoreRecognitionActivityRequest instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'userId': instance.userId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'type': instance.type,
      'title': instance.title,
      'desc': instance.desc,
      'activityIntensity': instance.activityIntensity,
      'typeTitle': instance.typeTitle,
      'imageList': instance.imageList?.map((e) => e.toJson()).toList(),
      'heartRate': instance.heartRate?.map((e) => e.toJson()).toList(),
      'locationData': instance.locationData?.map((e) => e.toJson()).toList(),
      'totalTime': instance.totalTime,
    };

HeartRate _$HeartRateFromJson(Map json) => HeartRate(
      json['hr'] as int?,
      (json['timeStamp'] as num?)?.toDouble(),
      json['locationData'] == null
          ? null
          : LocationData.fromJson(
              Map<String, dynamic>.from(json['locationData'] as Map)),
      (json['speed'] as num?)?.toDouble(),
      (json['elevation'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HeartRateToJson(HeartRate instance) => <String, dynamic>{
      'hr': instance.hr,
      'timeStamp': instance.timeStamp,
      'locationData': instance.locationData?.toJson(),
      'speed': instance.speed,
      'elevation': instance.elevation,
    };

LocationData _$LocationDataFromJson(Map json) => LocationData(
      savedName: json['savedName'] as String?,
      locationName: json['locationName'] as String?,
      locationAddress: json['locationAddress'] as String?,
      locationFullAddress: json['locationFullAddress'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      placesId: json['placesId'] as String?,
      altitude: (json['altitude'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      speedAccuracy: (json['speedAccuracy'] as num?)?.toDouble(),
      time: (json['time'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LocationDataToJson(LocationData instance) =>
    <String, dynamic>{
      'savedName': instance.savedName,
      'locationName': instance.locationName,
      'locationAddress': instance.locationAddress,
      'locationFullAddress': instance.locationFullAddress,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notes': instance.notes,
      'placesId': instance.placesId,
      'altitude': instance.altitude,
      'accuracy': instance.accuracy,
      'heading': instance.heading,
      'speed': instance.speed,
      'speedAccuracy': instance.speedAccuracy,
      'time': instance.time,
    };
