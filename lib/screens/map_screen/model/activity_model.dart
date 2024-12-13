import 'package:health_gauge/repository/activity_tracker/model/get_recognition_activity_list_result.dart';
import 'package:health_gauge/screens/map_screen/model/heart_rate_model.dart';
import 'package:health_gauge/screens/map_screen/model/image_model.dart';
import 'package:health_gauge/services/location/model/location_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_model.g.dart';

@JsonSerializable()
class ActivityModel extends Object {
  @JsonKey(name: 'Id')
  String? id;

  @JsonKey(name: 'userId')
  String? userId;

  @JsonKey(name: 'imageString')
  String? imageString;

  @JsonKey(name: 'startTime')
  int? startTime;

  @JsonKey(name: 'endTime')
  int? endTime;

  @JsonKey(name: 'totalTime')
  int? totalTime;

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
  List<ImageModel>? imageModelList;

  @JsonKey(name: 'heartRate')
  List<HeartRateModel>? heartRateModel;

  @JsonKey(name: 'locationData')
  List<LocationAddressModel>? locationList;

  ActivityModel(
      {this.id,
      this.userId,
      this.imageString,
      this.startTime,
      this.endTime,
      this.totalTime,
      this.type,
      this.title,
      this.desc,
      this.activityIntensity,
      this.typeTitle,
      this.imageModelList,
      this.heartRateModel,
      this.locationList});

  factory ActivityModel.fromJson(Map<String, dynamic> srcJson) =>
      _$ActivityModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);

  static ActivityModel mapper(GetRecognitionActivityListData obj) {
    var model = ActivityModel();
    model
      ..userId = obj.userID.toString()
      ..totalTime = int.parse(obj.totalTime ?? '0')
      ..typeTitle = obj.typeTitle
      ..type = obj.type
      ..activityIntensity = double.parse(obj.activityIntensity ?? '0.0')
      ..desc = obj.desc
      ..imageString = obj.imageString
      ..imageModelList = obj.imageList
      ..id = obj.id
      ..startTime = int.parse(
          obj.startTime ?? DateTime.now().millisecondsSinceEpoch.toString())
      ..endTime = int.parse(
          obj.endTime ?? DateTime.now().millisecondsSinceEpoch.toString())
      ..locationList =
          obj.locationData?.map(LocationAddressModel.mapper).toList()
      ..heartRateModel = obj.heartRate?.map(HeartRateModel.mapper).toList()
      ..title = obj.title;
    return model;
  }
}
