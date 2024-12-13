import 'package:flutter/cupertino.dart';
import 'package:health_gauge/models/infoModels/motion_info_model.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';

class DashData {
  ValueNotifier<num> _hr = ValueNotifier(0);
  ValueNotifier<num> _sys = ValueNotifier(0);
  ValueNotifier<num> _dia = ValueNotifier(0);
  ValueNotifier<num> _hrv = ValueNotifier(0);
  ValueNotifier<num> _hrvFromLastMeasurement = ValueNotifier(0);
  ValueNotifier<num> _weight = ValueNotifier(0);
  ValueNotifier<num> _oxygen = ValueNotifier(0);

  num get hr => _hr.value;

  num get sys => _sys.value;

  num get dia => _dia.value;

  num get hrv => _hrv.value;

  num get weight => _weight.value;

  num get oxygen => _oxygen.value;

  ValueNotifier<num> get hrN => _hr;

  ValueNotifier<num> get sysN => _sys;

  ValueNotifier<num> get diaN => _dia;

  ValueNotifier<num> get hrvN => _hrv;

  ValueNotifier<num> get weightN => _weight;

  ValueNotifier<num> get oxygenN => _oxygen;

  ValueNotifier<num> get hrvFromLastMeasurementN => _hrvFromLastMeasurement;

  void resetData() {
    _hr = ValueNotifier(0);
    _hr.notifyListeners();
    _sys = ValueNotifier(0);
    _sys.notifyListeners();
    _dia = ValueNotifier(0);
    _dia.notifyListeners();
    _hrv = ValueNotifier(0);
    _hrv.notifyListeners();
    _hrvFromLastMeasurement = ValueNotifier(0);
    _hrvFromLastMeasurement.notifyListeners();
    _weight = ValueNotifier(0);
    _weight.notifyListeners();
    _oxygen = ValueNotifier(0);
    _oxygen.notifyListeners();
  }

  set hr(num value) {
    if (value > 0) {
      _hr.value = value;
    }
    _hr.notifyListeners();
  }

  set sys(num value) {
    if (value > 0) {
      _sys.value = value;
    }
    _sys.notifyListeners();
  }

  set dia(num value) {
    if (value > 0) {
      _dia.value = value;
    }
    _dia.notifyListeners();
  }

  set hrv(num value) {
    if (value > 0) {
      _hrv.value = value;
    }
    _hrv.notifyListeners();
  }

  set hrvFromLastMeasurement(num value) {
    if (value > 0) {
      _hrvFromLastMeasurement.value = value;
    }
    _hrvFromLastMeasurement.notifyListeners();
  }

  set weight(num value) {
    if (value > 0) {
      _weight.value = value;
    }
    _weight.notifyListeners();
  }

  set oxygen(num value) {
    print('setOxygen :: $value');
    if (value > 0) {
      _oxygen.value = value;
    }
    _oxygen.notifyListeners();
  }
}
