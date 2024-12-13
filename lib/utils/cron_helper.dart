import 'dart:convert';

import 'package:cron/cron.dart';
import 'package:health_gauge/screens/dashboard/dash_board_screen.dart';
import 'package:health_gauge/screens/measurement_screen/measurement_screen.dart';
import 'package:health_gauge/utils/Synchronisation/sync_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';

class CronHelper {
  static final CronHelper _instance = CronHelper();

  static CronHelper get instance => _instance;
  Cron cron = Cron();

  void schedule({int inMinute = 1}) async {
    var cronPattern = '*/$inMinute * * * *';
    print('Cron Run Patter :: $cronPattern');
    await cron.close();
    cron = Cron();
    Future.delayed(Duration(seconds: 1), () {
      cron.schedule(Schedule.parse(cronPattern), () async {
        print('Cron Run :: ${DateTime.now()}');
        syncWatchData();
      });
    });
  }

  void dispose() async {
    await cron.close();
  }

  void syncWatchData() async {
    var userID = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
    if (userID.isEmpty ||
        connections.isBPConfiguring.value ||
        connections.isHRConfiguring.value ||
        (mTimer.value?.isActive ?? false)) {
      return;
    }
    print('Cron Run :: Pass Commands :: ${DateTime.now()}');
    if (await connections.isConnected(Constants.e66)) {
      print('Requesting from :: watch is connected');
      SyncHelper().initialise();
    } else {
      print('Requesting from :: watch is not connected');
      var deviceModel = await connections.checkAndConnectDeviceIfNotConnected();
      if (deviceModel != null) {
        preferences?.setString(
          Constants.connectedDeviceAddressPrefKey,
          jsonEncode(
            deviceModel.toMap(),
          ),
        );
        connectedDeviceDash = deviceModel;
        connections.sdkType = deviceModel.sdkType ?? Constants.e66;
        connectedDeviceDash!.sdkType = deviceModel.sdkType ?? Constants.e66;
        isDeviceConnected.value = true;
        // SyncHelper().initWatchConfig();
      }
    }
  }
}
