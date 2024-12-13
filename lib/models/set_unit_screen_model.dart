import 'package:flutter/material.dart';

class SetUnitScreenModel extends ChangeNotifier {
  int wightUnit = 0;
  int mHeightUnit = 0;
  int mDistanceUnit = 0;
  int mTemperatureUnit = 0;
  int timeUnit = 0;
  int bloodGlucoseUnit = 0;
  bool isEdited = false;

  void changeisEdited(bool val) {
    isEdited = val;
    notifyListeners();
  }

  void changeWightUnit(int wu, bool mounted) {
    wightUnit = wu;
    if (mounted) {
      notifyListeners();
    }
  }

  void changeMHeightUnit(int h, bool mounted) {
    mHeightUnit = h;
    if (mounted) {
      notifyListeners();
    }
  }

  void changeMDistanceUnit(int d, bool mounted) {
    mDistanceUnit = d;
    if (mounted) {
      notifyListeners();
    }
  }

  void changeMTemperatureUnit(int t, bool mounted) {
    mTemperatureUnit = t;
    if (mounted) {
      notifyListeners();
    }
  }

  void changeTimeUnit(int t, bool mounted) {
    timeUnit = t;
    if (mounted) {
      notifyListeners();
    }
  }


  void changeBloodGlucoseUnit(int t, bool mounted) {
    bloodGlucoseUnit = t;
    if (mounted) {
      notifyListeners();
    }
  }
}
