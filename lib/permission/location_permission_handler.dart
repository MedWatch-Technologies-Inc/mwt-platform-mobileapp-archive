import 'package:flutter/material.dart';
import 'package:health_gauge/permission/permission_handler.dart';
import 'package:health_gauge/services/location/location_service_manager.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class LocationPermissionHandler extends PermissionHandler {
  @override
  Future<bool> handlePermissionFlow(BuildContext context) async {
    if (await isPermissionGranted()) {
      return true;
    } else {
      var status = await LocationServiceManager.getLocationPermissionStatus();
      switch (status) {
        case LocationPermissionStatus.whileInUse:
        case LocationPermissionStatus.always:
          return true;
        case LocationPermissionStatus.denied:
          await makeDialog(
              context,
              stringLocalization.getText(StringLocalization.information),
              'This app needs location data to enable [bluetooth feature] even when the app is closed or not in use to reconnects the smartwatch or weigh-scale devices.',
              positiveBtnFn: () async {
            await LocationServiceManager.setLocation();
          });
          return await isPermissionGranted();
        case LocationPermissionStatus.deniedForever:
        //TODO handle denied forever case
        default:
          return false;
      }
    }
  }

  @override
  Future<bool> isPermissionGranted() async {
    return await LocationServiceManager.isLocationPermissionGranted();
  }
}
