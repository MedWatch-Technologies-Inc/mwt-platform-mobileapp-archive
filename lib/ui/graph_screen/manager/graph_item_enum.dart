import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/english_localization.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

enum ChartType { line, bar, pie }

extension ChartTypeItem on ChartType {
  int get value {
    switch (this) {
      case ChartType.line:
        return 1;
      case ChartType.bar:
        return 2;
      case ChartType.pie:
        return 3;
      default:
        return 1;
    }
  }
}
ChartType chartTypeFromValue(int value) {
  switch (value) {
    case 1:
      return ChartType.line;
    case 2:
      return ChartType.bar;
    case 3:
      return ChartType.pie;
    default:
      return ChartType.line;
  }
}
enum DefaultGraphItem {
  step,
  hr,
  hrv,
  sbp,
  dbp,
  bp,
  allSleep,
  deepSleep,
  lightSleep,
  awake,
  tag,
  healthKitStep,
  healthKitDistance,
  healthKitSleep,
  // healthKitHeight,
  healthKitWeight,
  healthKitSBP,
  healthKitDBP,
  healthKitHeartRate,
  healthKitBloodGlucose,
  healthKitTemperature,
  healthKitOxygen,
  weight,
  bmi,
  bfr,
  muscleRate,
  bodyWater,
  boneMass,
  bmr,
  proteinRate,
  visceralFatIndex,
  calories,
  temperature,
  oxygen,
  zone1,
  zone2,
  zone3,
  zone4,
  zone5
}

extension GraphItem on DefaultGraphItem {
  Color get color {
    switch (this) {
      case DefaultGraphItem.step:
      // return HexColor.fromHex('#0D47A1');
        return HexColor.fromHex('#0abab5');
      case DefaultGraphItem.hr:
        return AppColor.hrColor;
      case DefaultGraphItem.hrv:
        return AppColor.hrVColor;
      case DefaultGraphItem.bp:
        return AppColor.bpColor;
      case DefaultGraphItem.sbp:
        return AppColor.bpColor;
      case DefaultGraphItem.dbp:
        return AppColor.bpColor;
      case DefaultGraphItem.allSleep:
        return AppColor.allSleep;
      case DefaultGraphItem.deepSleep:
        return AppColor.deepSleep;
      case DefaultGraphItem.lightSleep:
        return AppColor.lightSleep;
      case DefaultGraphItem.awake:
        return AppColor.purpleColor;
      case DefaultGraphItem.tag:
        return AppColor.black;
      case DefaultGraphItem.weight:
        return HexColor.fromHex('#0D47A1');
      case DefaultGraphItem.bmi:
        return HexColor.fromHex('#0D47A1');
      case DefaultGraphItem.bfr:
        return HexColor.fromHex('#0D47A1');
      case DefaultGraphItem.bodyWater:
        return HexColor.fromHex('#0D47A1');
      case DefaultGraphItem.muscleRate:
        return HexColor.fromHex('#0D47A1');
      case DefaultGraphItem.boneMass:
        return HexColor.fromHex('#0D47A1');
      case DefaultGraphItem.bmr:
        return HexColor.fromHex('#0D47A1');
      case DefaultGraphItem.proteinRate:
        return HexColor.fromHex('#0D47A1');
      case DefaultGraphItem.visceralFatIndex:
        return HexColor.fromHex('#0D47A1');
      case DefaultGraphItem.calories:
        return Colors.red;
      case DefaultGraphItem.temperature:
        return AppColor.color7F8D8C;
      case DefaultGraphItem.oxygen:
        return Colors.blue;
      default:
        return Colors.blue;
    }
  }

  String name(context) {
    switch (this) {
      case DefaultGraphItem.step:
        return EnglishLocalization.getLocalization[StringLocalization.steps]!;
      case DefaultGraphItem.hr:
        return EnglishLocalization.getLocalization[StringLocalization.hr]!;
      case DefaultGraphItem.hrv:
        return EnglishLocalization.getLocalization[StringLocalization.hrv]!;
      case DefaultGraphItem.bp:
        return EnglishLocalization.getLocalization[StringLocalization.bp]!;
      case DefaultGraphItem.sbp:
        return EnglishLocalization.getLocalization[StringLocalization.sbd]!;
      case DefaultGraphItem.dbp:
        return EnglishLocalization.getLocalization[StringLocalization.dbp]!;
      case DefaultGraphItem.allSleep:
        return EnglishLocalization.getLocalization[StringLocalization.allSleep]!;
      case DefaultGraphItem.deepSleep:
        return EnglishLocalization.getLocalization[StringLocalization.deepSleep]!;
      case DefaultGraphItem.lightSleep:
        return EnglishLocalization.getLocalization[StringLocalization.lightSleep]!;
      case DefaultGraphItem.awake:
        return EnglishLocalization.getLocalization[StringLocalization.awake]!;
      case DefaultGraphItem.tag:
        return EnglishLocalization.getLocalization[StringLocalization.tag]!;
      case DefaultGraphItem.healthKitStep:
        return  Platform.isIOS ? 'HealthKit Step' : 'GoogleFit Step';
      case DefaultGraphItem.healthKitSBP:
        return  Platform.isIOS ? 'HealthKit SBP' : 'GoogleFit SBP';
      case DefaultGraphItem.healthKitDBP:
        return  Platform.isIOS ? 'HealthKit DBP' : 'GoogleFit DBP';
      case DefaultGraphItem.healthKitSleep:
        return  Platform.isIOS ? 'HealthKit Sleep' : 'GoogleFit Sleep';
      case DefaultGraphItem.healthKitWeight:
        return  Platform.isIOS ? 'HealthKit Weight' : 'GoogleFit Weight';
      case DefaultGraphItem.healthKitDistance:
        return  Platform.isIOS ? 'HealthKit Distance' : 'GoogleFit Distance';
      case DefaultGraphItem.healthKitHeartRate:
        return  Platform.isIOS ? 'HealthKit HeartRate' : 'GoogleFit HeartRate';
    // case DefaultGraphItem.healthKitHeight:
    //   return  Platform.isIOS ? 'HealthKit Height' : 'GoogleFit Height';
      case DefaultGraphItem.healthKitBloodGlucose:
        return  Platform.isIOS ? 'HealthKit Blood Glucose' : 'GoogleFit Blood Glucose';
      case DefaultGraphItem.healthKitTemperature:
        return  Platform.isIOS ? 'HealthKit Temperature' : 'GoogleFit Temperature';
      case DefaultGraphItem.healthKitOxygen:
        return  Platform.isIOS ? 'HealthKit Oxygen' : 'GoogleFit Oxygen';
      case DefaultGraphItem.weight:
        return EnglishLocalization.getLocalization[StringLocalization.weight]!;
      case DefaultGraphItem.bmi:
        return EnglishLocalization.getLocalization[StringLocalization.bMI]!;
      case DefaultGraphItem.bfr:
        return EnglishLocalization.getLocalization[StringLocalization.bfr]!;
      case DefaultGraphItem.bodyWater:
        return EnglishLocalization.getLocalization[StringLocalization.bodyWater]!;
      case DefaultGraphItem.muscleRate:
        return EnglishLocalization.getLocalization[StringLocalization.muscleRate]!;
      case DefaultGraphItem.boneMass:
        return EnglishLocalization.getLocalization[StringLocalization.boneMass]!;
      case DefaultGraphItem.bmr:
        return EnglishLocalization.getLocalization[StringLocalization.bmr]!;
      case DefaultGraphItem.proteinRate:
        return EnglishLocalization.getLocalization[StringLocalization.proteinRate]!;
      case DefaultGraphItem.visceralFatIndex:
        return EnglishLocalization.getLocalization[StringLocalization.visceralFatIndex]!;
      case DefaultGraphItem.calories:
        return EnglishLocalization.getLocalization[StringLocalization.calories]!;
      case DefaultGraphItem.temperature:
        return EnglishLocalization.getLocalization[StringLocalization.bodyTemperature]!;
      case DefaultGraphItem.oxygen:
        return EnglishLocalization.getLocalization[StringLocalization.oxygen]!;
      default:
        return '';
    }
  }

  String get fieldName {
    switch (this) {
      case DefaultGraphItem.zone1:
        return 'Zone1';
      case DefaultGraphItem.zone2:
        return 'Zone 2';
      case DefaultGraphItem.zone3:
        return 'Zone 3';
      case DefaultGraphItem.zone4:
        return 'Zone 4';
      case DefaultGraphItem.zone5:
        return 'Zone 5';

      case DefaultGraphItem.step:
        return 'step';
      case DefaultGraphItem.hr:
        return 'approxHr';
      case DefaultGraphItem.hrv:
        return 'hrv';
      case DefaultGraphItem.bp:
        return 'bp';
      case DefaultGraphItem.sbp:
        return 'approxSBP';
      case DefaultGraphItem.dbp:
        return 'approxDBP';
      case DefaultGraphItem.allSleep:
        return 'sleepAllTime';
      case DefaultGraphItem.deepSleep:
        return 'deepTime';
      case DefaultGraphItem.lightSleep:
        return 'lightTime';
      case DefaultGraphItem.awake:
        return 'stayUpTime';
      case DefaultGraphItem.tag:
        return 'Label';
      case DefaultGraphItem.healthKitDistance:
        return Constants.healthKitDistance;
    // case DefaultGraphItem.healthKitHeight:
    //   return Constants.healthKitHeight;
      case DefaultGraphItem.healthKitSleep:
        return Constants.healthKitSleep;
      case DefaultGraphItem.healthKitHeartRate:
        return Constants.healthKitHr;
      case DefaultGraphItem.healthKitStep:
        return Constants.healthKitStep;
      case DefaultGraphItem.healthKitWeight:
        return Constants.healthKitWeight;
      case DefaultGraphItem.healthKitDBP:
        return Constants.healthKitDBP;
      case DefaultGraphItem.healthKitSBP:
        return Constants.healthKitSBP;
      case DefaultGraphItem.healthKitBloodGlucose:
        return Constants.healthKitBloodGlucose;
      case DefaultGraphItem.healthKitTemperature:
        return Constants.healthKitTemperature;
      case DefaultGraphItem.healthKitOxygen:
        return Constants.healthKitOxygen;
      case DefaultGraphItem.weight:
        return 'WeightSum';
      case DefaultGraphItem.bmi:
        return 'BMI';
      case DefaultGraphItem.bfr:
        return 'FatRate';
      case DefaultGraphItem.bodyWater:
        return 'Moisture';
      case DefaultGraphItem.muscleRate:
        return 'Muscle';
      case DefaultGraphItem.bmr:
        return 'BMR';
      case DefaultGraphItem.boneMass:
        return 'BoneMass';
      case DefaultGraphItem.proteinRate:
        return 'ProteinRate';
      case DefaultGraphItem.visceralFatIndex:
        return 'VisceralFat';
      case DefaultGraphItem.calories:
        return 'calories';
      case DefaultGraphItem.temperature:
        return 'Temperature';
      case DefaultGraphItem.oxygen:
        return 'Oxygen';
      default:
        return '';
    }
  }

  String get  tableName  {
    switch (this) {
      case DefaultGraphItem.zone1:
        return 'Zone1';
      case DefaultGraphItem.zone2:
        return 'Zone 2';
      case DefaultGraphItem.zone3:
        return 'Zone 3';
      case DefaultGraphItem.zone4:
        return 'Zone 4';
      case DefaultGraphItem.zone5:
        return 'Zone 5';

      case DefaultGraphItem.step:
        return 'Sport';
      case DefaultGraphItem.hr:
        return 'HrMonitoringTable';
      case DefaultGraphItem.hrv:
        return 'Measurement';
      case DefaultGraphItem.bp:
        return 'Measurement';
      case DefaultGraphItem.sbp:
        return 'Measurement';
      case DefaultGraphItem.dbp:
        return 'Measurement';
      case DefaultGraphItem.allSleep:
        return 'Sleep';
      case DefaultGraphItem.deepSleep:
        return 'Sleep';
      case DefaultGraphItem.lightSleep:
        return 'Sleep';
      case DefaultGraphItem.awake:
        return 'Sleep';
      case DefaultGraphItem.tag:
        return 'TagNote';
      case DefaultGraphItem.healthKitStep:
        return 'HealthKitOrGoogleFitTable';
      case DefaultGraphItem.weight:
        return 'WeightScaleData';
      case DefaultGraphItem.bmi:
        return 'WeightScaleData';
      case DefaultGraphItem.bfr:
        return 'WeightScaleData';
      case DefaultGraphItem.bodyWater:
        return 'WeightScaleData';
      case DefaultGraphItem.muscleRate:
        return 'WeightScaleData';
      case DefaultGraphItem.bmr:
        return 'WeightScaleData';
      case DefaultGraphItem.boneMass:
        return 'WeightScaleData';
      case DefaultGraphItem.proteinRate:
        return 'WeightScaleData';
      case DefaultGraphItem.visceralFatIndex:
        return 'WeightScaleData';
      case DefaultGraphItem.calories:
        return 'Sport';
      case DefaultGraphItem.temperature:
        return 'Temperature';
      case DefaultGraphItem.oxygen:
        return 'Temperature';
      default:
        return '';
    }
  }

  Future<String> get imageString async {
    ByteData bytes;
    try {
      switch (this) {
        case DefaultGraphItem.step:
          bytes = await rootBundle.load('asset/stepsIcon.png');
          break;
        case DefaultGraphItem.hr:
          bytes = await rootBundle.load('asset/Wellness/hr_icon.png');
          break;
        case DefaultGraphItem.hrv:
          bytes = await rootBundle.load('asset/stress_icon.png');
          break;
        case DefaultGraphItem.bp:
          bytes = await rootBundle.load('asset/Wellness/bloodpressure_icon.png');
          break;
        case DefaultGraphItem.sbp:
          bytes = await rootBundle.load('asset/Wellness/bloodpressure_icon.png');
          break;
        case DefaultGraphItem.dbp:
          bytes = await rootBundle.load('asset/Wellness/bloodpressure_icon.png');
          break;
        case DefaultGraphItem.allSleep:
          bytes = await rootBundle.load('asset/Wellness/sleepIcon.png');
          break;
        case DefaultGraphItem.deepSleep:
          bytes = await rootBundle.load('asset/Wellness/sleepIcon.png');
          break;
        case DefaultGraphItem.lightSleep:
          bytes = await rootBundle.load('asset/Wellness/sleepIcon.png');
          break;
        case DefaultGraphItem.awake:
          bytes = await rootBundle.load('asset/awake.png');
          break;
        case DefaultGraphItem.weight:
          bytes = await rootBundle.load( 'asset/Wellness/weightIcon.png');
          break;
        case DefaultGraphItem.bmi:
          bytes = await rootBundle.load('asset/bmi_icon.png');
          break;
        case DefaultGraphItem.bfr:
          bytes = await rootBundle.load('asset/bfr_icon.png');
          break;
        case DefaultGraphItem.bodyWater:
          bytes = await rootBundle.load('asset/bodyWater.png');
          break;
        case DefaultGraphItem.muscleRate:
          bytes = await rootBundle.load('asset/muscleRate.png');
          break;
        case DefaultGraphItem.bmr:
          bytes = await rootBundle.load('asset/bmr.png');
          break;
        case DefaultGraphItem.boneMass:
          bytes = await rootBundle.load('asset/boneMass.png');
          break;
        case DefaultGraphItem.proteinRate:
          bytes = await rootBundle.load('asset/proteinRate.png');
          break;
        case DefaultGraphItem.visceralFatIndex:
          bytes = await rootBundle.load('asset/bfr_icon.png');
          break;
        case DefaultGraphItem.calories:
          bytes = await rootBundle.load('asset/caloriesIcon.png');
          break;
        case DefaultGraphItem.healthKitWeight:
          bytes = await rootBundle.load('asset/Wellness/weightIcon.png');
          break;
        case DefaultGraphItem.healthKitBloodGlucose:
          bytes = await rootBundle.load('asset/blood_glucose.png');
          break;
        case DefaultGraphItem.healthKitDBP:
          bytes = await rootBundle.load('asset/Wellness/bloodpressure_icon.png');
          break;
        case DefaultGraphItem.healthKitSBP:
          bytes = await rootBundle.load('asset/Wellness/bloodpressure_icon.png');
          break;
        case DefaultGraphItem.healthKitDistance:
          bytes = await rootBundle.load('asset/distanceIcon.png');
          break;
      // case DefaultGraphItem.healthKitHeight:
      //   bytes = await rootBundle.load('asset/height_icon.png');
      //   break;
        case DefaultGraphItem.healthKitStep:
          bytes = await rootBundle.load('asset/stepsIcon.png');
          break;
        case DefaultGraphItem.healthKitHeartRate:
          bytes = await rootBundle.load('asset/Wellness/hr_icon.png');
          break;
        case DefaultGraphItem.healthKitSleep:
          bytes = await rootBundle.load('asset/Wellness/sleepIcon.png');
          break;
        case DefaultGraphItem.temperature:
          bytes = await rootBundle.load('asset/temperatureIcon.png');
          break;
        case DefaultGraphItem.oxygen:
          bytes = await rootBundle.load('asset/oxygen.png');
          break;
        case DefaultGraphItem.healthKitOxygen:
          bytes = await rootBundle.load('asset/oxygen.png');
          break;
        case DefaultGraphItem.healthKitTemperature:
          bytes = await rootBundle.load('asset/temperatureIcon.png');
          break;
        default:
          return '';
      }
    } catch (e) {
      print(e);
      return '';
    }
    var buffer = bytes.buffer;
    return base64Encode(Uint8List.view(buffer));
  }
}
