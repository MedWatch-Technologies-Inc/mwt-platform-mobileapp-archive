// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_recognition_activity_list_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetRecognitionActivityListResult _$GetRecognitionActivityListResultFromJson(
        Map json) =>
    GetRecognitionActivityListResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      data: (json['Data'] as List<dynamic>?)
          ?.map((e) => GetRecognitionActivityListData.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$GetRecognitionActivityListResultToJson(
        GetRecognitionActivityListResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Data': instance.data?.map((e) => e.toJson()).toList(),
    };

GetRecognitionActivityListData _$GetRecognitionActivityListDataFromJson(
        Map json) =>
    GetRecognitionActivityListData(
      aid: json['Aid'] as int?,
      id: json['Id'] as String?,
      title: json['Title'] as String?,
      userID: json['UserID'] as int?,
      locationData: (json['LocationData'] as List<dynamic>?)
          ?.map(
              (e) => LocationData.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      startTime: json['StartTime'] as String?,
      endTime: json['EndTime'] as String?,
      heartRate: (json['HeartRate'] as List<dynamic>?)
          ?.map((e) => HeartRate.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      calories: json['Calories'] as int?,
      stepsData: json['StepsData'] as int?,
      type: json['Type'] as String?,
      imageString: json['ImageString'] as String?,
      desc: json['Desc'] as String?,
      activityIntensity: json['ActivityIntensity'] as String?,
      imageList: (json['ImageList'] as List<dynamic>?)
          ?.map((e) => ImageModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      name: json['Name'] as String?,
      typeTitle: json['TypeTitle'] as String?,
      totalTime: json['TotalTime'] as String?,
      shareWith: json['ShareWith'] as String?,
      unit: json['unit'] as int?,
    );

Map<String, dynamic> _$GetRecognitionActivityListDataToJson(
        GetRecognitionActivityListData instance) =>
    <String, dynamic>{
      'Aid': instance.aid,
      'Id': instance.id,
      'Title': instance.title,
      'UserID': instance.userID,
      'LocationData': instance.locationData?.map((e) => e.toJson()).toList(),
      'StartTime': instance.startTime,
      'EndTime': instance.endTime,
      'HeartRate': instance.heartRate?.map((e) => e.toJson()).toList(),
      'Calories': instance.calories,
      'StepsData': instance.stepsData,
      'Type': instance.type,
      'ImageString': instance.imageString,
      'Desc': instance.desc,
      'ImageList': instance.imageList?.map((e) => e.toJson()).toList(),
      'ActivityIntensity': instance.activityIntensity,
      'TypeTitle': instance.typeTitle,
      'Name': instance.name,
      'TotalTime': instance.totalTime,
      'ShareWith': instance.shareWith,
      'unit': instance.unit
    };

LocationData _$LocationDataFromJson(Map json) => LocationData(
      iD: json['ID'] as int?,
      actvId: json['ActvId'] as int?,
      latitude: json['Latitude'] as String?,
      longitude: json['Longitude'] as String?,
      accuracy: json['Accuracy'] as String?,
      altitude: json['Altitude'] as String?,
      speed: (json['Speed'] as num?)?.toDouble(),
      speedAccuracy: (json['SpeedAccuracy'] as num?)?.toDouble(),
      heading: json['Heading'] as String?,
      time: json['Time'] as String?,
    );

Map<String, dynamic> _$LocationDataToJson(LocationData instance) =>
    <String, dynamic>{
      'ID': instance.iD,
      'ActvId': instance.actvId,
      'Latitude': instance.latitude,
      'Longitude': instance.longitude,
      'Accuracy': instance.accuracy,
      'Altitude': instance.altitude,
      'Speed': instance.speed,
      'SpeedAccuracy': instance.speedAccuracy,
      'Heading': instance.heading,
      'Time': instance.time,
    };

HeartRate _$HeartRateFromJson(Map json) => HeartRate(
      iD: json['ID'] as int?,
      actvId: json['ActvId'] as int?,
      hR: json['HR'] as int?,
      timeStamp: json['TimeStamp'] as String?,
      locationData: json['LocationData'] == null
          ? null
          : LocationData.fromJson(
              Map<String, dynamic>.from(json['LocationData'] as Map)),
      elevation: json['Elevation'] as String?,
      speed: json['Speed'] as String?,
    );

Map<String, dynamic> _$HeartRateToJson(HeartRate instance) => <String, dynamic>{
      'ID': instance.iD,
      'ActvId': instance.actvId,
      'HR': instance.hR,
      'TimeStamp': instance.timeStamp,
      'Speed': instance.speed,
      'Elevation': instance.elevation,
      'LocationData': instance.locationData?.toJson(),
    };
