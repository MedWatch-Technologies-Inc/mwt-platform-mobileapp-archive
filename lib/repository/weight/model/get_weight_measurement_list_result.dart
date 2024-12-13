import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_weight_measurement_list_result.g.dart';

@JsonSerializable()
class GetWeightMeasurementListResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<WeightMeasurementModel>? data;

  GetWeightMeasurementListResult({
    this.result,
    this.response,
    this.data,
  });

  factory GetWeightMeasurementListResult.fromJson(
      Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$GetWeightMeasurementListResultFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$GetWeightMeasurementListResultToJson(this);
}

@JsonSerializable()
class GetWeightMeasurementListData extends Object {
  @JsonKey(name: 'WeightMeasurementID')
  int? weightMeasurementID;

  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'WeightSum')
  int? weightSum;

  @JsonKey(name: 'BMI')
  double? bMI;

  @JsonKey(name: 'FatRate')
  int? fatRate;

  @JsonKey(name: 'Muscle')
  int? muscle;

  @JsonKey(name: 'Moisture')
  int? moisture;

  @JsonKey(name: 'BoneMass')
  int? boneMass;

  @JsonKey(name: 'SubcutaneousFat')
  int? subcutaneousFat;

  @JsonKey(name: 'BMR')
  int? bMR;

  @JsonKey(name: 'ProteinRate')
  int? proteinRate;

  @JsonKey(name: 'VisceralFat')
  int? visceralFat;

  @JsonKey(name: 'PhysicalAge')
  int? physicalAge;

  @JsonKey(name: 'StandardWeight')
  int? standardWeight;

  @JsonKey(name: 'WeightControl')
  int? weightControl;

  @JsonKey(name: 'FatMass')
  int? fatMass;

  @JsonKey(name: 'WeightWithoutFat')
  int? weightWithoutFat;

  @JsonKey(name: 'MuscleMass')
  int? muscleMass;

  @JsonKey(name: 'ProteinMass')
  int? proteinMass;

  @JsonKey(name: 'FatLevel')
  int? fatLevel;

  @JsonKey(name: 'CreatedDateTime')
  String? createdDateTime;

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  @JsonKey(name: 'IsActive')
  bool? isActive;

  @JsonKey(name: 'IsDelete')
  bool? isDelete;

  GetWeightMeasurementListData({
    this.weightMeasurementID,
    this.userID,
    this.weightSum,
    this.bMI,
    this.fatRate,
    this.muscle,
    this.moisture,
    this.boneMass,
    this.subcutaneousFat,
    this.bMR,
    this.proteinRate,
    this.visceralFat,
    this.physicalAge,
    this.standardWeight,
    this.weightControl,
    this.fatMass,
    this.weightWithoutFat,
    this.muscleMass,
    this.proteinMass,
    this.fatLevel,
    this.createdDateTime,
    this.createdDateTimeStamp,
    this.isActive,
    this.isDelete,
  });

  factory GetWeightMeasurementListData.fromJson(Map<String, dynamic> srcJson) {
    srcJson['CreatedDateTime'] = DateTime.fromMillisecondsSinceEpoch(srcJson['CreatedDateTimeStamp']);
    return  _$GetWeightMeasurementListDataFromJson(srcJson);
  }


  Map<String, dynamic> toJson() => _$GetWeightMeasurementListDataToJson(this);
}
