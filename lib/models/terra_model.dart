/// oxygen_data : {"avg_saturation_percentage":1,"vo2max_ml_per_min_per_kg":1}
/// metadata : {"end_time":"","start_time":""}
/// device_data : {"name":"","hardware_version":"","manufacturer":"","software_version":"","activation_timestamp":"","serial_number":1}
/// scores : {"recovery":1,"activity":1,"sleep":1}
/// distance_data : {"swimming":{"num_strokes":1,"num_laps":1,"pool_length_meters":1},"floors_climbed":1,"elevation":{"loss_actual_meters":1,"min_meters":1,"avg_meters":1,"gain_actual_meters":1,"max_meters":1,"gain_planned_meters":1},"steps":1,"detailed":{"step_samples":[],"distance_samples":[],"elevation_samples":[]},"distance_meters":1}
/// MET_data : {"num_low_intensity_minutes":1,"num_high_intensity_minutes":1,"num_inactive_minutes":1,"num_moderate_intensity_minutes":1,"avg_level":1}
/// calories_data : {"net_intake_calories":1,"BMR_calories":1,"total_burned_calories":1,"net_activity_calories":1}
/// heart_rate_data : {"summary":{"max_hr_bpm":1,"resting_hr_bpm":1,"avg_hrv_rmssd":1,"min_hr_bpm":1,"user_max_hr_bpm":1,"avg_hrv_sdnn":1,"avg_hr_bpm":1},"detailed":{"hr_samples":[],"hrv_samples_sdnn":[],"hrv_samples_rmssd":[]}}
/// active_durations_data : {"activity_seconds":1,"rest_seconds":1,"low_intensity_seconds":1,"vigorous_intensity_seconds":1,"num_continuous_inactive_periods":1,"inactivity_seconds":1,"moderate_intensity_seconds":1}
/// stress_data : {"rest_stress_duration_seconds":1,"stress_duration_seconds":1,"activity_stress_duration_seconds":1,"avg_stress_level":1,"low_stress_duration_seconds":1,"medium_stress_duration_seconds":1,"high_stress_duration_seconds":1,"max_stress_level":1}

class TerraModel {
  TerraModel({
    this.oxygenData,
    this.metadata,
    this.deviceData,
    this.scores,
    this.distanceData,
    this.mETData,
    this.caloriesData,
    this.heartRateData,
    this.activeDurationsData,
    this.stressData,
  });

  TerraModel.fromJson(dynamic json) {
    oxygenData = json['oxygen_data'] != null
        ? OxygenData.fromJson(json['oxygen_data'])
        : null;
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    deviceData = json['device_data'] != null
        ? DeviceData.fromJson(json['device_data'])
        : null;
    scores = json['scores'] != null ? Scores.fromJson(json['scores']) : null;
    distanceData = json['distance_data'] != null
        ? DistanceData.fromJson(json['distance_data'])
        : null;
    mETData =
        json['MET_data'] != null ? MetData.fromJson(json['MET_data']) : null;
    caloriesData = json['calories_data'] != null
        ? CaloriesData.fromJson(json['calories_data'])
        : null;
    heartRateData = json['heart_rate_data'] != null
        ? HeartRateData.fromJson(json['heart_rate_data'])
        : null;
    activeDurationsData = json['active_durations_data'] != null
        ? ActiveDurationsData.fromJson(json['active_durations_data'])
        : null;
    stressData = json['stress_data'] != null
        ? StressData.fromJson(json['stress_data'])
        : null;
  }

  OxygenData? oxygenData;
  Metadata? metadata;
  DeviceData? deviceData;
  Scores? scores;
  DistanceData? distanceData;
  MetData? mETData;
  CaloriesData? caloriesData;
  HeartRateData? heartRateData;
  ActiveDurationsData? activeDurationsData;
  StressData? stressData;

  TerraModel copyWith({
    OxygenData? oxygenData,
    Metadata? metadata,
    DeviceData? deviceData,
    Scores? scores,
    DistanceData? distanceData,
    MetData? mETData,
    CaloriesData? caloriesData,
    HeartRateData? heartRateData,
    ActiveDurationsData? activeDurationsData,
    StressData? stressData,
  }) =>
      TerraModel(
        oxygenData: oxygenData ?? this.oxygenData,
        metadata: metadata ?? this.metadata,
        deviceData: deviceData ?? this.deviceData,
        scores: scores ?? this.scores,
        distanceData: distanceData ?? this.distanceData,
        mETData: mETData ?? this.mETData,
        caloriesData: caloriesData ?? this.caloriesData,
        heartRateData: heartRateData ?? this.heartRateData,
        activeDurationsData: activeDurationsData ?? this.activeDurationsData,
        stressData: stressData ?? this.stressData,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (oxygenData != null) {
      map['oxygen_data'] = oxygenData?.toJson();
    }
    if (metadata != null) {
      map['metadata'] = metadata?.toJson();
    }
    if (deviceData != null) {
      map['device_data'] = deviceData?.toJson();
    }
    if (scores != null) {
      map['scores'] = scores?.toJson();
    }
    if (distanceData != null) {
      map['distance_data'] = distanceData?.toJson();
    }
    if (mETData != null) {
      map['MET_data'] = mETData?.toJson();
    }
    if (caloriesData != null) {
      map['calories_data'] = caloriesData?.toJson();
    }
    if (heartRateData != null) {
      map['heart_rate_data'] = heartRateData?.toJson();
    }
    if (activeDurationsData != null) {
      map['active_durations_data'] = activeDurationsData?.toJson();
    }
    if (stressData != null) {
      map['stress_data'] = stressData?.toJson();
    }
    return map;
  }
}

/// rest_stress_duration_seconds : 1
/// stress_duration_seconds : 1
/// activity_stress_duration_seconds : 1
/// avg_stress_level : 1
/// low_stress_duration_seconds : 1
/// medium_stress_duration_seconds : 1
/// high_stress_duration_seconds : 1
/// max_stress_level : 1

class StressData {
  StressData({
    this.restStressDurationSeconds,
    this.stressDurationSeconds,
    this.activityStressDurationSeconds,
    this.avgStressLevel,
    this.lowStressDurationSeconds,
    this.mediumStressDurationSeconds,
    this.highStressDurationSeconds,
    this.maxStressLevel,
  });

  StressData.fromJson(dynamic json) {
    restStressDurationSeconds = json['rest_stress_duration_seconds'];
    stressDurationSeconds = json['stress_duration_seconds'];
    activityStressDurationSeconds = json['activity_stress_duration_seconds'];
    avgStressLevel = json['avg_stress_level'];
    lowStressDurationSeconds = json['low_stress_duration_seconds'];
    mediumStressDurationSeconds = json['medium_stress_duration_seconds'];
    highStressDurationSeconds = json['high_stress_duration_seconds'];
    maxStressLevel = json['max_stress_level'];
  }

  num? restStressDurationSeconds;
  num? stressDurationSeconds;
  num? activityStressDurationSeconds;
  num? avgStressLevel;
  num? lowStressDurationSeconds;
  num? mediumStressDurationSeconds;
  num? highStressDurationSeconds;
  num? maxStressLevel;

  StressData copyWith({
    num? restStressDurationSeconds,
    num? stressDurationSeconds,
    num? activityStressDurationSeconds,
    num? avgStressLevel,
    num? lowStressDurationSeconds,
    num? mediumStressDurationSeconds,
    num? highStressDurationSeconds,
    num? maxStressLevel,
  }) =>
      StressData(
        restStressDurationSeconds:
            restStressDurationSeconds ?? this.restStressDurationSeconds,
        stressDurationSeconds:
            stressDurationSeconds ?? this.stressDurationSeconds,
        activityStressDurationSeconds:
            activityStressDurationSeconds ?? this.activityStressDurationSeconds,
        avgStressLevel: avgStressLevel ?? this.avgStressLevel,
        lowStressDurationSeconds:
            lowStressDurationSeconds ?? this.lowStressDurationSeconds,
        mediumStressDurationSeconds:
            mediumStressDurationSeconds ?? this.mediumStressDurationSeconds,
        highStressDurationSeconds:
            highStressDurationSeconds ?? this.highStressDurationSeconds,
        maxStressLevel: maxStressLevel ?? this.maxStressLevel,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rest_stress_duration_seconds'] = restStressDurationSeconds;
    map['stress_duration_seconds'] = stressDurationSeconds;
    map['activity_stress_duration_seconds'] = activityStressDurationSeconds;
    map['avg_stress_level'] = avgStressLevel;
    map['low_stress_duration_seconds'] = lowStressDurationSeconds;
    map['medium_stress_duration_seconds'] = mediumStressDurationSeconds;
    map['high_stress_duration_seconds'] = highStressDurationSeconds;
    map['max_stress_level'] = maxStressLevel;
    return map;
  }
}

/// activity_seconds : 1
/// rest_seconds : 1
/// low_intensity_seconds : 1
/// vigorous_intensity_seconds : 1
/// num_continuous_inactive_periods : 1
/// inactivity_seconds : 1
/// moderate_intensity_seconds : 1

class ActiveDurationsData {
  ActiveDurationsData({
    this.activitySeconds,
    this.restSeconds,
    this.lowIntensitySeconds,
    this.vigorousIntensitySeconds,
    this.numContinuousInactivePeriods,
    this.inactivitySeconds,
    this.moderateIntensitySeconds,
  });

  ActiveDurationsData.fromJson(dynamic json) {
    activitySeconds = json['activity_seconds'];
    restSeconds = json['rest_seconds'];
    lowIntensitySeconds = json['low_intensity_seconds'];
    vigorousIntensitySeconds = json['vigorous_intensity_seconds'];
    numContinuousInactivePeriods = json['num_continuous_inactive_periods'];
    inactivitySeconds = json['inactivity_seconds'];
    moderateIntensitySeconds = json['moderate_intensity_seconds'];
  }

  num? activitySeconds;
  num? restSeconds;
  num? lowIntensitySeconds;
  num? vigorousIntensitySeconds;
  num? numContinuousInactivePeriods;
  num? inactivitySeconds;
  num? moderateIntensitySeconds;

  ActiveDurationsData copyWith({
    num? activitySeconds,
    num? restSeconds,
    num? lowIntensitySeconds,
    num? vigorousIntensitySeconds,
    num? numContinuousInactivePeriods,
    num? inactivitySeconds,
    num? moderateIntensitySeconds,
  }) =>
      ActiveDurationsData(
        activitySeconds: activitySeconds ?? this.activitySeconds,
        restSeconds: restSeconds ?? this.restSeconds,
        lowIntensitySeconds: lowIntensitySeconds ?? this.lowIntensitySeconds,
        vigorousIntensitySeconds:
            vigorousIntensitySeconds ?? this.vigorousIntensitySeconds,
        numContinuousInactivePeriods:
            numContinuousInactivePeriods ?? this.numContinuousInactivePeriods,
        inactivitySeconds: inactivitySeconds ?? this.inactivitySeconds,
        moderateIntensitySeconds:
            moderateIntensitySeconds ?? this.moderateIntensitySeconds,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['activity_seconds'] = activitySeconds;
    map['rest_seconds'] = restSeconds;
    map['low_intensity_seconds'] = lowIntensitySeconds;
    map['vigorous_intensity_seconds'] = vigorousIntensitySeconds;
    map['num_continuous_inactive_periods'] = numContinuousInactivePeriods;
    map['inactivity_seconds'] = inactivitySeconds;
    map['moderate_intensity_seconds'] = moderateIntensitySeconds;
    return map;
  }
}

/// summary : {"max_hr_bpm":1,"resting_hr_bpm":1,"avg_hrv_rmssd":1,"min_hr_bpm":1,"user_max_hr_bpm":1,"avg_hrv_sdnn":1,"avg_hr_bpm":1}
/// detailed : {"hr_samples":[],"hrv_samples_sdnn":[],"hrv_samples_rmssd":[]}

class HeartRateData {
  HeartRateData({
    this.summary,
    this.detailed,
  });

  HeartRateData.fromJson(dynamic json) {
    summary =
        json['summary'] != null ? Summary.fromJson(json['summary']) : null;
    detailed = json['detailed'] != null
        ? StepDetailed.fromJson(json['detailed'])
        : null;
  }

  Summary? summary;
  StepDetailed? detailed;

  HeartRateData copyWith({
    Summary? summary,
    StepDetailed? detailed,
  }) =>
      HeartRateData(
        summary: summary ?? this.summary,
        detailed: detailed ?? this.detailed,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (summary != null) {
      map['summary'] = summary?.toJson();
    }
    if (detailed != null) {
      map['detailed'] = detailed?.toJson();
    }
    return map;
  }
}

/// hr_samples : []
/// hrv_samples_sdnn : []
/// hrv_samples_rmssd : []

class HrDetailed {
  HrDetailed({
    this.hrSamples,
    this.hrvSamplesSdnn,
    this.hrvSamplesRmssd,
  });

  HrDetailed.fromJson(dynamic json) {
    if (json['hr_samples'] != null) {
      hrSamples = [];
      json['hr_samples'].forEach((v) {
        hrSamples?.add(v);
      });
    }
    if (json['hrv_samples_sdnn'] != null) {
      hrvSamplesSdnn = [];
      json['hrv_samples_sdnn'].forEach((v) {
        hrvSamplesSdnn?.add(v);
      });
    }
    if (json['hrv_samples_rmssd'] != null) {
      hrvSamplesRmssd = [];
      json['hrv_samples_rmssd'].forEach((v) {
        hrvSamplesRmssd?.add(v);
      });
    }
  }

  List<dynamic>? hrSamples;
  List<dynamic>? hrvSamplesSdnn;
  List<dynamic>? hrvSamplesRmssd;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (hrSamples != null) {
      map['hr_samples'] = hrSamples?.map((v) => v.toJson()).toList();
    }
    if (hrvSamplesSdnn != null) {
      map['hrv_samples_sdnn'] = hrvSamplesSdnn?.map((v) => v.toJson()).toList();
    }
    if (hrvSamplesRmssd != null) {
      map['hrv_samples_rmssd'] =
          hrvSamplesRmssd?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// max_hr_bpm : 1
/// resting_hr_bpm : 1
/// avg_hrv_rmssd : 1
/// min_hr_bpm : 1
/// user_max_hr_bpm : 1
/// avg_hrv_sdnn : 1
/// avg_hr_bpm : 1

class Summary {
  Summary({
    this.maxHrBpm,
    this.restingHrBpm,
    this.avgHrvRmssd,
    this.minHrBpm,
    this.userMaxHrBpm,
    this.avgHrvSdnn,
    this.avgHrBpm,
  });

  Summary.fromJson(dynamic json) {
    maxHrBpm = json['max_hr_bpm'];
    restingHrBpm = json['resting_hr_bpm'];
    avgHrvRmssd = json['avg_hrv_rmssd'];
    minHrBpm = json['min_hr_bpm'];
    userMaxHrBpm = json['user_max_hr_bpm'];
    avgHrvSdnn = json['avg_hrv_sdnn'];
    avgHrBpm = json['avg_hr_bpm'];
  }

  num? maxHrBpm;
  num? restingHrBpm;
  num? avgHrvRmssd;
  num? minHrBpm;
  num? userMaxHrBpm;
  num? avgHrvSdnn;
  num? avgHrBpm;

  Summary copyWith({
    num? maxHrBpm,
    num? restingHrBpm,
    num? avgHrvRmssd,
    num? minHrBpm,
    num? userMaxHrBpm,
    num? avgHrvSdnn,
    num? avgHrBpm,
  }) =>
      Summary(
        maxHrBpm: maxHrBpm ?? this.maxHrBpm,
        restingHrBpm: restingHrBpm ?? this.restingHrBpm,
        avgHrvRmssd: avgHrvRmssd ?? this.avgHrvRmssd,
        minHrBpm: minHrBpm ?? this.minHrBpm,
        userMaxHrBpm: userMaxHrBpm ?? this.userMaxHrBpm,
        avgHrvSdnn: avgHrvSdnn ?? this.avgHrvSdnn,
        avgHrBpm: avgHrBpm ?? this.avgHrBpm,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['max_hr_bpm'] = maxHrBpm;
    map['resting_hr_bpm'] = restingHrBpm;
    map['avg_hrv_rmssd'] = avgHrvRmssd;
    map['min_hr_bpm'] = minHrBpm;
    map['user_max_hr_bpm'] = userMaxHrBpm;
    map['avg_hrv_sdnn'] = avgHrvSdnn;
    map['avg_hr_bpm'] = avgHrBpm;
    return map;
  }
}

/// net_intake_calories : 1
/// BMR_calories : 1
/// total_burned_calories : 1
/// net_activity_calories : 1

class CaloriesData {
  CaloriesData({
    this.netIntakeCalories,
    this.bMRCalories,
    this.totalBurnedCalories,
    this.netActivityCalories,
  });

  CaloriesData.fromJson(dynamic json) {
    netIntakeCalories = json['net_intake_calories'];
    bMRCalories = json['BMR_calories'];
    totalBurnedCalories = json['total_burned_calories'];
    netActivityCalories = json['net_activity_calories'];
  }

  num? netIntakeCalories;
  num? bMRCalories;
  num? totalBurnedCalories;
  num? netActivityCalories;

  CaloriesData copyWith({
    num? netIntakeCalories,
    num? bMRCalories,
    num? totalBurnedCalories,
    num? netActivityCalories,
  }) =>
      CaloriesData(
        netIntakeCalories: netIntakeCalories ?? this.netIntakeCalories,
        bMRCalories: bMRCalories ?? this.bMRCalories,
        totalBurnedCalories: totalBurnedCalories ?? this.totalBurnedCalories,
        netActivityCalories: netActivityCalories ?? this.netActivityCalories,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['net_intake_calories'] = netIntakeCalories;
    map['BMR_calories'] = bMRCalories;
    map['total_burned_calories'] = totalBurnedCalories;
    map['net_activity_calories'] = netActivityCalories;
    return map;
  }
}

/// num_low_intensity_minutes : 1
/// num_high_intensity_minutes : 1
/// num_inactive_minutes : 1
/// num_moderate_intensity_minutes : 1
/// avg_level : 1

class MetData {
  MetData({
    this.numLowIntensityMinutes,
    this.numHighIntensityMinutes,
    this.numInactiveMinutes,
    this.numModerateIntensityMinutes,
    this.avgLevel,
  });

  MetData.fromJson(dynamic json) {
    numLowIntensityMinutes = json['num_low_intensity_minutes'];
    numHighIntensityMinutes = json['num_high_intensity_minutes'];
    numInactiveMinutes = json['num_inactive_minutes'];
    numModerateIntensityMinutes = json['num_moderate_intensity_minutes'];
    avgLevel = json['avg_level'];
  }

  num? numLowIntensityMinutes;
  num? numHighIntensityMinutes;
  num? numInactiveMinutes;
  num? numModerateIntensityMinutes;
  num? avgLevel;

  MetData copyWith({
    num? numLowIntensityMinutes,
    num? numHighIntensityMinutes,
    num? numInactiveMinutes,
    num? numModerateIntensityMinutes,
    num? avgLevel,
  }) =>
      MetData(
        numLowIntensityMinutes:
            numLowIntensityMinutes ?? this.numLowIntensityMinutes,
        numHighIntensityMinutes:
            numHighIntensityMinutes ?? this.numHighIntensityMinutes,
        numInactiveMinutes: numInactiveMinutes ?? this.numInactiveMinutes,
        numModerateIntensityMinutes:
            numModerateIntensityMinutes ?? this.numModerateIntensityMinutes,
        avgLevel: avgLevel ?? this.avgLevel,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['num_low_intensity_minutes'] = numLowIntensityMinutes;
    map['num_high_intensity_minutes'] = numHighIntensityMinutes;
    map['num_inactive_minutes'] = numInactiveMinutes;
    map['num_moderate_intensity_minutes'] = numModerateIntensityMinutes;
    map['avg_level'] = avgLevel;
    return map;
  }
}

/// swimming : {"num_strokes":1,"num_laps":1,"pool_length_meters":1}
/// floors_climbed : 1
/// elevation : {"loss_actual_meters":1,"min_meters":1,"avg_meters":1,"gain_actual_meters":1,"max_meters":1,"gain_planned_meters":1}
/// steps : 1
/// detailed : {"step_samples":[],"distance_samples":[],"elevation_samples":[]}
/// distance_meters : 1

class DistanceData {
  DistanceData({
    this.swimming,
    this.floorsClimbed,
    this.elevation,
    this.steps,
    this.detailed,
    this.distanceMeters,
  });

  DistanceData.fromJson(dynamic json) {
    swimming =
        json['swimming'] != null ? Swimming.fromJson(json['swimming']) : null;
    floorsClimbed = json['floors_climbed'];
    elevation = json['elevation'] != null
        ? Elevation.fromJson(json['elevation'])
        : null;
    steps = json['steps'];
    detailed = json['detailed'] != null
        ? StepDetailed.fromJson(json['detailed'])
        : null;
    distanceMeters = json['distance_meters'];
  }

  Swimming? swimming;
  num? floorsClimbed;
  Elevation? elevation;
  num? steps;
  StepDetailed? detailed;
  num? distanceMeters;

  DistanceData copyWith({
    Swimming? swimming,
    num? floorsClimbed,
    Elevation? elevation,
    num? steps,
    StepDetailed? detailed,
    num? distanceMeters,
  }) =>
      DistanceData(
        swimming: swimming ?? this.swimming,
        floorsClimbed: floorsClimbed ?? this.floorsClimbed,
        elevation: elevation ?? this.elevation,
        steps: steps ?? this.steps,
        detailed: detailed ?? this.detailed,
        distanceMeters: distanceMeters ?? this.distanceMeters,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (swimming != null) {
      map['swimming'] = swimming?.toJson();
    }
    map['floors_climbed'] = floorsClimbed;
    if (elevation != null) {
      map['elevation'] = elevation?.toJson();
    }
    map['steps'] = steps;
    if (detailed != null) {
      map['detailed'] = detailed?.toJson();
    }
    map['distance_meters'] = distanceMeters;
    return map;
  }
}

/// step_samples : []
/// distance_samples : []
/// elevation_samples : []

class StepDetailed {
  StepDetailed({
    this.stepSamples,
    this.distanceSamples,
    this.elevationSamples,
  });

  StepDetailed.fromJson(dynamic json) {
    if (json['step_samples'] != null) {
      stepSamples = [];
      json['step_samples'].forEach((v) {
        stepSamples?.add(v);
      });
    }
    if (json['distance_samples'] != null) {
      distanceSamples = [];
      json['distance_samples'].forEach((v) {
        distanceSamples?.add(v);
      });
    }
    if (json['elevation_samples'] != null) {
      elevationSamples = [];
      json['elevation_samples'].forEach((v) {
        elevationSamples?.add(v);
      });
    }
  }

  List<dynamic>? stepSamples;
  List<dynamic>? distanceSamples;
  List<dynamic>? elevationSamples;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (stepSamples != null) {
      map['step_samples'] = stepSamples?.map((v) => v.toJson()).toList();
    }
    if (distanceSamples != null) {
      map['distance_samples'] =
          distanceSamples?.map((v) => v.toJson()).toList();
    }
    if (elevationSamples != null) {
      map['elevation_samples'] =
          elevationSamples?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// loss_actual_meters : 1
/// min_meters : 1
/// avg_meters : 1
/// gain_actual_meters : 1
/// max_meters : 1
/// gain_planned_meters : 1

class Elevation {
  Elevation({
    this.lossActualMeters,
    this.minMeters,
    this.avgMeters,
    this.gainActualMeters,
    this.maxMeters,
    this.gainPlannedMeters,
  });

  Elevation.fromJson(dynamic json) {
    lossActualMeters = json['loss_actual_meters'];
    minMeters = json['min_meters'];
    avgMeters = json['avg_meters'];
    gainActualMeters = json['gain_actual_meters'];
    maxMeters = json['max_meters'];
    gainPlannedMeters = json['gain_planned_meters'];
  }

  num? lossActualMeters;
  num? minMeters;
  num? avgMeters;
  num? gainActualMeters;
  num? maxMeters;
  num? gainPlannedMeters;

  Elevation copyWith({
    num? lossActualMeters,
    num? minMeters,
    num? avgMeters,
    num? gainActualMeters,
    num? maxMeters,
    num? gainPlannedMeters,
  }) =>
      Elevation(
        lossActualMeters: lossActualMeters ?? this.lossActualMeters,
        minMeters: minMeters ?? this.minMeters,
        avgMeters: avgMeters ?? this.avgMeters,
        gainActualMeters: gainActualMeters ?? this.gainActualMeters,
        maxMeters: maxMeters ?? this.maxMeters,
        gainPlannedMeters: gainPlannedMeters ?? this.gainPlannedMeters,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['loss_actual_meters'] = lossActualMeters;
    map['min_meters'] = minMeters;
    map['avg_meters'] = avgMeters;
    map['gain_actual_meters'] = gainActualMeters;
    map['max_meters'] = maxMeters;
    map['gain_planned_meters'] = gainPlannedMeters;
    return map;
  }
}

/// num_strokes : 1
/// num_laps : 1
/// pool_length_meters : 1

class Swimming {
  Swimming({
    this.numStrokes,
    this.numLaps,
    this.poolLengthMeters,
  });

  Swimming.fromJson(dynamic json) {
    numStrokes = json['num_strokes'];
    numLaps = json['num_laps'];
    poolLengthMeters = json['pool_length_meters'];
  }

  num? numStrokes;
  num? numLaps;
  num? poolLengthMeters;

  Swimming copyWith({
    num? numStrokes,
    num? numLaps,
    num? poolLengthMeters,
  }) =>
      Swimming(
        numStrokes: numStrokes ?? this.numStrokes,
        numLaps: numLaps ?? this.numLaps,
        poolLengthMeters: poolLengthMeters ?? this.poolLengthMeters,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['num_strokes'] = numStrokes;
    map['num_laps'] = numLaps;
    map['pool_length_meters'] = poolLengthMeters;
    return map;
  }
}

/// recovery : 1
/// activity : 1
/// sleep : 1

class Scores {
  Scores({
    this.recovery,
    this.activity,
    this.sleep,
  });

  Scores.fromJson(dynamic json) {
    recovery = json['recovery'];
    activity = json['activity'];
    sleep = json['sleep'];
  }

  num? recovery;
  num? activity;
  num? sleep;

  Scores copyWith({
    num? recovery,
    num? activity,
    num? sleep,
  }) =>
      Scores(
        recovery: recovery ?? this.recovery,
        activity: activity ?? this.activity,
        sleep: sleep ?? this.sleep,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['recovery'] = recovery;
    map['activity'] = activity;
    map['sleep'] = sleep;
    return map;
  }
}

/// name : ""
/// hardware_version : ""
/// manufacturer : ""
/// software_version : ""
/// activation_timestamp : ""
/// serial_number : 1

class DeviceData {
  DeviceData({
    this.name,
    this.hardwareVersion,
    this.manufacturer,
    this.softwareVersion,
    this.activationTimestamp,
    this.serialNumber,
  });

  DeviceData.fromJson(dynamic json) {
    name = json['name'];
    hardwareVersion = json['hardware_version'];
    manufacturer = json['manufacturer'];
    softwareVersion = json['software_version'];
    activationTimestamp = json['activation_timestamp'];
    serialNumber = json['serial_number'];
  }

  String? name;
  String? hardwareVersion;
  String? manufacturer;
  String? softwareVersion;
  String? activationTimestamp;
  num? serialNumber;

  DeviceData copyWith({
    String? name,
    String? hardwareVersion,
    String? manufacturer,
    String? softwareVersion,
    String? activationTimestamp,
    num? serialNumber,
  }) =>
      DeviceData(
        name: name ?? this.name,
        hardwareVersion: hardwareVersion ?? this.hardwareVersion,
        manufacturer: manufacturer ?? this.manufacturer,
        softwareVersion: softwareVersion ?? this.softwareVersion,
        activationTimestamp: activationTimestamp ?? this.activationTimestamp,
        serialNumber: serialNumber ?? this.serialNumber,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['hardware_version'] = hardwareVersion;
    map['manufacturer'] = manufacturer;
    map['software_version'] = softwareVersion;
    map['activation_timestamp'] = activationTimestamp;
    map['serial_number'] = serialNumber;
    return map;
  }
}

/// end_time : ""
/// start_time : ""

class Metadata {
  Metadata({
    this.endTime,
    this.startTime,
  });

  Metadata.fromJson(dynamic json) {
    endTime = json['end_time'];
    startTime = json['start_time'];
  }

  String? endTime;
  String? startTime;

  Metadata copyWith({
    String? endTime,
    String? startTime,
  }) =>
      Metadata(
        endTime: endTime ?? this.endTime,
        startTime: startTime ?? this.startTime,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['end_time'] = endTime;
    map['start_time'] = startTime;
    return map;
  }
}

/// avg_saturation_percentage : 1
/// vo2max_ml_per_min_per_kg : 1

class OxygenData {
  OxygenData({
    this.avgSaturationPercentage,
    this.vo2maxMlPerMinPerKg,
  });

  OxygenData.fromJson(dynamic json) {
    avgSaturationPercentage = json['avg_saturation_percentage'];
    vo2maxMlPerMinPerKg = json['vo2max_ml_per_min_per_kg'];
  }

  num? avgSaturationPercentage;
  num? vo2maxMlPerMinPerKg;

  OxygenData copyWith({
    num? avgSaturationPercentage,
    num? vo2maxMlPerMinPerKg,
  }) =>
      OxygenData(
        avgSaturationPercentage:
            avgSaturationPercentage ?? this.avgSaturationPercentage,
        vo2maxMlPerMinPerKg: vo2maxMlPerMinPerKg ?? this.vo2maxMlPerMinPerKg,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['avg_saturation_percentage'] = avgSaturationPercentage;
    map['vo2max_ml_per_min_per_kg'] = vo2maxMlPerMinPerKg;
    return map;
  }
}
