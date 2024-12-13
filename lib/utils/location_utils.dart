import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationUtils {
  static final LocationUtils _singleton = LocationUtils._internal();

  factory LocationUtils() {
    return _singleton;
  }

  LocationUtils._internal();

  Future<bool> checkPermission(BuildContext context) async {

    // if (Platform.isIOS) {
    //   return true;
    // }
    PermissionStatus permissionStatus = await Permission.location.request();
    bool isGranted = permissionStatus != PermissionStatus.denied &&
        permissionStatus != PermissionStatus.permanentlyDenied;
    if (!isGranted) {
      await _showLocationDialog(context).then((value) async {
        if (value == true) {
          isGranted =
              await Permission.location.request() == PermissionStatus.granted;
          return isGranted;
        }
      });
    }


    return isGranted;
  }

  Future<void> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus permissionStatus =
          await Permission.locationAlways.request();
      /*var permission = await Permission.locationAlways.isGranted;
      if (!permission) {
        var t = await Permission.locationAlways.request();
      }*/
    }
    final result = await Permission.notification.request();
    if (result == PermissionStatus.granted) {
      print('GRANTED'); // ignore: avoid_print
    } else {
      print('NOT GRANTED'); // ignore: avoid_print
    }
  }

  Future _showLocationDialog(BuildContext context) async {
    preferences ??= await SharedPreferences.getInstance();
    var showLocation = preferences?.getBool('showLocation');
    if (Platform.isIOS) return false;
    // if (showLocation == null || showLocation) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:
              Text(stringLocalization.getText(StringLocalization.information)),
          // content: Text('This app needs location data to enable [bluetooth feature] even when the app is closed or not in use to reconnects the smartwatch or weigh-scale devices.'),
          content: SingleChildScrollView(
              child: Text(
            'Location Access\n\n\nBy turning on your location access, you are granting the Service access to your Connected Devices to enable device pairing.  Health Gauge may also derive your approximate location in background from your device for use in Service features, including tracking your distance traveled and your elevation. You can always remove Health Gauge’s permission to your location using your mobile device settings. If you do not provide the Service with access to your Connected Devices, we will not be able to connect to your Connected Devices and Health Gauge will no longer appear in the scan when attempting to pair a Connected Device.',
            style: TextStyle(fontSize: 14.5),
          )),
          actions: <Widget>[
            TextButton(
              key: Key('agreeKey'),
              child: Text(
                'Agree',
                style: TextStyle(
                  // fontSize: 16.sp,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: HexColor.fromHex('#00AFAA'),
                ),
              ),
              onPressed: () {
                // Close the dialog
                preferences?.setBool('showLocation', false);
                Navigator.of(context).pop(true);
              },
            ),
            // usually buttons at the bottom of the dialog
            TextButton(
              key: Key('disagreeKey'),
              child: Text(
                'Disagree',
                style: TextStyle(
                    // fontSize: 16.sp,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: HexColor.fromHex('#00AFAA')),
              ),
              onPressed: () {
                // Close the dialog
                preferences?.setBool('showLocation', false);
                Navigator.of(context).pop(false);
              },
            ),

          ],
        );
      },
    );
    // }
  }
}
