import 'dart:async';
import 'dart:io' show Platform;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/connections.dart';
import 'package:location/location.dart';

import 'model/location_model.dart';

enum _LocationServiceEnum { location, geolocator }

enum LocationPermissionStatus {
  /// This is the initial state on both Android and iOS, but on Android the
  /// user can still choose to deny permissions, meaning the App can still
  /// request for permission another time.
  denied,

  /// Permission to access the device's location is permenantly denied. When
  /// requestiong permissions the permission dialog will not been shown until
  /// the user updates the permission in the App settings.
  deniedForever,

  /// Permission to access the device's location is allowed only while
  /// the App is in use.
  whileInUse,

  /// Permission to access the device's location is allowed even when the
  /// App is running in the background.
  always
}

extension _LocationServiceEnumMixin on _LocationServiceEnum {
  String getName() {
    return toString().split('.').last;
  }
}

class LocationServiceManager {
  static bool mock = false;
  static bool isInitialized = false;
  static Location? _location;
  static geo.Position? _currentLocation;
  static LocationAddressModel? _currentLocationAddressModel;

  static final _LocationServiceEnum _defaultService = Platform.isIOS
      ? _LocationServiceEnum.geolocator
      : _LocationServiceEnum.location;

  // ignore: close_sinks
  static final _currentLocationController =
      StreamController<LocationAddressModel>.broadcast();

  static Stream<LocationAddressModel> get currentLocationStream =>
      _currentLocationController.stream;

  LocationServiceManager._();

  static Future initialize() async {
    if (mock || isInitialized) {
      return;
    }
    try {
      _location = Location();
      _listenLocationChange();
      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        // Got a new connectivity status!
        switch (result) {
          case ConnectivityResult.wifi:
          case ConnectivityResult.mobile:
            getCurrentLocation('Connectivity change');
            break;
          case ConnectivityResult.none:
          default:
            break;
        }
      });
      isInitialized = true;
      LoggingService().printLog(message: 'isInitialized: $isInitialized');
    } on Exception catch (e) {
      LoggingService()
          .printLog(message: 'Error initializing LocalStorage ${e.toString()}');
    }
  }

  static void _listenLocationChange() {
    print('cuttent_pos ${_currentLocation?.latitude}');
    _location!.changeSettings(accuracy: LocationAccuracy.high);
    _location!.enableBackgroundMode(enable: true);
    _location!.onLocationChanged.listen((LocationData updatedLocation) {
      _currentLocation = _getPositionModel(updatedLocation);
      _currentLocationAddressModel =
          LocationAddressModel.fromPosition(_currentLocation!);
      _currentLocationController.sink.add(_currentLocationAddressModel!);
    });
  }

  static void _listenGeoLocationChange() {
    // for updated version
    print('cuttent_pos ');

    /* geo.Geolocator.getPositionStream(
            desiredAccuracy: geo.LocationAccuracy.bestForNavigation,
            intervalDuration: Duration(microseconds: 1000))*/

    // geo.Geolocator.

    geo.Geolocator.getPositionStream(
      locationSettings: geo.AppleSettings(
        accuracy: geo.LocationAccuracy.best,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
        activityType: geo.ActivityType.fitness,
        allowBackgroundLocationUpdates: false,
      ),
    ).listen((geo.Position position) {
      print('Current_pos  ${position.toJson()}');
      _currentLocation = position;
      _currentLocationAddressModel =
          LocationAddressModel.fromPosition(_currentLocation!);
      _currentLocationController.sink.add(_currentLocationAddressModel!);
    });
  }

  static Future<bool> setLocation() async {
    if (!isInitialized) {
      await initialize();
    }
    try {
      var location = await _setLocationToLocalStorage();
      return location != null;
    } on Exception catch (e) {
      print('error in location $e');
      return false;
    }
  }

  static Future<LocationAddressModel?> getCurrentLocation(
    String domainName, {
    bool needLatLngOnly = false,
    bool isExtraInfoNeeded = true,
  }) async {
    var isLatLngUpdated = false;

    if (_currentLocation != null && _currentLocationAddressModel != null) {
      if (_currentLocationAddressModel!.latitude != null &&
          _currentLocationAddressModel!.longitude != null) {
        if (_currentLocationAddressModel!.latitude !=
                _currentLocation!.latitude &&
            _currentLocationAddressModel!.longitude !=
                _currentLocation!.longitude) {
          print('getCurrentLocation');
          var dist = geo.Geolocator.distanceBetween(
              _currentLocation!.latitude,
              _currentLocation!.longitude,
              _currentLocationAddressModel!.latitude!,
              _currentLocationAddressModel!.longitude!);
          if (dist > 500) {
            isLatLngUpdated = true;
          }
        }
      }
    }

    if (_currentLocationAddressModel == null || isLatLngUpdated) {
      // in case of any issue with current location, replace it with _getLocationOld();
      var addressModel = await _getLocation();
      _currentLocationAddressModel =
          addressModel ?? _currentLocationAddressModel;
      isLatLngUpdated = false;
      if (_currentLocationAddressModel != null) {
        _currentLocationController.sink.add(_currentLocationAddressModel!);
      }
    }
    return _currentLocationAddressModel;
  }

  static Future<LocationAddressModel?> _getLocation() async {
    try {
      var loc = _currentLocation;
      if (loc != null) {
        return LocationAddressModel(
          latitude: loc.latitude,
          longitude: loc.longitude,
        );
      } else {
        return _getLocationOld();
      }
    } on Exception {
      return _getLocationOld();
    }
  }

  static Future<LocationAddressModel?> _getLocationOld() async {
    var position = await _setLocationToLocalStorage();
    if (position != null) {
      LocationAddressModel location =
          LocationAddressModel.fromPosition(position);
      return location;
    }
    return null;
  }

  static Future<geo.Position?> _setLocationToLocalStorage() async {
    try {
      if (!isInitialized) {
        await initialize();
      }
      _currentLocation = _defaultService == _LocationServiceEnum.location
          ? await _locateUser()
          : await _determinePosition();
      // ignore: unawaited_futures
      getCurrentLocation('LocServiceInit');
      return _currentLocation;
    } on Exception catch (e) {
      print('error in location $e');
      return null;
    }
  }

  static Future<geo.Position> _locateUser() async {
    try {
      bool serviceEnabled;
      PermissionStatus permissionStatus;
      LocationData locationData;

      serviceEnabled = await _location!.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location!.requestService();
        if (!serviceEnabled) {
          throw Exception('Failed to enable location service');
        }
      }

      permissionStatus = await _location!.hasPermission();

      if (permissionStatus == PermissionStatus.deniedForever) {
        throw Exception('Please enable location from settings');
      }

      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await _location!.requestPermission();
        if (permissionStatus != PermissionStatus.granted) {
          throw Exception('Failed to get permission for location');
        }
      }

      locationData = await _location!.getLocation();
      return _getPositionModel(locationData);
    } on Exception catch (e) {
      print('error in location $e');
      rethrow;
    }
  }

  static geo.Position _getPositionModel(LocationData locationData) {
    return geo.Position(
      altitudeAccuracy: 1.0,
      headingAccuracy: 1.0,
      latitude: locationData.latitude ?? 0,
      longitude: locationData.longitude ?? 0,
      timestamp: locationData.time != null
          ? DateTime.fromMicrosecondsSinceEpoch(locationData.time!.round())
          : DateTime.now(),
      accuracy: locationData.accuracy ?? 0,
      altitude: locationData.altitude ?? 0,
      heading: locationData.heading ?? 0,
      speed: locationData.speed ?? 0,
      speedAccuracy: locationData.speedAccuracy ?? 0,
    );
  }

  static Future<geo.Position> _determinePosition() async {
    try {
      bool serviceEnabled;
      geo.LocationPermission permission;
      geo.Position position;
      serviceEnabled = await _location!.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location!.requestService();
        if (!serviceEnabled) {
          throw Exception('Failed to enable location service');
        }
      }

      permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.deniedForever) {
        throw Exception('Please enable location from settings');
      }

      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission != geo.LocationPermission.whileInUse &&
            permission != geo.LocationPermission.always) {
          throw Exception(
              'Location permissions are denied (actual value: $permission).');
        }
      }
      position = await geo.Geolocator.getCurrentPosition();
      return position;
    } on Exception catch (e) {
      print('error in location $e');
      rethrow;
    }
  }

  static Future<bool> checkLocationServiceEnabled() async {
    final serviceEnabled = await _location!.serviceEnabled();
    if (serviceEnabled) {
      return true;
    } else {
      return await _location!.requestService();
    }
  }

  static Future<bool> isLocationPermissionGranted() async {
    if (_defaultService == _LocationServiceEnum.location) {
      var status = await _location!.hasPermission();
      switch (status) {
        case PermissionStatus.granted:
          return true;
        case PermissionStatus.deniedForever:
        case PermissionStatus.denied:
        default:
          return false;
      }
    } else {
      var status = await geo.Geolocator.checkPermission();
      switch (status) {
        case geo.LocationPermission.always:
        case geo.LocationPermission.whileInUse:
          return true;
        case geo.LocationPermission.deniedForever:
        case geo.LocationPermission.denied:
        default:
          return false;
      }
    }
  }

  static Future<LocationPermissionStatus> getLocationPermissionStatus() async {
    if (_defaultService == _LocationServiceEnum.location) {
      var status = await _location!.hasPermission();
      switch (status) {
        case PermissionStatus.granted:
          return LocationPermissionStatus.whileInUse;
        case PermissionStatus.deniedForever:
          return LocationPermissionStatus.deniedForever;
        case PermissionStatus.denied:
        default:
          return LocationPermissionStatus.denied;
      }
    } else {
      var status = await geo.Geolocator.checkPermission();
      switch (status) {
        case geo.LocationPermission.always:
          return LocationPermissionStatus.always;
        case geo.LocationPermission.whileInUse:
          return LocationPermissionStatus.whileInUse;
        case geo.LocationPermission.deniedForever:
          return LocationPermissionStatus.deniedForever;
        case geo.LocationPermission.denied:
        default:
          return LocationPermissionStatus.denied;
      }
    }
  }

  static Future<bool> checkLocationPermission() async {
    if (_defaultService == _LocationServiceEnum.location) {
      var status = await _location!.hasPermission();
      switch (status) {
        case PermissionStatus.granted:
          return true;
        case PermissionStatus.deniedForever:
          return false;
        case PermissionStatus.denied:
          status = await _location!.requestPermission();
          return status == PermissionStatus.granted;
        default:
          return false;
      }
    } else {
      var status = await geo.Geolocator.checkPermission();
      switch (status) {
        case geo.LocationPermission.always:
        case geo.LocationPermission.whileInUse:
          return true;
        case geo.LocationPermission.deniedForever:
          return false;
        case geo.LocationPermission.denied:
          status = await geo.Geolocator.requestPermission();
          return status == geo.LocationPermission.always ||
              status == geo.LocationPermission.whileInUse;
        default:
          return false;
      }
    }
  }

  static Future<bool> isLocationGranted() async {
    return await geo.Geolocator.isLocationServiceEnabled();
  }
}
