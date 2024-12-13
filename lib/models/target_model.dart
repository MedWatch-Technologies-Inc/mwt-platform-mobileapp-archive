import 'package:flutter/material.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';

class TargetModel with ChangeNotifier {
  double stepCount = 8000;
  double sleepHour = 8;
  double sleepMinute = 0;

  List listOfStep = [];

  List listOfHour = [];
  List listOfMinute = [];

  double selectedCalories = 2000;
  List listOfCalories = [];

  double selectedDistance = 5000;
  List listOfDistance = [];

  // double selectedWeight =
  //     UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.metric
  //         ? 70
  //         : 70 * 2.205;
  double selectedWeight =
      UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.metric
          ? 70
          : 70 * 2.20462;
  List listOfWeight = [];

  String? userId;

  bool isLoading = true;
  int? stepValue;
  int? hourValue;
  int? minuteValue;
  int? caloriesValue;
  int? distanceValue;
  int? weightValue;
  bool isGoalEdit = false;

  TargetModel() {
    for (var i = 100; i <= 20000; i += 100) {
      if (i % 100 == 0) {
        listOfStep.add(i);
      }
    }
    for (var i = 100; i <= 15250; i += 100) {
      if (i % 100 == 0) {
        listOfDistance.add(i);
      }
    }
    for (var i = 50; i <= 2000; i += 50) {
      if (i % 50 == 0) {
        listOfCalories.add(i);
      }
    }
    for (var i = 1; i <= 12; i++) {
      listOfHour.add(i);
    }
    for (var i = 0; i <= 60; i++) {
      listOfMinute.add(i);
    }
    if (UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.imperial) {
      for (var i = 0; i <= 662; i++) {
        listOfWeight.add(i);
      }
    } else {
      for (var i = 0; i <= 300; i++) {
        listOfWeight.add(i);
      }
    }
  }

  void updateStepCount(double val) {
    stepCount = val;
    notifyListeners();
  }

  void updateSleepHour(double v) {
    sleepHour = v;
    notifyListeners();
  }

  void updateSleepMinute(double m) {
    sleepMinute = m;
    notifyListeners();
  }

  void updateSelectedCalorie(double cal) {
    selectedCalories = cal;
    notifyListeners();
  }

  void updateSelectedDistance(double dis) {
    selectedDistance = dis;
    notifyListeners();
  }

  void updateSelectedWeight(double weight) {
    selectedWeight = weight;
    notifyListeners();
  }

  void updateIsLoading(bool v) {
    isLoading = v;
    notifyListeners();
  }

  void updateStepValue(int v) {
    stepValue = v;
    notifyListeners();
  }

  void updateHourValue(int h) {
    hourValue = h;
    notifyListeners();
  }

  void updateMinuteValue(int m) {
    minuteValue = m;
    notifyListeners();
  }

  void updateCalorieValue(int c) {
    caloriesValue = c;
    notifyListeners();
  }

  void updateDistanceValue(int d) {
    distanceValue = d;
    notifyListeners();
  }

  void updateWeightValue(int w) {
    weightValue = w;
    notifyListeners();
  }

  void updateIsGoalEdit() {
    isGoalEdit = true;
    notifyListeners();
  }
}
