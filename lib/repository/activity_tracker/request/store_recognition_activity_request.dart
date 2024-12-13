import 'package:health_gauge/screens/map_screen/model/image_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'store_recognition_activity_request.g.dart';

@JsonSerializable()
class StoreRecognitionActivityRequest extends Object {
  @JsonKey(name: 'Id')
  String? id;

  @JsonKey(name: 'userId')
  String? userId;

  @JsonKey(name: 'startTime')
  int? startTime;

  @JsonKey(name: 'endTime')
  int? endTime;

  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'desc')
  String? desc;

  @JsonKey(name: 'activityIntensity')
  double? activityIntensity;

  @JsonKey(name: 'typeTitle')
  String? typeTitle;

  @JsonKey(name: 'imageList')
  List<ImageModel>? imageList;

  @JsonKey(name: 'heartRate')
  List<HeartRate>? heartRate;

  @JsonKey(name: 'locationData')
  List<LocationData>? locationData;

  @JsonKey(name: 'totalTime')
  int? totalTime;

  StoreRecognitionActivityRequest({
    this.id,
    this.userId,
    this.startTime,
    this.endTime,
    this.type,
    this.title,
    this.desc,
    this.activityIntensity,
    this.typeTitle,
    this.imageList,
    this.heartRate,
    this.locationData,
  });

  factory StoreRecognitionActivityRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$StoreRecognitionActivityRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$StoreRecognitionActivityRequestToJson(this);
}

@JsonSerializable()
class HeartRate extends Object {
  @JsonKey(name: 'hr')
  int? hr;

  @JsonKey(name: 'timeStamp')
  double? timeStamp;

  @JsonKey(name: 'locationData')
  LocationData? locationData;

  @JsonKey(name: 'speed')
  double? speed;

  @JsonKey(name: 'elevation')
  double? elevation;

  HeartRate(
    this.hr,
    this.timeStamp,
    this.locationData,
    this.speed,
    this.elevation,
  );

  factory HeartRate.fromJson(Map<String, dynamic> srcJson) =>
      _$HeartRateFromJson(srcJson);

  Map<String, dynamic> toJson() => _$HeartRateToJson(this);
}

@JsonSerializable()
class LocationData extends Object {
  @JsonKey(name: 'savedName')
  String? savedName;

  @JsonKey(name: 'locationName')
  String? locationName;

  @JsonKey(name: 'locationAddress')
  String? locationAddress;

  @JsonKey(name: 'locationFullAddress')
  String? locationFullAddress;

  @JsonKey(name: 'latitude')
  double? latitude;

  @JsonKey(name: 'longitude')
  double? longitude;

  @JsonKey(name: 'notes')
  String? notes;

  @JsonKey(name: 'placesId')
  String? placesId;

  @JsonKey(name: 'altitude')
  double? altitude;

  @JsonKey(name: 'accuracy')
  double? accuracy;

  @JsonKey(name: 'heading')
  double? heading;

  @JsonKey(name: 'speed')
  double? speed;

  @JsonKey(name: 'speedAccuracy')
  double? speedAccuracy;

  @JsonKey(name: 'time')
  double? time;

  LocationData({
    this.savedName,
    this.locationName,
    this.locationAddress,
    this.locationFullAddress,
    this.latitude,
    this.longitude,
    this.notes,
    this.placesId,
    this.altitude,
    this.accuracy,
    this.heading,
    this.speed,
    this.speedAccuracy,
    this.time,
  });

  factory LocationData.fromJson(Map<String, dynamic> srcJson) =>
      _$LocationDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
}
