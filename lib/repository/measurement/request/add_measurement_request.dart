import 'package:json_annotation/json_annotation.dart';

part 'add_measurement_request.g.dart';

@JsonSerializable()
class AddMeasurementRequest extends Object {
  @JsonKey(name: 'birthdate')
  String? birthdate;

  @JsonKey(name: 'data')
  List<Data>? data;

  AddMeasurementRequest({
    this.birthdate,
    this.data,
  });

  factory AddMeasurementRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$AddMeasurementRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddMeasurementRequestToJson(this);
}

@JsonSerializable()
class Data extends Object {
  @JsonKey(name: 'bg_manual')
  int? bgManual;

  @JsonKey(name: 'demographics')
  Demographics? demographics;

  @JsonKey(name: 'device_id')
  String? deviceId;

  @JsonKey(name: 'device_type')
  String? deviceType;

  @JsonKey(name: 'dias_healthgauge')
  int? diasHealthgauge;

  @JsonKey(name: 'o2_manual')
  int? o2Manual;

  @JsonKey(name: 'schema')
  String? schema;

  @JsonKey(name: 'sys_healthgauge')
  int? sysHealthgauge;

  @JsonKey(name: 'username')
  String? username;

  @JsonKey(name: 'model_id')
  String? modelId;

  @JsonKey(name: 'userID')
  String? userID;

  @JsonKey(name: 'raw_ecg')
  List<double>? rawEcg;

  @JsonKey(name: 'raw_ppg')
  List<double>? rawPpg;

  @JsonKey(name: 'filteredEcgPoints')
  List<double>? filteredEcgPoints;

  @JsonKey(name: 'filteredPpgPoints')
  List<double>? filteredPpgPoints;

  @JsonKey(name: 'raw_times')
  List<dynamic>? rawTimes;

  @JsonKey(name: 'hrv_device')
  int? hrvDevice;

  @JsonKey(name: 'dias_device')
  int? diasDevice;

  @JsonKey(name: 'hr_device')
  int? hrDevice;

  @JsonKey(name: 'sys_device')
  int? sysDevice;

  @JsonKey(name: 'timestamp')
  String? timestamp;

  @JsonKey(name: 'sys_manual')
  int? sysManual;

  @JsonKey(name: 'dias_manual')
  int? diasManual;

  @JsonKey(name: 'hr_manual')
  int? hrManual;

  @JsonKey(name: 'ecg_elapsed_time')
  List<int?>? ecgElapsedTime;

  @JsonKey(name: 'ppg_elapsed_time')
  List<int?>? ppgElapsedTime;

  @JsonKey(name: 'zero_ecg')
  List<double>? zeroEcg;

  @JsonKey(name: 'zero_ppg')
  List<double>? zeroPpg;

  @JsonKey(name: 'IsCalibration')
  bool? isCalibration;

  @JsonKey(name: 'isForTimeBasedPpg')
  bool? isForTimeBasedPpg;

  @JsonKey(name: 'isForTraining')
  bool? isForTraining;

  @JsonKey(name: 'isAISelected')
  bool? isAISelected;

  @JsonKey(name: 'IsResearcher')
  bool? IsResearcher;

  @JsonKey(name: 'isForOscillometric')
  bool? isForOscillometric;

  @JsonKey(name: 'IsFromCamera')
  bool? isFromCamera;

  @JsonKey(name:'isSavedFromOscillometric')
  bool? isSavedFromOscillometric;
  Data({
    this.bgManual,
    this.demographics,
    this.deviceId,
    this.deviceType,
    this.diasHealthgauge,
    this.o2Manual,
    this.schema,
    this.sysHealthgauge,
    this.username,
    this.modelId,
    this.userID,
    this.rawEcg,
    this.rawPpg,
    this.filteredEcgPoints,
    this.filteredPpgPoints,
    this.rawTimes,
    this.hrvDevice,
    this.diasDevice,
    this.hrDevice,
    this.sysDevice,
    this.timestamp,
    this.sysManual,
    this.diasManual,
    this.hrManual,
    this.ecgElapsedTime,
    this.ppgElapsedTime,
    this.zeroEcg,
    this.zeroPpg,
    this.isCalibration,
    this.isForTimeBasedPpg,
    this.isForTraining,
    this.isAISelected,
    this.IsResearcher,
    this.isForOscillometric,
    this.isFromCamera,
    this.isSavedFromOscillometric
  });

  factory Data.fromJson(Map<String, dynamic> srcJson) =>
      _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Demographics extends Object {
  @JsonKey(name: 'age')
  int? age;

  @JsonKey(name: 'gender')
  String? gender;

  @JsonKey(name: 'height')
  int? height;

  @JsonKey(name: 'weight')
  int? weight;

  Demographics({
    this.age,
    this.gender,
    this.height,
    this.weight,
  });

  factory Demographics.fromJson(Map<String, dynamic> srcJson) =>
      _$DemographicsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DemographicsToJson(this);
}
