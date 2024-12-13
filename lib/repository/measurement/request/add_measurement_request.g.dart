// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_measurement_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddMeasurementRequest _$AddMeasurementRequestFromJson(Map json) =>
    AddMeasurementRequest(
      birthdate: json['birthdate'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$AddMeasurementRequestToJson(
        AddMeasurementRequest instance) =>
    <String, dynamic>{
      'birthdate': instance.birthdate,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

Data _$DataFromJson(Map json) => Data(
      bgManual: json['bg_manual'] as int?,
      demographics: json['demographics'] == null
          ? null
          : Demographics.fromJson(
              Map<String, dynamic>.from(json['demographics'] as Map)),
      deviceId: json['device_id'] as String?,
      deviceType: json['device_type'] as String?,
      diasHealthgauge: json['dias_healthgauge'] as int?,
      o2Manual: json['o2_manual'] as int?,
      schema: json['schema'] as String?,
      sysHealthgauge: json['sys_healthgauge'] as int?,
      username: json['username'] as String?,
      modelId: json['model_id'] as String?,
      userID: json['userID'] as String?,
      rawEcg: (json['raw_ecg'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      rawPpg: (json['raw_ppg'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      filteredEcgPoints: (json['filteredEcgPoints'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      filteredPpgPoints: (json['filteredPpgPoints'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      rawTimes: json['raw_times'] as List<dynamic>?,
      hrvDevice: json['hrv_device'] as int?,
      diasDevice: json['dias_device'] as int?,
      hrDevice: json['hr_device'] as int?,
      sysDevice: json['sys_device'] as int?,
      timestamp: json['timestamp'] as String?,
      sysManual: json['sys_manual'] as int?,
      diasManual: json['dias_manual'] as int?,
      hrManual: json['hr_manual'] as int?,
      ecgElapsedTime: (json['ecg_elapsed_time'] as List<dynamic>?)
          ?.map((e) => e as int?)
          .toList(),
      ppgElapsedTime: (json['ppg_elapsed_time'] as List<dynamic>?)
          ?.map((e) => e as int?)
          .toList(),
      zeroEcg: (json['zero_ecg'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      zeroPpg: (json['zero_ppg'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      isCalibration: json['IsCalibration'] as bool?,
      isForTimeBasedPpg: json['isForTimeBasedPpg'] as bool?,
      isForTraining: json['isForTraining'] as bool?,
      isAISelected: json['isAISelected'] as bool?,
      IsResearcher: json['IsResearcher'] as bool?,
      isForOscillometric: json['isForOscillometric'] as bool?,
      isFromCamera: json['IsFromCamera'] as bool?,
      isSavedFromOscillometric: json['isSavedFromOscillometric'] as bool?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'bg_manual': instance.bgManual,
      'demographics': instance.demographics?.toJson(),
      'device_id': instance.deviceId,
      'device_type': instance.deviceType,
      'dias_healthgauge': instance.diasHealthgauge,
      'o2_manual': instance.o2Manual,
      'schema': instance.schema,
      'sys_healthgauge': instance.sysHealthgauge,
      'username': instance.username,
      'model_id': instance.modelId,
      'userID': instance.userID,
      'raw_ecg': instance.rawEcg,
      'raw_ppg': instance.rawPpg,
      'filteredEcgPoints': instance.filteredEcgPoints,
      'filteredPpgPoints': instance.filteredPpgPoints,
      'raw_times': instance.rawTimes,
      'hrv_device': instance.hrvDevice,
      'dias_device': instance.diasDevice,
      'hr_device': instance.hrDevice,
      'sys_device': instance.sysDevice,
      'timestamp': instance.timestamp,
      'sys_manual': instance.sysManual,
      'dias_manual': instance.diasManual,
      'hr_manual': instance.hrManual,
      'ecg_elapsed_time': instance.ecgElapsedTime,
      'ppg_elapsed_time': instance.ppgElapsedTime,
      'zero_ecg': instance.zeroEcg,
      'zero_ppg': instance.zeroPpg,
      'IsCalibration': instance.isCalibration,
      'isForTimeBasedPpg': instance.isForTimeBasedPpg,
      'isForTraining': instance.isForTraining,
      'isAISelected': instance.isAISelected,
      'IsResearcher': instance.IsResearcher,
      'isForOscillometric': instance.isForOscillometric,
      'IsFromCamera': instance.isFromCamera,
      'isSavedFromOscillometric': instance.isSavedFromOscillometric,
    };

Demographics _$DemographicsFromJson(Map json) => Demographics(
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      height: json['height'] as int?,
      weight: json['weight'] as int?,
    );

Map<String, dynamic> _$DemographicsToJson(Demographics instance) =>
    <String, dynamic>{
      'age': instance.age,
      'gender': instance.gender,
      'height': instance.height,
      'weight': instance.weight,
    };
