import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_gauge/services/location/model/location_model.dart';

class HistoryDetailProvider extends ChangeNotifier {
  LatLng? currentPosition;
  List<LocationAddressModel>? locationData = [];
  double? domainValue = 0;
  double? currentSpeed = 0;
  double? currentElevation = 0;
  DateTime? currentDateTime;

  void changeCurrentPosition(double lat, double long) {
    currentPosition = LatLng(lat, long);
    notifyListeners();
  }

  void changeDomainValue(double val) {
    print(val);
    domainValue = val;
  }
}
