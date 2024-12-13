import 'package:flutter/cupertino.dart';
import 'package:health_gauge/models/infoModels/motion_info_model.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/repository/heart_rate_monitor/request/save_hr_data_request.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';

class MainMenuHelper {
  static final MainMenuHelper _singleton = MainMenuHelper._internal();

  factory MainMenuHelper() {
    return _singleton;
  }

  MainMenuHelper._internal();

  final ValueNotifier<num> systolic = ValueNotifier(0.0);
  final ValueNotifier<num> systolicAI = ValueNotifier(0.0);
  final ValueNotifier<num> diastolic = ValueNotifier(0.0);
  final ValueNotifier<num> diastolicAI = ValueNotifier(0.0);
  final ValueNotifier<num> distance = ValueNotifier(0.0);
  final ValueNotifier<num> distanceGoal = ValueNotifier(0.0);
  final ValueNotifier<num> steps = ValueNotifier(0.0);
  final ValueNotifier<num> stepsGoal = ValueNotifier(0.0);
  final ValueNotifier<num> heartRate = ValueNotifier(0.0);
  final ValueNotifier<num> hrv = ValueNotifier(0.0);
  final ValueNotifier<String> sleep = ValueNotifier('0:0 HRS');
  final ValueNotifier<num> sleepGoal = ValueNotifier(0.0);
  final ValueNotifier<num> weight = ValueNotifier(0.0);
  final ValueNotifier<num> weightGoal = ValueNotifier(0.0);
  final ValueNotifier<num> temperature = ValueNotifier(0.0);
  final ValueNotifier<num> oxygen = ValueNotifier(0.0);

  set setSystolic(num value) {
    systolic.value = value;
  }

  set setSystolicAI(num value) {
    systolicAI.value = value;
  }

  set setDiastolic(num value) {
    diastolic.value = value;
  }

  set setDiastolicAI(num value) {
    diastolicAI.value = value;
  }

  set setDistance(num value) {
    distance.value = value;
  }

  set setDistanceGoal(num value) {
    distanceGoal.value = value;
  }

  set setSteps(num value) {
    steps.value = value;
  }

  set setStepsGoal(num value) {
    stepsGoal.value = value;
  }

  set setHeartRate(num value) {
    heartRate.value = value;
  }

  set setHRV(num value) {
    hrv.value = value;
  }

  set setSleep(String value) {
    sleep.value = value;
  }

  set setSleepGoal(num value) {
    sleepGoal.value = value;
  }

  set setWeight(num value) {
    weight.value = value;
  }

  set setWeightGoal(num value) {
    weightGoal.value = value;
  }

  set setTemperature(num value) {
    temperature.value = value;
  }

  set setOxygen(num value) {
    oxygen.value = value;
  }
}
