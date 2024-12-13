import 'package:flutter/material.dart';
import 'package:health_gauge/screens/HK_GF/health_kit_or_google_fit_data_screen.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import '../../../utils/gloabals.dart';

enum Vital {
  step,
  distance,
  height,
  sleep,
  heartRate,
  weight,
  diaBP,
  sysBP,
  bloodGlucose,
  temperature,
  oxygen,
  activeCalorie,
  restingCalorie
}

class SelectTypeItem extends StatelessWidget {
  const SelectTypeItem({
    required this.vital,
    this.progress = 0.0,
    super.key,
  });

  final Vital vital;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        height: IconTheme.of(context).size,
        width: IconTheme.of(context).size,
        child: Vital.temperature == vital || Vital.oxygen == vital
            ? Image.asset(
                getIcon(),
                color: HexColor.fromHex('62CBC9'),
              )
            : Image.asset(
                getIcon(),
              ),
      ),
      title: Text(
        stringLocalization.getText(
          getTitle(),
        ),
      ),
      dense: true,
      trailing: progress > 0.0 && progress <= 100.0
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    color: HexColor.fromHex('62CBC9'),
                    strokeWidth: 3.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '${progress.toStringAsFixed(2)} %',
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
              ],
            )
          : SizedBox(),
      onTap: () {
        Constants.navigatePush(
          HealthKitOrGoogleFitDataScreen(
            screenTitle: getScreenTitle(),
            typeName: getTypeName(),
            unit: getScreenUnit(),
            vital: vital,
          ),
          context,
        );
      },
    );
  }

  String getIcon() {
    switch (vital) {
      case Vital.step:
        return 'asset/stepsIcon.png';
      case Vital.distance:
        return 'asset/distanceIcon.png';
      case Vital.height:
        // TODO: Handle this case.
        break;
      case Vital.sleep:
        return 'asset/Wellness/sleepIcon.png';
      case Vital.heartRate:
        return 'asset/Wellness/hr_icon.png';
      case Vital.weight:
        return 'asset/Wellness/weightIcon.png';
      case Vital.diaBP:
        return 'asset/Wellness/bloodpressure_icon.png';
      case Vital.sysBP:
        return 'asset/Wellness/bloodpressure_icon.png';
      case Vital.bloodGlucose:
        return 'asset/blood_glucose.png';
      case Vital.temperature:
        return 'asset/temperature_43_red.png';
      case Vital.oxygen:
        return 'asset/oxygen_43_red.png';
      case Vital.activeCalorie:
        return 'asset/running_icon.png';
      case Vital.restingCalorie:
        return 'asset/sitting_icon.png';
      default:
        return '';
    }
    return '';
  }

  String getTitle() {
    switch (vital) {
      case Vital.step:
        return StringLocalization.steps;
      case Vital.distance:
        return StringLocalization.distance;
      case Vital.height:
        // TODO: Handle this case.
        break;
      case Vital.sleep:
        return StringLocalization.sleep;
      case Vital.heartRate:
        return StringLocalization.hr;
      case Vital.weight:
        return StringLocalization.bodyMass;
      case Vital.diaBP:
        return StringLocalization.dbp;
      case Vital.sysBP:
        return StringLocalization.sbd;
      case Vital.bloodGlucose:
        return StringLocalization.bloodGlucose;
      case Vital.temperature:
        return StringLocalization.bodyTemperature;
      case Vital.oxygen:
        return StringLocalization.bloodOxygen;
      case Vital.activeCalorie:
        return StringLocalization.activeCalorieBurn;
      case Vital.restingCalorie:
        return StringLocalization.restingCalorieBurn;
      default:
        return '';
    }
    return '';
  }

  String getScreenTitle() {
    switch (vital) {
      case Vital.step:
        return 'Steps';
      case Vital.distance:
        return 'Distance';
      case Vital.height:
        // TODO: Handle this case.
        break;
      case Vital.sleep:
        return 'Sleep';
      case Vital.heartRate:
        return 'Heart Rate';
      case Vital.weight:
        return 'Weight';
      case Vital.diaBP:
        return 'DBP';
      case Vital.sysBP:
        return 'SBP';
      case Vital.bloodGlucose:
        return 'Blood Glucose';
      case Vital.temperature:
        return 'Temperature';
      case Vital.oxygen:
        return 'Blood Oxygen';
      case Vital.activeCalorie:
        return 'Active Calorie Burn';
      case Vital.restingCalorie:
        return 'Resting Calorie Burn';
      default:
        return '';
    }
    return '';
  }

  String getTypeName() {
    switch (vital) {
      case Vital.step:
        return Constants.healthKitStep;
      case Vital.distance:
        return Constants.healthKitDistance;
      case Vital.height:
        return Constants.healthKitHeight;
      case Vital.sleep:
        return Constants.healthKitSleep;
      case Vital.heartRate:
        return Constants.healthKitHr;
      case Vital.weight:
        return Constants.healthKitWeight;
      case Vital.diaBP:
        return Constants.healthKitDBP;
      case Vital.sysBP:
        return Constants.healthKitSBP;
      case Vital.bloodGlucose:
        return Constants.healthKitBloodGlucose;
      case Vital.temperature:
        return Constants.healthKitTemperature;
      case Vital.oxygen:
        return Constants.healthKitOxygen;
      case Vital.activeCalorie:
        return Constants.healthKitActiveCalories;
      case Vital.restingCalorie:
        return Constants.healthKitRestingCalories;
      default:
        return '';
    }
  }

  String getScreenUnit() {
    switch (vital) {
      case Vital.step:
        return '';
      case Vital.distance:
        return preferences?.getInt(Constants.mDistanceUnitKey) == 0 ? ' km' : ' mile';
      case Vital.height:
        // TODO: Handle this case.
        break;
      case Vital.sleep:
        return '';
      case Vital.heartRate:
        return '';
      case Vital.weight:
        return preferences?.getInt(Constants.wightUnitKey) == 0 ? ' kg' : ' lb';
      case Vital.diaBP:
        return '';
      case Vital.sysBP:
        return '';
      case Vital.bloodGlucose:
        return preferences?.getInt(Constants.bloodGlucoseUnitKey) == 0 ? ' mmol/l' : ' mg/dl';
      case Vital.temperature:
        return preferences?.getInt(Constants.mTemperatureUnitKey) == 0 ? ' °C' : ' °F';
      case Vital.oxygen:
        return '';
      case Vital.activeCalorie:
        return 'kcal';
      case Vital.restingCalorie:
        return 'kcal';
      default:
        return '';
    }
    return '';
  }
}
