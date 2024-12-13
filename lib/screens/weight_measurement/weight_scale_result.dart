import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

enum MeasurementTypes {
  WEIGHT,
  BMI,
  BMR,
  BFR,
  BONEMASS,
  MUSCLERATE,
  BODYWATER,
  PROTEINRATE,
  VISCERALFATINDEX,
  SUBCATENOUSFAT,
  FATMASS,
  MUSCLEMASS,
  PROTEINMASS
}

class WeightScaleResult {
  Map<double, String> weightMap = {
    59.9: '${stringLocalization.getText(StringLocalization.thin)}',
    81: '${stringLocalization.getText(StringLocalization.ideal)}',
    97.2: '${stringLocalization.getText(StringLocalization.overweight)}',
    200: '${stringLocalization.getText(StringLocalization.obese)}',
  };
  Map<double, String> bMIMap = {
    18.5: '${stringLocalization.getText(StringLocalization.thin)}',
    25: '${stringLocalization.getText(StringLocalization.ideal)}',
    30: '${stringLocalization.getText(StringLocalization.overweight)}',
    100: '${stringLocalization.getText(StringLocalization.obese)}',
  };

  Map<double, String> bFRMap = {
    10: '${stringLocalization.getText(StringLocalization.low)}',
    21: '${stringLocalization.getText(StringLocalization.ideal)}',
    26: '${stringLocalization.getText(StringLocalization.high)}',
    100: '${stringLocalization.getText(StringLocalization.high)}',
  };

  Map<double, String> muscleRateMap = {
    40: '${stringLocalization.getText(StringLocalization.low)}',
    60: '${stringLocalization.getText(StringLocalization.ideal)}',
    100: '${stringLocalization.getText(StringLocalization.excellent)}',
  };

  Map<double, String> bodyWaterMap = {
    55: '${stringLocalization.getText(StringLocalization.low)}',
    65: '${stringLocalization.getText(StringLocalization.ideal)}',
    100: '${stringLocalization.getText(StringLocalization.excellent)}',
  };

  Map<double, String> boneMassMap = {
    2.8: '${stringLocalization.getText(StringLocalization.low)}',
    3: '${stringLocalization.getText(StringLocalization.ideal)}',
    5: '${stringLocalization.getText(StringLocalization.excellent)}',
  };

  Map<double, String> bMRMap = {
    1652: '${stringLocalization.getText(StringLocalization.low)}',
    2500: '${stringLocalization.getText(StringLocalization.excellent)}',
  };

  Map<double, String> proteinRateMap = {
    16: '${stringLocalization.getText(StringLocalization.low)}',
    18: '${stringLocalization.getText(StringLocalization.ideal)}',
    40: '${stringLocalization.getText(StringLocalization.excellent)}',
  };

  Map<double, String> visceralFatIndexMap = {
    9: '${stringLocalization.getText(StringLocalization.ideal)}',
    14: '${stringLocalization.getText(StringLocalization.alert)}',
    30: '${stringLocalization.getText(StringLocalization.danger)}',
  };

  Map<double, String> subcutaneousFatMap = {
    7: '${stringLocalization.getText(StringLocalization.low)}',
    15: '${stringLocalization.getText(StringLocalization.ideal)}',
    40: '${stringLocalization.getText(StringLocalization.excellent)}',
  };

  Map<double, String> fatMassMap = {
    6.4: '${stringLocalization.getText(StringLocalization.low)}',
    13.4: '${stringLocalization.getText(StringLocalization.ideal)}',
    16.5: '${stringLocalization.getText(StringLocalization.high)}',
    30: '${stringLocalization.getText(StringLocalization.high)}',
  };

  Map<double, String> muscleMassMap = {
    25.4: '${stringLocalization.getText(StringLocalization.low)}',
    38.2: '${stringLocalization.getText(StringLocalization.ideal)}',
    100: '${stringLocalization.getText(StringLocalization.excellent)}',
  };

  Map<double, String> proteinMassMap = {
    10.2: '${stringLocalization.getText(StringLocalization.low)}',
    11.4: '${stringLocalization.getText(StringLocalization.ideal)}',
    30: '${stringLocalization.getText(StringLocalization.excellent)}',
  };

  String? getWeightScaleResult(MeasurementTypes? type, double? result) {
    Map map = getDataMap(type!);
    String? resultValue;
    for(var i = 0; i<map.length; i++){
      var key = map.keys.toList();
      if(result !< key[i]){
        resultValue = map[key[i]];
        break;
      }
    }
    return resultValue;

  }

  Map<double, String> getDataMap(MeasurementTypes type) {
    switch (type) {
      case MeasurementTypes.WEIGHT:
        return weightMap;
      case MeasurementTypes.BFR:
        return bFRMap;
      case MeasurementTypes.BMI:
        return bMIMap;
      case MeasurementTypes.BMR:
        return bMRMap;
      case MeasurementTypes.BODYWATER:
        return bodyWaterMap;
      case MeasurementTypes.BONEMASS:
        return boneMassMap;
      case MeasurementTypes.FATMASS:
        return fatMassMap;
      case MeasurementTypes.MUSCLEMASS:
        return muscleMassMap;
      case MeasurementTypes.MUSCLERATE:
        return muscleRateMap;
      case MeasurementTypes.PROTEINMASS:
        return proteinMassMap;
      case MeasurementTypes.PROTEINRATE:
        return proteinRateMap;
      case MeasurementTypes.SUBCATENOUSFAT:
        return subcutaneousFatMap;
      case MeasurementTypes.VISCERALFATINDEX:
        return visceralFatIndexMap;
    }
  }
}
