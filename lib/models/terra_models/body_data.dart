import 'package:health_gauge/models/terra_models/glucose_data.dart';
import 'package:health_gauge/models/terra_models/heartrate_data.dart';
import 'package:health_gauge/models/terra_models/hrv_data.dart';
import 'package:health_gauge/models/terra_models/oxygen_data.dart';
import 'package:health_gauge/models/terra_models/temperature_data.dart';

class BodyData {
  BodyData({
      this.data, 
      this.user, 
      this.type,});

  BodyData.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(BodyDataModel.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    type = json['type'];
  }
  List<BodyDataModel>? data;
  User? user;
  String? type;
BodyData copyWith({  List<BodyDataModel>? data,
  User? user,
  String? type,
}) => BodyData(  data: data ?? this.data,
  user: user ?? this.user,
  type: type ?? this.type,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['type'] = type;
    return map;
  }

}

class User {
  User({
      this.userId, 
      this.referenceId, 
      this.scopes, 
      this.provider, 
      this.lastWebhookUpdate,});

  User.fromJson(dynamic json) {
    userId = json['user_id'];
    referenceId = json['reference_id'];
    scopes = json['scopes'];
    provider = json['provider'];
    lastWebhookUpdate = json['last_webhook_update'];
  }
  String? userId;
  dynamic referenceId;
  dynamic scopes;
  String? provider;
  dynamic lastWebhookUpdate;
User copyWith({  String? userId,
  dynamic referenceId,
  dynamic scopes,
  String? provider,
  dynamic lastWebhookUpdate,
}) => User(  userId: userId ?? this.userId,
  referenceId: referenceId ?? this.referenceId,
  scopes: scopes ?? this.scopes,
  provider: provider ?? this.provider,
  lastWebhookUpdate: lastWebhookUpdate ?? this.lastWebhookUpdate,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['reference_id'] = referenceId;
    map['scopes'] = scopes;
    map['provider'] = provider;
    map['last_webhook_update'] = lastWebhookUpdate;
    return map;
  }

}

class BodyDataModel {
  BodyDataModel({
      this.bloodPressureData, 
      this.glucoseData,
      this.measurementsData, 
      this.heartData,
      this.metadata, 
      this.temperatureData, 
      this.oxygenData, 
      this.deviceData,});

  BodyDataModel.fromJson(dynamic json) {
    bloodPressureData = json['blood_pressure_data'] != null ? BloodPressureData.fromJson(json['blood_pressure_data']) : null;
    glucoseData = json['glucose_data'] != null ? GlucoseData.fromJson(json['glucose_data']) : null;
    measurementsData = json['measurements_data'] != null ? MeasurementsData.fromJson(json['measurements_data']) : null;
    heartData = json['heart_data'] != null ? HeartData.fromJson(json['heart_data']) : null;
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    temperatureData = json['temperature_data'] != null ? TemperatureData.fromJson(json['temperature_data']) : null;
    oxygenData = json['oxygen_data'] != null ? OxygenData.fromJson(json['oxygen_data']) : null;
    deviceData = json['device_data'] != null ? DeviceData.fromJson(json['device_data']) : null;
  }
  BloodPressureData? bloodPressureData;
  GlucoseData? glucoseData;
  MeasurementsData? measurementsData;
  HeartData? heartData;
  Metadata? metadata;
  TemperatureData? temperatureData;
  OxygenData? oxygenData;
  DeviceData? deviceData;
BodyDataModel copyWith({  BloodPressureData? bloodPressureData,
  GlucoseData? glucoseData,
  MeasurementsData? measurementsData,
  HeartData? heartData,
  Metadata? metadata,
  TemperatureData? temperatureData,
  OxygenData? oxygenData,
  DeviceData? deviceData,
}) => BodyDataModel(  bloodPressureData: bloodPressureData ?? this.bloodPressureData,
  glucoseData: glucoseData ?? this.glucoseData,
  measurementsData: measurementsData ?? this.measurementsData,
  heartData: heartData ?? this.heartData,
  metadata: metadata ?? this.metadata,
  temperatureData: temperatureData ?? this.temperatureData,
  oxygenData: oxygenData ?? this.oxygenData,
  deviceData: deviceData ?? this.deviceData,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bloodPressureData != null) {
      map['blood_pressure_data'] = bloodPressureData?.toJson();
    }

    if (glucoseData != null) {
      map['glucose_data'] = glucoseData?.toJson();
    }
    if (measurementsData != null) {
      map['measurements_data'] = measurementsData?.toJson();
    }

    if (heartData != null) {
      map['heart_data'] = heartData?.toJson();
    }
    if (metadata != null) {
      map['metadata'] = metadata?.toJson();
    }
    if (temperatureData != null) {
      map['temperature_data'] = temperatureData?.toJson();
    }
    if (oxygenData != null) {
      map['oxygen_data'] = oxygenData?.toJson();
    }
    if (deviceData != null) {
      map['device_data'] = deviceData?.toJson();
    }
    return map;
  }

}

class DeviceData {
  DeviceData({
      this.name, 
      this.hardwareVersion, 
      this.sensorState,
      this.softwareVersion, 
      this.manufacturer, 
      this.serialNumber, 
      this.activationTimestamp,});

  DeviceData.fromJson(dynamic json) {
    name = json['name'];
    hardwareVersion = json['hardware_version'];

    sensorState = json['sensor_state'];
    softwareVersion = json['software_version'];
    manufacturer = json['manufacturer'];
    serialNumber = json['serial_number'];
    activationTimestamp = json['activation_timestamp'];
  }
  dynamic name;
  dynamic hardwareVersion;
  dynamic sensorState;
  dynamic softwareVersion;
  dynamic manufacturer;
  dynamic serialNumber;
  dynamic activationTimestamp;
DeviceData copyWith({  dynamic name,
  dynamic hardwareVersion,
  List<dynamic>? otherDevices,
  dynamic sensorState,
  dynamic softwareVersion,
  dynamic manufacturer,
  dynamic serialNumber,
  dynamic activationTimestamp,
}) => DeviceData(  name: name ?? this.name,
  hardwareVersion: hardwareVersion ?? this.hardwareVersion,
  sensorState: sensorState ?? this.sensorState,
  softwareVersion: softwareVersion ?? this.softwareVersion,
  manufacturer: manufacturer ?? this.manufacturer,
  serialNumber: serialNumber ?? this.serialNumber,
  activationTimestamp: activationTimestamp ?? this.activationTimestamp,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['hardware_version'] = hardwareVersion;

    map['sensor_state'] = sensorState;
    map['software_version'] = softwareVersion;
    map['manufacturer'] = manufacturer;
    map['serial_number'] = serialNumber;
    map['activation_timestamp'] = activationTimestamp;
    return map;
  }

}

class OxygenData {
  OxygenData({
      this.avgSaturationPercentage, 
      this.vo2Samples, 
      this.saturationSamples, 
      this.vo2maxMlPerMinPerKg,});

  OxygenData.fromJson(dynamic json) {
    avgSaturationPercentage = json['avg_saturation_percentage'];
    if (json['vo2_samples'] != null) {
      vo2Samples = [];
      json['vo2_samples'].forEach((v) {
        vo2Samples?.add(OxygenModel.fromJson(v));
      });
    }
    if (json['saturation_samples'] != null) {
      saturationSamples = [];
      json['saturation_samples'].forEach((v) {
        saturationSamples?.add(OxygenModel.fromJson(v));
      });
    }
    vo2maxMlPerMinPerKg = json['vo2max_ml_per_min_per_kg'];
  }
  num? avgSaturationPercentage;
  List<OxygenModel>? vo2Samples;
  List<OxygenModel>? saturationSamples;
  dynamic vo2maxMlPerMinPerKg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['avg_saturation_percentage'] = avgSaturationPercentage;
    if (vo2Samples != null) {
      map['vo2_samples'] = vo2Samples?.map((v) => v.toJson()).toList();
    }
    if (saturationSamples != null) {
      map['saturation_samples'] = saturationSamples?.map((v) => v.toJson()).toList();
    }
    map['vo2max_ml_per_min_per_kg'] = vo2maxMlPerMinPerKg;
    return map;
  }

}

class TemperatureData {
  TemperatureData({
      this.bodyTemperatureSamples, 
      this.skinTemperatureSamples, 
      this.ambientTemperatureSamples,});

  TemperatureData.fromJson(dynamic json) {
    if (json['body_temperature_samples'] != null) {
      bodyTemperatureSamples = [];
      json['body_temperature_samples'].forEach((v) {
        bodyTemperatureSamples?.add(TemperatureModel.fromJson(v));
      });
    }
    if (json['skin_temperature_samples'] != null) {
      skinTemperatureSamples = [];
      json['skin_temperature_samples'].forEach((v) {
        skinTemperatureSamples?.add(TemperatureModel.fromJson(v));
      });
    }
    if (json['ambient_temperature_samples'] != null) {
      ambientTemperatureSamples = [];
      json['ambient_temperature_samples'].forEach((v) {
        ambientTemperatureSamples?.add(TemperatureModel.fromJson(v));
      });
    }
  }
  List<TemperatureModel>? bodyTemperatureSamples;
  List<TemperatureModel>? skinTemperatureSamples;
  List<TemperatureModel>? ambientTemperatureSamples;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bodyTemperatureSamples != null) {
      map['body_temperature_samples'] = bodyTemperatureSamples?.map((v) => v.toJson()).toList();
    }
    if (skinTemperatureSamples != null) {
      map['skin_temperature_samples'] = skinTemperatureSamples?.map((v) => v.toJson()).toList();
    }
    if (ambientTemperatureSamples != null) {
      map['ambient_temperature_samples'] = ambientTemperatureSamples?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class Metadata {
  Metadata({
      this.endTime, 
      this.startTime,});

  Metadata.fromJson(dynamic json) {
    endTime = json['end_time'];
    startTime = json['start_time'];
  }
  String? endTime;
  String? startTime;
Metadata copyWith({  String? endTime,
  String? startTime,
}) => Metadata(  endTime: endTime ?? this.endTime,
  startTime: startTime ?? this.startTime,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['end_time'] = endTime;
    map['start_time'] = startTime;
    return map;
  }

}

class HeartData {
  HeartData({

      this.heartRateData,});

  HeartData.fromJson(dynamic json) {

    heartRateData = json['heart_rate_data'] != null ? HeartRateData.fromJson(json['heart_rate_data']) : null;

  }

  HeartRateData? heartRateData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (heartRateData != null) {
      map['heart_rate_data'] = heartRateData?.toJson();
    }
    return map;
  }

}

class HeartRateData {
  HeartRateData({
      this.detailed, 
      this.summary,});

  HeartRateData.fromJson(dynamic json) {
    detailed = json['detailed'] != null ? Detailed.fromJson(json['detailed']) : null;
    summary = json['summary'] != null ? Summary.fromJson(json['summary']) : null;
  }
  Detailed? detailed;
  Summary? summary;
HeartRateData copyWith({  Detailed? detailed,
  Summary? summary,
}) => HeartRateData(  detailed: detailed ?? this.detailed,
  summary: summary ?? this.summary,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (detailed != null) {
      map['detailed'] = detailed?.toJson();
    }
    if (summary != null) {
      map['summary'] = summary?.toJson();
    }
    return map;
  }

}

class Summary {
  Summary({
      this.maxHrBpm, 
      this.avgHrvSdnn, 
      this.avgHrvRmssd, 
      this.userMaxHrBpm, 
      this.avgHrBpm,
      this.restingHrBpm, 
      this.minHrBpm,});

  Summary.fromJson(dynamic json) {
    maxHrBpm = json['max_hr_bpm'];
    avgHrvSdnn = json['avg_hrv_sdnn'];
    avgHrvRmssd = json['avg_hrv_rmssd'];
    userMaxHrBpm = json['user_max_hr_bpm'];

    avgHrBpm = json['avg_hr_bpm'];
    restingHrBpm = json['resting_hr_bpm'];
    minHrBpm = json['min_hr_bpm'];
  }
  dynamic maxHrBpm;
  dynamic avgHrvSdnn;
  dynamic avgHrvRmssd;
  dynamic userMaxHrBpm;
  dynamic avgHrBpm;
  dynamic restingHrBpm;
  dynamic minHrBpm;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['max_hr_bpm'] = maxHrBpm;
    map['avg_hrv_sdnn'] = avgHrvSdnn;
    map['avg_hrv_rmssd'] = avgHrvRmssd;
    map['user_max_hr_bpm'] = userMaxHrBpm;

    map['avg_hr_bpm'] = avgHrBpm;
    map['resting_hr_bpm'] = restingHrBpm;
    map['min_hr_bpm'] = minHrBpm;
    return map;
  }

}

class Detailed {
  Detailed({
      this.hrSamples, 
      this.hrvSamplesSdnn, 
      this.hrvSamplesRmssd,});

  Detailed.fromJson(dynamic json) {
    if (json['hr_samples'] != null) {
      hrSamples = [];
      json['hr_samples'].forEach((v) {
        hrSamples?.add(HeartrateModel.fromJson(v));
      });
    }
    if (json['hrv_samples_sdnn'] != null) {
      hrvSamplesSdnn = [];
      json['hrv_samples_sdnn'].forEach((v) {
        hrvSamplesSdnn?.add(HrvModel.fromJson(v));
      });
    }
    if (json['hrv_samples_rmssd'] != null) {
      hrvSamplesRmssd = [];
      json['hrv_samples_rmssd'].forEach((v) {
        hrvSamplesRmssd?.add(HrvModel.fromJson(v));
      });
    }
  }
  List<HeartrateModel>? hrSamples;
  List<HrvModel>? hrvSamplesSdnn;
  List<HrvModel>? hrvSamplesRmssd;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (hrSamples != null) {
      map['hr_samples'] = hrSamples?.map((v) => v.toJson()).toList();
    }
    if (hrvSamplesSdnn != null) {
      map['hrv_samples_sdnn'] = hrvSamplesSdnn?.map((v) => v.toJson()).toList();
    }
    if (hrvSamplesRmssd != null) {
      map['hrv_samples_rmssd'] = hrvSamplesRmssd?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class MeasurementsData {
  MeasurementsData({
      this.measurements,});

  MeasurementsData.fromJson(dynamic json) {
    if (json['measurements'] != null) {
      measurements = [];
      json['measurements'].forEach((v) {
        measurements?.add(Measurements.fromJson(v));
      });
    }
  }
  List<Measurements>? measurements;
MeasurementsData copyWith({  List<Measurements>? measurements,
}) => MeasurementsData(  measurements: measurements ?? this.measurements,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (measurements != null) {
      map['measurements'] = measurements?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Measurements {
  Measurements({
      this.skinFoldMm, 
      this.heightCm, 
      this.boneMassG, 
      this.weightKg, 
      this.insulinType, 
      this.leanMassG, 
      this.measurementTime, 
      this.bodyfatPercentage, 
      this.insulinUnits, 
      this.bmi, 
      this.rmr, 
      this.muscleMassG, 
      this.waterPercentage, 
      this.bmr, 
      this.urineColor, 
      this.estimatedFitnessAge,});

  Measurements.fromJson(dynamic json) {
    skinFoldMm = json['skin_fold_mm'];
    heightCm = json['height_cm'];
    boneMassG = json['bone_mass_g'];
    weightKg = json['weight_kg'];
    insulinType = json['insulin_type'];
    leanMassG = json['lean_mass_g'];
    measurementTime = json['measurement_time'];
    bodyfatPercentage = json['bodyfat_percentage'];
    insulinUnits = json['insulin_units'];
    bmi = json['BMI'];
    rmr = json['RMR'];
    muscleMassG = json['muscle_mass_g'];
    waterPercentage = json['water_percentage'];
    bmr = json['BMR'];
    urineColor = json['urine_color'];
    estimatedFitnessAge = json['estimated_fitness_age'];
  }
  dynamic skinFoldMm;
  num? heightCm;
  dynamic boneMassG;
  num? weightKg;
  dynamic insulinType;
  dynamic leanMassG;
  String? measurementTime;
  num? bodyfatPercentage;
  dynamic insulinUnits;
  dynamic bmi;
  dynamic rmr;
  dynamic muscleMassG;
  dynamic waterPercentage;
  num? bmr;
  dynamic urineColor;
  dynamic estimatedFitnessAge;
Measurements copyWith({  dynamic skinFoldMm,
  num? heightCm,
  dynamic boneMassG,
  num? weightKg,
  dynamic insulinType,
  dynamic leanMassG,
  String? measurementTime,
  num? bodyfatPercentage,
  dynamic insulinUnits,
  dynamic bmi,
  dynamic rmr,
  dynamic muscleMassG,
  dynamic waterPercentage,
  num? bmr,
  dynamic urineColor,
  dynamic estimatedFitnessAge,
}) => Measurements(  skinFoldMm: skinFoldMm ?? this.skinFoldMm,
  heightCm: heightCm ?? this.heightCm,
  boneMassG: boneMassG ?? this.boneMassG,
  weightKg: weightKg ?? this.weightKg,
  insulinType: insulinType ?? this.insulinType,
  leanMassG: leanMassG ?? this.leanMassG,
  measurementTime: measurementTime ?? this.measurementTime,
  bodyfatPercentage: bodyfatPercentage ?? this.bodyfatPercentage,
  insulinUnits: insulinUnits ?? this.insulinUnits,
  bmi: bmi ?? this.bmi,
  rmr: rmr ?? this.rmr,
  muscleMassG: muscleMassG ?? this.muscleMassG,
  waterPercentage: waterPercentage ?? this.waterPercentage,
  bmr: bmr ?? this.bmr,
  urineColor: urineColor ?? this.urineColor,
  estimatedFitnessAge: estimatedFitnessAge ?? this.estimatedFitnessAge,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['skin_fold_mm'] = skinFoldMm;
    map['height_cm'] = heightCm;
    map['bone_mass_g'] = boneMassG;
    map['weight_kg'] = weightKg;
    map['insulin_type'] = insulinType;
    map['lean_mass_g'] = leanMassG;
    map['measurement_time'] = measurementTime;
    map['bodyfat_percentage'] = bodyfatPercentage;
    map['insulin_units'] = insulinUnits;
    map['BMI'] = bmi;
    map['RMR'] = rmr;
    map['muscle_mass_g'] = muscleMassG;
    map['water_percentage'] = waterPercentage;
    map['BMR'] = bmr;
    map['urine_color'] = urineColor;
    map['estimated_fitness_age'] = estimatedFitnessAge;
    return map;
  }

}

class GlucoseData {
  GlucoseData({
      this.detailedBloodGlucoseSamples, 
      this.dayAvgBloodGlucoseMgPerDL, 
      this.bloodGlucoseSamples,});

  GlucoseData.fromJson(dynamic json) {
    if (json['detailed_blood_glucose_samples'] != null) {
      detailedBloodGlucoseSamples = [];
      json['detailed_blood_glucose_samples'].forEach((v) {
        detailedBloodGlucoseSamples?.add(GlucoseModel.fromJson(v));
      });
    }
    dayAvgBloodGlucoseMgPerDL = json['day_avg_blood_glucose_mg_per_dL'];
    if (json['blood_glucose_samples'] != null) {
      bloodGlucoseSamples = [];
      json['blood_glucose_samples'].forEach((v) {
        bloodGlucoseSamples?.add(GlucoseModel.fromJson(v));
      });
    }
  }
  List<GlucoseModel>? detailedBloodGlucoseSamples;
  num? dayAvgBloodGlucoseMgPerDL;
  List<GlucoseModel>? bloodGlucoseSamples;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (detailedBloodGlucoseSamples != null) {
      map['detailed_blood_glucose_samples'] = detailedBloodGlucoseSamples?.map((v) => v.toJson()).toList();
    }
    map['day_avg_blood_glucose_mg_per_dL'] = dayAvgBloodGlucoseMgPerDL;
    if (bloodGlucoseSamples != null) {
      map['blood_glucose_samples'] = bloodGlucoseSamples?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class BloodPressureData {
  BloodPressureData({
      this.bloodPressureSamples,});

  BloodPressureData.fromJson(dynamic json) {
    if (json['blood_pressure_samples'] != null) {
      bloodPressureSamples = [];
      json['blood_pressure_samples'].forEach((v) {
        bloodPressureSamples?.add(BloodPressureSamples.fromJson(v));
      });
    }
  }
  List<BloodPressureSamples>? bloodPressureSamples;
BloodPressureData copyWith({  List<BloodPressureSamples>? bloodPressureSamples,
}) => BloodPressureData(  bloodPressureSamples: bloodPressureSamples ?? this.bloodPressureSamples,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bloodPressureSamples != null) {
      map['blood_pressure_samples'] = bloodPressureSamples?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class BloodPressureSamples {
  BloodPressureSamples({
      this.systolicBp, 
      this.timestamp, 
      this.diastolicBp,});

  BloodPressureSamples.fromJson(dynamic json) {
    systolicBp = json['systolic_bp'];
    timestamp = json['timestamp'];
    diastolicBp = json['diastolic_bp'];
  }
  num? systolicBp;
  String? timestamp;
  num? diastolicBp;
BloodPressureSamples copyWith({  num? systolicBp,
  String? timestamp,
  num? diastolicBp,
}) => BloodPressureSamples(  systolicBp: systolicBp ?? this.systolicBp,
  timestamp: timestamp ?? this.timestamp,
  diastolicBp: diastolicBp ?? this.diastolicBp,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['systolic_bp'] = systolicBp;
    map['timestamp'] = timestamp;
    map['diastolic_bp'] = diastolicBp;
    return map;
  }

}