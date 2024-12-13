import 'package:flutter/material.dart';

class BloodPressureHistoryProvider extends ChangeNotifier {
  int? _currentIndex;
  DateTime _selectedDate = DateTime.now();
  DateTime? _firstDateOfWeek;
  DateTime? _lastDateOfWeek;

  BloodPressureHistoryProvider() {
    selectedDate;
    selectWeek(selectedDate);
  }

  set currentIndex(int value) {
    _currentIndex = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set selectedDate(DateTime value) {
    _selectedDate = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set lastDateOfWeek(DateTime value) {
    _lastDateOfWeek = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set firstDateOfWeek(DateTime value) {
    _firstDateOfWeek = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  DateTime get lastDateOfWeek => _lastDateOfWeek ?? DateTime.now();

  DateTime get firstDateOfWeek => _firstDateOfWeek ?? DateTime.now();

  DateTime get selectedDate => _selectedDate;

  int get currentIndex => _currentIndex ?? -1;

  selectWeek(DateTime selectedDate) {
    var dayNr = (selectedDate.weekday + 7) % 7;
    firstDateOfWeek = selectedDate.subtract(new Duration(days: (dayNr)));
    lastDateOfWeek = firstDateOfWeek.add(new Duration(days: 6));
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  reset() {
    _currentIndex = null;
    _selectedDate = DateTime.now();
    _firstDateOfWeek = null;
    _lastDateOfWeek = null;
  }
}
