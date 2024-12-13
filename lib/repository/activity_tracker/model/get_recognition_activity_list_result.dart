import 'package:health_gauge/screens/map_screen/model/image_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_recognition_activity_list_result.g.dart';

@JsonSerializable()
class GetRecognitionActivityListResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<GetRecognitionActivityListData>? data;

  GetRecognitionActivityListResult({
    this.result,
    this.response,
    this.data,
  });

  factory GetRecognitionActivityListResult.fromJson(
      Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') && srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    var result = _$GetRecognitionActivityListResultFromJson(srcJson);
    return result;
  }

  Map<String, dynamic> toJson() =>
      _$GetRecognitionActivityListResultToJson(this);
}

@JsonSerializable()
class GetRecognitionActivityListData extends Object {
  @JsonKey(name: 'Aid')
  int? aid;

  @JsonKey(name: 'Id')
  String? id;

  @JsonKey(name: 'Title')
  String? title;

  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'LocationData')
  List<LocationData>? locationData;

  @JsonKey(name: 'StartTime')
  String? startTime;

  @JsonKey(name: 'EndTime')
  String? endTime;

  @JsonKey(name: 'HeartRate')
  List<HeartRate>? heartRate;

  @JsonKey(name: 'Calories')
  int? calories;

  @JsonKey(name: 'StepsData')
  int? stepsData;

  @JsonKey(name: 'Type')
  String? type;

  @JsonKey(name: 'ImageString')
  String? imageString;

  @JsonKey(name: 'Desc')
  String? desc;

  @JsonKey(name: 'ImageList')
  List<ImageModel>? imageList;

  @JsonKey(name: 'ActivityIntensity')
  String? activityIntensity;

  @JsonKey(name: 'TypeTitle')
  String? typeTitle;

  @JsonKey(name: 'Name')
  String? name;

  @JsonKey(name: 'TotalTime')
  String? totalTime;

  @JsonKey(name: 'ShareWith')
  String? shareWith;

  @JsonKey(name: 'unit')
  int? unit;
  GetRecognitionActivityListData(
      {this.aid,
      this.id,
      this.title,
      this.userID,
      this.locationData,
      this.startTime,
      this.endTime,
      this.heartRate,
      this.calories,
      this.stepsData,
      this.type,
      this.imageString,
      this.desc,
      this.activityIntensity,
      this.imageList,
      this.name,
      this.typeTitle,
      this.totalTime,
      this.shareWith,
      this.unit});

  factory GetRecognitionActivityListData.fromJson(
          Map<String, dynamic> srcJson) =>
      _$GetRecognitionActivityListDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetRecognitionActivityListDataToJson(this);
}

@JsonSerializable()
class LocationData extends Object {
  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'ActvId')
  int? actvId;

  @JsonKey(name: 'Latitude')
  String? latitude;

  @JsonKey(name: 'Longitude')
  String? longitude;

  @JsonKey(name: 'Accuracy')
  String? accuracy;

  @JsonKey(name: 'Altitude')
  String? altitude;

  @JsonKey(name: 'Speed')
  double? speed;

  @JsonKey(name: 'SpeedAccuracy')
  double? speedAccuracy;

  @JsonKey(name: 'Heading')
  String? heading;

  @JsonKey(name: 'Time')
  String? time;

  LocationData({
    this.iD,
    this.actvId,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.altitude,
    this.speed,
    this.speedAccuracy,
    this.heading,
    this.time,
  });

  factory LocationData.fromJson(Map<String, dynamic> srcJson) =>
      _$LocationDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
}

@JsonSerializable()
class HeartRate extends Object {
  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'ActvId')
  int? actvId;

  @JsonKey(name: 'HR')
  int? hR;

  @JsonKey(name: 'TimeStamp')
  String? timeStamp;

  @JsonKey(name: 'Speed')
  String? speed;

  @JsonKey(name: 'Elevation')
  String? elevation;

  @JsonKey(name: 'LocationData')
  LocationData? locationData;

  HeartRate({
    this.iD,
    this.actvId,
    this.hR,
    this.timeStamp,
    this.locationData,
    this.elevation,
    this.speed,
  });

  factory HeartRate.fromJson(Map<String, dynamic> srcJson) =>
      _$HeartRateFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HeartRateToJson(this);
}
