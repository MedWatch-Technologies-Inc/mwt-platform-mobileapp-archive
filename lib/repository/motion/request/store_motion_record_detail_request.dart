import 'package:json_annotation/json_annotation.dart';

part 'store_motion_record_detail_request.g.dart';

@JsonSerializable()
class StoreMotionRecordDetailRequest extends Object {
  @JsonKey(name: 'userid')
  String? userid;

  @JsonKey(name: 'motionCalorie')
  num? motionCalorie;

  @JsonKey(name: 'motionDate')
  String? motionDate;

  @JsonKey(name: 'motionDistance')
  num? motionDistance;

  @JsonKey(name: 'motionSteps')
  int? motionSteps;

  @JsonKey(name: 'data')
  List<dynamic>? data;

  @JsonKey(name: 'motionDateStamp')
  String? motionDateStamp;

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateStamp;

  StoreMotionRecordDetailRequest({
    this.userid,
    this.motionCalorie,
    this.motionDate,
    this.motionDistance,
    this.motionSteps,
    this.data,
    this.motionDateStamp,
    this.createdDateStamp,
  });

  factory StoreMotionRecordDetailRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$StoreMotionRecordDetailRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StoreMotionRecordDetailRequestToJson(this);
}
