import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/alarm_models/alarm_model.dart';
import 'package:health_gauge/models/alarm_models/e80_alarm_list_model.dart';
import 'package:health_gauge/models/bp_model.dart';
import 'package:health_gauge/models/collect_ecg_model.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/e80_set_alarm_model.dart';
import 'package:health_gauge/models/infoModels/device_info_model.dart';
import 'package:health_gauge/models/infoModels/heart_info_model.dart';
import 'package:health_gauge/models/infoModels/motion_info_model.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/models/infoModels/wo_heart_info_model.dart';
import 'package:health_gauge/models/measurement/ecg_info_reading_model.dart';
import 'package:health_gauge/models/measurement/lead_off_status_model.dart';
import 'package:health_gauge/models/measurement/ppg_info_reading_model.dart';
import 'package:health_gauge/models/notification_model.dart';
import 'package:health_gauge/models/reminder_model.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_h_model.dart';
import 'package:health_gauge/screens/HK_GF/hk_gf_helper.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTResponse/ot_h_model.dart';
import 'package:health_gauge/screens/map_screen/model/hr_monitor_model.dart';
import 'package:health_gauge/utils/Synchronisation/Models/hr_monitoring_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/cron_helper.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

import '../models/ble_device_model.dart';
import '../models/device_configuration_model.dart';
import 'Synchronisation/watch_sync_helper.dart';

/// Added by: chandresh
/// Added at: 28-05-2020
/// Makes bridge between native android/ios to flutter and basically used to do call sdk methods.
class Connections {
  ScanDeviceListener? scanDeviceListener;
  ScanBLEDeviceListener? scanBLEDeviceListener;
  PerformerListener? performerListener;
  BLEPerformerListener? blePerformerListener;
  HeartRateFromRunModeListener? heartRateFromRunModeListener;
  MeasurementListener? measurementListener;
  HourlyPPGListener? hourlyPPGListener;
  VibrateListener? vibrateListener;
  WeightScaleListener? weightScaleListener;
  AppNotificationListener? appNotificationListener;
  AssistantQueryListener? assistantQueryListener;
  static StreamController<dynamic> hrStream = StreamController.broadcast();
  int sdkType = Constants.e66;

  ValueNotifier<bool> isHRConfiguring = ValueNotifier(false);
  ValueNotifier<bool> isBPConfiguring = ValueNotifier(false);

// This constructor initialize listeners
  Connections({
    this.scanDeviceListener,
    this.scanBLEDeviceListener,
    this.performerListener,
    this.blePerformerListener,
    this.measurementListener,
    this.vibrateListener,
    this.hourlyPPGListener,
    this.weightScaleListener,
    this.appNotificationListener,
    this.assistantQueryListener,
    this.heartRateFromRunModeListener,
  }) {
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      Constants.platform.setMethodCallHandler(_handler);
    });
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// check whether bracelet connected or not.
  /// @isFromMeasurement pass true if you want to check connection before start measurement
  /// @Return return true if connected else return false
  Future<bool> isConnected(int sdkType, {bool? isFromMeasurement}) async {
    Map map = {
      'isCameFromMeasurement': isFromMeasurement,
      'type': sdkType,
    };
    var result;

    result = await Constants.platform.invokeMethod('checkConnectionStatus', map);

    if (result != null && result is int && result == 1) {
      return true;
    }
    if (result != null && result is bool) {
      return result;
    }
    return false;
  }

  Future<bool> isBLEConnected() async {
    var result;
    result = await Constants.platform.invokeMethod('checkBLEConnectionStatus');

    if (result != null && result is int && result == 1) {
      return true;
    }
    if (result != null && result is bool) {
      return result;
    }
    return false;
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// This methods used to start scanning or finding bluetooth devices
  void startScan(int sdkType, {bool? isForWeightScale}) async {
    print('start scan called !!!');
    // requestHealthKitOrGoogleFitAuthorization();

    Map map = {'isForWeightScale': isForWeightScale, 'sdkType': sdkType};

    Future.delayed(Duration(seconds: 1)).then((_) {
      // if(logRef != null){
      //   logRef.child('connection screen logs').push().set({
      //     'msg ': 'start scan method called!!!',
      //     'methodName':'getDeviceList',
      //     'at':DateTime.now().toString(),
      //     'line':StackTrace.current.toString()
      //   });
      // }

      // Constants.platform.invokeMethod('getDeviceList',isForWeightScale);
      dynamic result = Constants.platform.invokeMethod('getDeviceList', map);
    });
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// This method used to stop scanning or finding bluetooth devices
  void stopScan() {
    var map = {};
    map['sdkType'] = sdkType;
    Constants.platform.invokeMethod('stopScan', map);
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// This method used to connect particular bluetooth device(bracelet)
  /// @model method need DeviceModel to make connection with that device.
  /// @Return return true if connected successfully else return false
  Future<bool> connectToDevice(DeviceModel? model) async {
    print('connectToDevice ${model!.toMap().toString()}');
    final result = await Constants.platform.invokeMethod('connectToDevice', model?.toMap());
    if (result is bool && result) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<bool> connectToBLEDevice(BLEDeviceModel? blemodel) async {
    final result = await Constants.platform.invokeMethod('connectToBLEDevice', blemodel?.toMap());
    if (result is bool && result) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  goToBle() {
    Constants.platform.invokeMethod('goToBle');
  }

  /// Added by: chandresh
  /// Added at: 21-15-2020
  /// This method used to connect particular bluetooth device(bracelet)
  /// @model method need DeviceModel to make connection with that device.
  /// @Return return true if connected successfully else return false
  Future getDataForE66() async {
    print('getDataForE66');
    final result = await Constants.platform.invokeMethod('getDataForE66');
    return Future.value();
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// This method used to disconnect bluetooth device(bracelet)
  /// @Return return true if disconnected successfully else return false
  Future<bool> disConnectToDevice() async {
    var map = {};
    map['sdkType'] = sdkType;
    final result = await Constants.platform.invokeMethod('disConnectToDevice', map);
    if (result is bool && result) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future disConnectToBLEDevice() async {
    final result = await Constants.platform.invokeMethod('disConnectToBLEDevice');
    if (result is bool && result) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  /// Added by: shahzad
  /// Added on: 17-09-2020
  /// this method is used to disconnect weight scale device
  Future disconnectWeightDevice() async {
    await Constants.platform.invokeMethod('disconnectWeightScaleDevice');
  }

  /// Added by: shahzad
  /// Added on 06-10-2020
  /// this method is used to change the unit of weight scale device
  Future changeWeightScaleUnit(var unitValue) async {
    if (Platform.isAndroid) {
      unitValue--;
      unitValue = {'type': unitValue};
    }
    await Constants.platform.invokeMethod('changeWeightScaleUnit', unitValue);
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// This is callback function which used to get callback from native (android/ios).
  /// scanned devices, device information(battery,mac), sport info, sleep info, offline ecg and ppg info info, find bracelet
  /// @call particular channel callbacks.
  Future _handler(MethodCall call) async {
    var result = call.arguments;

    // if (isSocketConnected.value == true && result != null) {
    //   print('Enterddddd in socket emmmiiiittt');
    //   instanceOfSocket!.emitData('message', {'command': 'Heartrate', 'heartrate': result});
    // }
    // Fluttertoast.showToast(msg: call.method);
    // if (call.method == 'onGetHRData') {
    //   isHRdata.value = true;
    // } else {
    //   isHRdata.value = false;
    // }

    switch (call.method) {
      case 'syncWatchData':
        print('Requesting from Flutter :: ${DateTime.now()}');
        CronHelper.instance.syncWatchData();
        // HKGFHelper.instance.synchronizeHKGFData();
        break;
      case 'getDeviceList':
        if (result is Map) {
          var device = DeviceModel.fromMap(result);
          scanDeviceListener?.onDeviceFound(device);
        }
        break;

      case 'getBLEDeviceList':
        if (result is Map) {
          try {
            var bledevice = BLEDeviceModel.fromMap(result);
            scanBLEDeviceListener?.onBLEDeviceFound(bledevice);
          } catch (e) {
            print('getBLEDeviceList_Exception  ${e.toString()}');
          }
        }
        break;
      case 'onResponseDeviceInfo':
        if (result is Map) {
          var deviceInfoModel = DeviceInfoModel.fromMap(result);
          performerListener?.onResponseDeviceInfo(deviceInfoModel);
        }
        break;
      case 'onResponseMotionInfoE66':
        if (result is List) {
          var modelList = result.map((e) {
            if (e?.containsKey('date') ?? false) {
              var dateTime = DateFormat(DateUtil.yyyyMMdd).parse(e['date']);
              dateTime = dateTime.add(Duration(minutes: 1));
              var date = DateFormat(DateUtil.yyyyMMddHHmmss).format(dateTime);
              e['date'] = date;
            }
            return MotionInfoModel.fromMap(e);
          }).toList();

          performerListener?.onResponseMotionInfoE66(modelList);
        }
        break;
      case 'onResponseSleepInfoE66':
        if (result is List) {
          var modelList = result.map((e) {
            if (e?.containsKey('date') ?? false) {
              var dateTime = DateFormat(DateUtil.yyyyMMdd).parse(e['date']);
              dateTime = dateTime.add(Duration(minutes: 1));
              var date = DateFormat(DateUtil.yyyyMMddHHmmss).format(dateTime);
              e['date'] = date;
            }
            return SleepInfoModel.fromMap(e);
          }).toList();
          performerListener?.onResponseSleepInfoE66(modelList);
        }
        break;
      case 'onResponsePoHeartInfo':
        if (result is Map) {
          var heartInfoModel = HeartInfoModel.fromMap(result);

          performerListener?.onResponsePoHeartInfo(heartInfoModel);
        }
        break;
      case 'onGetHeartRateData':
        try {
          if (result is List) {
            for (var item in result) {
              print('onGetHeartRateData : ${item.toString()}');
            }
            var listOfModel = result.map((e) => SyncHRModel.fromJsonSync(e)).toList();
            performerListener!.onResponseE66HeartInfo(listOfModel);
          }
        } catch (e) {
          print(e);
        }
        break;
      case 'onResponseWoHeartInfo':
        if (result is Map) {
          var woHeartInfoModel = WoHeartInfoModel.fromMap(result);

          performerListener?.onResponseWoHeartInfo(woHeartInfoModel);
        }
        break;
      case 'onResponseEcgInfo':
        if (result is Map) {
          var ecgInfoModel = EcgInfoReadingModel.fromMap(result);
          if ((ecgInfoModel.pointList?.length ?? 0) > 0) {
            measurementListener?.onGetEcgFromE66(ecgInfoModel);
          } else {
            measurementListener?.onGetEcg(ecgInfoModel);
          }
          if (hourlyPPGListener != null) {
            // hourlyPPGListener.onResponseEcg(ecgInfoModel);
          }
        }
        break;
      case 'onResponseLeadStatus':
        if (result is Map) {
          var leadStatusModel = LeadOffStatusModel.fromMap(result);

          measurementListener?.onGetLeadStatus(leadStatusModel);
        }
        break;
      case 'onResponsePpgInfo':
        if (result is Map) {
          var ppgInfoModel = PpgInfoReadingModel.fromMap(result);
          if ((ppgInfoModel.pointList?.length ?? 0) > 0) {
            measurementListener?.onGetPpgFromE66(ppgInfoModel);
          } else {
            measurementListener?.onGetPpg(ppgInfoModel);
          }
          if (hourlyPPGListener != null) {
            // hourlyPPGListener.onResponsePPG(ppgInfoModel);
          }
        }
        break;
//      case 'onGetLeadOff':
//        if (result != null) {
//          measurementListener.onGetLeadOff(result);
//        }
//        break;
//      case 'onGetPoorConductivity':
//        if (result != null) {
//          measurementListener.onGetPoorConductivity(result);
//        }
//         break;

      case 'onConnectIosDevice':
        if (result is Map) {
          var device = DeviceModel.fromMap(result);
          performerListener?.onConnectIosDevice(device);
        }
        break;

      case 'vibrate':
        print('result_vibrate $result');
        break;
      case 'alarmReceiver':
        print('alarmReceiver $result');
        break;

      /// Added by: shahzad
      /// Added on: 16-09-2020
      /// this method is used to get the weight scale measurement data
      case 'onGetWeightScaleData':
        if (result is Map) {
          var weightMeasurementModel = WeightMeasurementModel.fromMap(result);
          weightScaleListener?.onGetWeightScaleData(weightMeasurementModel);
        }
        break;

      /// Added by: shahzad
      /// Added on: 17-09-2020
      /// this method is used to show the user that device is connected and he can now measure the weight
      case 'onDeviceConnected':
        if (result != null) {
          if (result is int) {
            weightScaleListener?.onDeviceConnected(result);
          }
        }
        break;
      case 'onReceiveMessage':
        if (result != null) {
          if (result is Map) {
            var model = NotificationModel.fromMap(result);
            appNotificationListener?.onReceiveNotification(model);
          }
        }
        break;
      case 'onGetTempData':
        try {
          if (result is List) {
            for (var item in result) {
              print('onGetTempData : ${item.toString()}');
            }
            var list =
            result.map((e) => OTHistoryModel.fromJsonSync(e.cast<String, dynamic>())).toList();
            performerListener!.onResponseTempData(list);
          }
        } catch (e) {
          print(e);
        }
        break;
      case 'onGetHRData':
        if (result is Map) {
          performerListener?.onGetHRData(result);
        }
        break;

      case 'onGetMeasurementQuery':
        if (result != null) {
          assistantQueryListener?.onGetMeasurementQuery(result);
        }
        break;

      case 'onResponseE80RealTimeMotionData':
        if (result is Map) {
          performerListener?.onResponseE80RealTimeMotionData(result);
        }
        break;

      case 'onGetHeartRateFromRunMode':
        print('onGetHeartRateFromRunMode');
        if (result is num) {
          heartRateFromRunModeListener?.onGetHeartRateFromRunMode(result.toInt());
        }
        break;

      case 'onGetRealTemp':
        if (result is num) {
          print('result_ $result');
          performerListener?.onGetRealTemp(result);
        }
        break;

      case 'onResponseCollectBP':
        if (result is List) {
          for (var item in result) {
            print('onResponseCollectBP : ${item.toString()}');
          }
          var listOfModel = result.map((e) => BPHistoryModel.fromJsonSync(e)).toList();
          performerListener?.onResponseBPData(listOfModel);
        }
        break;
      case 'deviceConfigurationInfo':
        if (result is Map) {
          var deviceConfigurationModel = DeviceConfigurationModel.fromMap(result);
          performerListener?.deviceConfigurationInfo(deviceConfigurationModel);
        }
    }
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this method is use for start ecg and ppg reading
  /// @return returns true if successfully started otherwise return false.
  Future<bool> startMeasurement() async {
    var map = {};
    map['sdkType'] = sdkType;
    final result = await Constants.platform.invokeMethod('startMeasurement', map);
    print('startMeasurementstartMeasurement $result');
    if (result is bool && result) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  /// Added by: chandresh
  /// Added at: 24-12-2020
  /// this method is use for get temperature data
  /// @return returns true if get successfully.
  Future<bool> getTempData() async {
    final result = await Constants.platform.invokeMethod('getTempData');
    if (result is bool && result) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<String> getMemoryData() async {
    final result = await Constants.platform.invokeMethod('collectMemory');
    if (result is String) {
      return Future.value(result);
    }
    return Future.value('Something went wrong');
  }

  Future<bool> invokeGC() async {
    final result = await Constants.platform.invokeMethod('invokeGc');
    if (result is bool && result) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this method is use for stop reading
  /// @return returns true if successfully stop otherwise return false.
  /// connections.stopMeasurement();
  Future<bool> stopMeasurement() async {
    Map map = {};
    map['sdkType'] = sdkType;
    final result = await Constants.platform.invokeMethod('stopMeasurement', sdkType);
    if (result is bool && result) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this method is use to find bracelet
  getVibrationBracelet() async {
    var map = {};
    map['sdkType'] = sdkType;
    print('initializeConnection :: sdkType 3 :: $map');
    final result = await Constants.platform.invokeMethod('vibrate', map);
    print('-------------->>>>>>>>>>>$result');
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this method is use to set calibration for blood pressure
  setCelebration({required int hr, required int sbp, required int dbp}) async {
    final result = await Constants.platform.invokeMethod('Calibration', {
      'hr': hr,
      'sbp': sbp,
      'dbp': dbp,
      'sdkType': sdkType,
    });
  }

  /// Added by: chandresh
  /// Added at: 23-12-2020
  /// this method is use to set calibration for blood pressure in e66 device
  setCelebrationInE66({required int value}) async {
    final result = await Constants.platform.invokeMethod('setCelebrationInE66', value);
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this method is use to enable disable bracelet screen while wrist lift
  /// @isLiftTheWristBrightnessOn true for enable it false for disable it.
  /// @return true after set successfully.
  Future setLiftTheWristBrightnessOn(bool isLiftTheWristBrightnessOn) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['isLiftTheWristBrightnessOn'] = isLiftTheWristBrightnessOn;
    final result = await Constants.platform.invokeMethod('setLiftBrighten', map);
    return result;
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this method is use to enable disable do not disturb mode in bracelet.
  /// @enable true for enable it false for disable it.
  /// @return true after set successfully.
  Future setDoNotDisturb(bool enable) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = enable;
    final result = await Constants.platform.invokeMethod('setDoNotDisturb', map);
    return result;
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this method is use to set time format in bracelet.
  /// @enable true for 24h false for 12h.
  /// @return true after set successfully.
  Future setTimeFormat(bool enable) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = enable;
    final result = await Constants.platform.invokeMethod('setTimeFormat', map);
    return result;
  }

  Future<dynamic> configurationLoader(BuildContext context, String type) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.h),
              ),
              elevation: 0,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColor.darkBackgroundColor
                        : AppColor.backgroundColor,
                    borderRadius: BorderRadius.circular(10.h),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(-5, -5),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#000000').withOpacity(0.75)
                            : HexColor.fromHex('#384341').withOpacity(0.9),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(5, 5),
                      ),
                    ]),
                padding: EdgeInsets.only(bottom: 22.w, top: 22.w),
                width: 200.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Body1AutoText(
                          text: 'Configuring $type Monitoring',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                              : HexColor.fromHex('#384341'),
                          maxLine: 2,
                          minFontSize: 16,
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this method is use to enable monitor heart rate hourly.
  /// @enable true for enable false for disable.
  /// @return true after set successfully.
  Future setHourlyHrMonitorOn(bool enable, int timeInterval,
      {bool showLoader = false, BuildContext? context}) async {
    if (showLoader && context != null) {
      isHRConfiguring.value = true;
      configurationLoader(context, 'HR');
      Future.delayed(Duration(seconds: 5), () {
        isHRConfiguring.value = false;
        Navigator.of(context, rootNavigator: true).pop();
      });
    }
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = enable;
    map['timeInterval'] = 5;
    final result = await Constants.platform.invokeMethod('setHourlyHrMonitorOn', map);
    return result;
  }

  Future<bool> getHrData() async {
    var result;
    Map map = {
      'type': sdkType,
    };
    if (Platform.isIOS) {
      result = await Constants.platform.invokeMethod('onGetHRData', map);
    } else {
      result = await Constants.platform.invokeMethod('onGetHRData');
    }
    return result;
  }

  Future<int> getAllWatchHistory() async {
    var result;
    var map = {
      'type': sdkType,
    };
    if (Platform.isIOS) {
      result = await Constants.platform.invokeMethod('getAllWatchdata', map);
    } else {
      result = await Constants.platform.invokeMethod('getAllWatchdata');
    }
    return 1;
  }

  Future setBPMonitorOn(bool enable, int timeInterval,
      {bool showLoader = false, BuildContext? context}) async {
    if (showLoader && context != null) {
      isBPConfiguring.value = true;
      configurationLoader(context, 'BP');
      Future.delayed(Duration(seconds: 5), () {
        isBPConfiguring.value = false;
        Navigator.of(context, rootNavigator: true).pop();
      });
    }
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = enable;
    map['timeInterval'] = 5;
    final result = await Constants.platform.invokeMethod('setBpMonitoring', map);
    print('setBPMonitorOnsetBPMonitorOn $result');
    return result;
  }

  Future setTemperatureMonitorOn(bool enable, int timeInterval,
      {bool showLoader = false, BuildContext? context}) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = enable;
    map['timeInterval'] = timeInterval;
    final result = await Constants.platform.invokeMethod('setTemperatureMonitorOn', map);
    return result;
  }

  Future setOxygenMonitorOn(bool enable, int timeInterval,
      {bool showLoader = false, BuildContext? context}) async {
    if (showLoader && context != null) {
      isHRConfiguring.value = true;
      configurationLoader(context, 'SPO2');
      Future.delayed(Duration(seconds: 5), () {
        isHRConfiguring.value = false;
        Navigator.of(context, rootNavigator: true).pop();
      });
    }
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = enable;
    map['timeInterval'] = 5;
    final result = await Constants.platform.invokeMethod('setOxygenMonitorOn', map);
    return result;
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this method is use to set wear type.
  /// @enable true for left hand, false for right hand.
  /// @return true after set successfully.
  Future setWearType(bool isWearOnLeft) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = !isWearOnLeft;
    final result = await Constants.platform.invokeMethod('setWearType', map);
    return result;
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this method is use to set user data in bracelet (height, weight, sex, age).
  /// @map key value pair of user information.
  /// 'Height' - int
  // 'Weight' - int
  // 'Age' - int
  //'Gender' - 'M' for male 'F' for female
  /// @return true after set successfully.
  Future setUserData(Map map) async {
    map['sdkType'] = sdkType;
    final result = await Constants.platform.invokeMethod('setUserData', map);
    return result;
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this method is use to set user data in bracelet (height, weight, sex, age).
  /// @map key value pair of user information.
  /// 'Height' - int
  // 'Weight' - int
  // 'Age' - int
  //'Gender' - 'M' for male 'F' for female
  /// @return true after set successfully.
  Future openNotificationDialog() async {
    final result = await Constants.platform.invokeMethod('openNotificationScreen');
    return result;
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this methods use to enable app reminders
  ///@isEnable pass true for enable, false for disable.
  /// @return true after set successfully.
  Future setCallEnable(bool isEnable) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = isEnable;
    final result = await Constants.platform.invokeMethod('setCallEnable', map);
    return result;
  }

  Future setMessageEnable(bool isEnable) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = isEnable;
    final result = await Constants.platform.invokeMethod('setMessageEnable', map);
    return result;
  }

  Future setQqEnable(bool isEnable) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = isEnable;
    final result = await Constants.platform.invokeMethod('setQqEnable', map);
    return result;
  }

  Future setWeChatEnable(bool isEnable) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = isEnable;
    final result = await Constants.platform.invokeMethod('setWeChatEnable', map);
    return result;
  }

  Future setLinkedInEnable(bool isEnable) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = isEnable;
    final result = await Constants.platform.invokeMethod('setLinkedInEnable', map);
    return result;
  }

  Future setSkypeEnable(bool isEnable) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = isEnable;
    final result = await Constants.platform.invokeMethod('setSkypeEnable', map);
    return result;
  }

  Future setFacebookMessengerEnable(bool isEnable) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = isEnable;
    final result = await Constants.platform.invokeMethod('setFacebookMessengerEnable', map);
    return result;
  }

  Future setTwitterEnable(bool isEnable) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = isEnable;
    final result = await Constants.platform.invokeMethod('setTwitterEnable', map);
    return result;
  }

  Future setWhatsAppEnable(bool isEnable) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = isEnable;
    final result = await Constants.platform.invokeMethod('setWhatsAppEnable', map);
    return result;
  }

  Future setViberEnable(bool isEnable) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = isEnable;
    final result = await Constants.platform.invokeMethod('setViberEnable', map);
    return result;
  }

  Future setLineEnable(bool isEnable) async {
    var map = {};
    map['sdkType'] = sdkType;
    map['enable'] = isEnable;
    final result = await Constants.platform.invokeMethod('setLineEnable', map);
    return result;
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this methods use to enable app reminders
  /// @return true for enabled, false for disable.
  Future<bool> getCallEnable() async {
    final result = await Constants.platform.invokeMethod('getCallEnable');
    return result;
  }

  Future<bool> getMessageEnable() async {
    final result = await Constants.platform.invokeMethod('getMessageEnable');
    return result;
  }

  Future<bool> getQqEnable() async {
    final result = await Constants.platform.invokeMethod('getQqEnable');
    return result;
  }

  Future<bool> getWeChatEnable() async {
    final result = await Constants.platform.invokeMethod('getWeChatEnable');
    return result;
  }

  Future<bool> getLinkedInEnable() async {
    final result = await Constants.platform.invokeMethod('getLinkedInEnable');
    return result;
  }

  Future<bool> getSkypeEnable() async {
    final result = await Constants.platform.invokeMethod('getSkypeEnable');
    return result;
  }

  Future<bool> getFacebookMessengerEnable() async {
    final result = await Constants.platform.invokeMethod('getFacebookMessengerEnable');
    return result;
  }

  Future<bool> getTwitterEnable() async {
    final result = await Constants.platform.invokeMethod('getTwitterEnable');
    return result;
  }

  Future<bool> getWhatsAppEnable() async {
    final result = await Constants.platform.invokeMethod('getWhatsAppEnable');
    return result;
  }

  Future<bool> getViberEnable() async {
    final result = await Constants.platform.invokeMethod('getViberEnable');
    return result;
  }

  Future<bool> getLineEnable() async {
    final result = await Constants.platform.invokeMethod('getLineEnable');
    return result;
  }

  /// Added by: shahzad
  /// Added at: 18-09-2020
  /// this method is use to send the user details (sex, height)
  Future setWeightScaleUserDetails(Map userDetails) async {
    Constants.platform.invokeMethod('setWeightScaleUser', userDetails);
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this methods use to set water,sit and medicine reminders
  /// @model ReminderModel have start time, end time, and interval
  /// @type 1- water, 2-sit, 3- medicine
  Future setDefaultReminder(ReminderModel? model, int? type, int? sdkType) async {
    if (model != null &&
        model.startTime != null &&
        model.endTime != null &&
        model.interval != null &&
        model.isEnable != null) {
      int? interval;
      TimeOfDay? startTimeOfDay;
      TimeOfDay? endTimeOfDay;
      if (model.startTime?.isNotEmpty ?? false) {
        var hour = int.tryParse(model.startTime?.split(':').first ?? '') ?? 0;
        var minute = int.tryParse(model.startTime?.split(':').elementAt(1) ?? '') ?? 0;
        startTimeOfDay = TimeOfDay(hour: hour, minute: minute);
      }
      if (model.endTime?.isNotEmpty ?? false) {
        var hour = int.tryParse(model.endTime?.split(':')[0] ?? '') ?? 0;
        var minute = int.tryParse(model.endTime?.split(':')[1] ?? '') ?? 0;
        endTimeOfDay = TimeOfDay(hour: hour, minute: minute);
      }
      if (model.interval?.contains(stringLocalization.getText(StringLocalization.minute)) ??
          false) {
        var a = model.interval
            ?.replaceFirst(' ${stringLocalization.getText(StringLocalization.minute)}', '');
        interval = int.tryParse(a ?? '0') ?? 0;
      } else if (model.interval?.contains(stringLocalization.getText(StringLocalization.hour)) ??
          false) {
        var a = model.interval
            ?.replaceFirst(' ${stringLocalization.getText(StringLocalization.hour)}', '');
        interval = int.parse(a ?? '0');
      }

      Map map = {
        'startHour': int.tryParse(startTimeOfDay?.hour.toString().padLeft(2, '0') ?? '') ?? 0,
        'startMinute': int.tryParse(startTimeOfDay?.minute.toString().padLeft(2, '0') ?? '') ?? 0,
        'endHour': int.tryParse(endTimeOfDay?.hour.toString().padLeft(2, '0') ?? '') ?? 0,
        'endMinute': int.tryParse(endTimeOfDay?.minute.toString().padLeft(2, '0') ?? '') ?? 0,
        'interval': interval ?? 0,
        'isEnable': model.isEnable ?? false,
        'sdkType': sdkType
      };

      if (sdkType == Constants.e66 && type == 2) {
        TimeOfDay? secondStartTimeOfDay;
        TimeOfDay? secondEndTimeOfDay;
        if (model.secondStartTime?.isNotEmpty ?? false) {
          var hour = int.tryParse(model.secondStartTime?.split(':')[0] ?? '') ?? 0;
          var minute = int.tryParse(model.secondStartTime?.split(':')[1] ?? '') ?? 0;
          secondStartTimeOfDay = TimeOfDay(hour: hour, minute: minute);
        }
        if (model.secondEndTime?.isNotEmpty ?? false) {
          var hour = int.tryParse(model.secondEndTime?.split(':')[0] ?? '') ?? 0;
          var minute = int.tryParse(model.secondEndTime?.split(':')[1] ?? '') ?? 0;
          secondEndTimeOfDay = TimeOfDay(hour: hour, minute: minute);
        }

        map['startHour'] = startTimeOfDay?.hour ?? 0;
        map['startMinute'] = startTimeOfDay?.minute ?? 0;
        map['endHour'] = endTimeOfDay?.hour ?? 0;
        map['endMinute'] = endTimeOfDay?.minute ?? 0;
        map['secondStartHour'] = secondStartTimeOfDay?.hour ?? 0;
        map['secondStartMinute'] = secondStartTimeOfDay?.minute ?? 0;
        map['secondEndHour'] = secondEndTimeOfDay?.hour ?? 0;
        map['secondEndMinute'] = secondEndTimeOfDay?.minute ?? 0;
      }

      var result;
      switch (type) {
        case 1:
          result = await Constants.platform.invokeMethod('setWaterReminder', map);
          break;
        case 2:
          result = await Constants.platform.invokeMethod('setSitReminder', map);
          break;
        case 3:
          result = await Constants.platform.invokeMethod('setMedicalReminder', map);
          break;
      }

      return result;
    }
    return Future.value();
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this methods use to set custom alarm
  /// @model ReminderModel have start time, end time, and interval
  /// @id unique int number
  /// @return true for enabled, false for disable.
  Future setCustomReminder(ReminderModel model, int id, int sdkType) async {
    if (model != null &&
        model.startTime != null &&
        model.endTime != null &&
        model.interval != null &&
        model.isEnable != null) {
      Duration duration;
      int? milliSeconds;
      TimeOfDay? startTimeOfDay;
      TimeOfDay? endTimeOfDay;
      if (model.startTime?.isNotEmpty ?? false) {
        var hour = int.tryParse(model.startTime?.split(':')[0] ?? '') ?? 0;
        var minute = int.tryParse(model.startTime?.split(':')[1] ?? '') ?? 0;
        startTimeOfDay = TimeOfDay(hour: hour, minute: minute);
      }
      if (model.endTime?.isNotEmpty ?? false) {
        var hour = int.tryParse(model.endTime?.split(':')[0] ?? '') ?? 0;
        var minute = int.tryParse(model.endTime?.split(':')[1] ?? '') ?? 0;
        endTimeOfDay = TimeOfDay(hour: hour, minute: minute);
      }
      if (model.interval?.contains(stringLocalization.getText(StringLocalization.minute)) ??
          false) {
        var a = model.interval
                ?.replaceFirst(' ${stringLocalization.getText(StringLocalization.minute)}', '') ??
            '';
        if ((int.tryParse(a) ?? 0) > 0) {
          milliSeconds = int.parse(a) * 60000;
        }
        duration = new Duration(minutes: int.parse(a));
      } else if (model.interval?.contains(stringLocalization.getText(StringLocalization.hour)) ??
          false) {
        var a = model.interval
                ?.replaceFirst(' ${stringLocalization.getText(StringLocalization.hour)}', '') ??
            '';
        if ((int.parse(a)) > 0) {
          milliSeconds = (int.parse(a) * 60) * 60000;
        }
        duration = new Duration(hours: int.parse(a));
      }

      var startTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          startTimeOfDay?.hour ?? 0, startTimeOfDay?.minute ?? 0);
      var endTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          endTimeOfDay?.hour ?? 0, endTimeOfDay?.minute ?? 0);

      var differentInMinutes = endTime.difference(startTime).inMinutes;

      var endHour = startTime.add(Duration(minutes: differentInMinutes ~/ 2)).hour;

      var days = model.days?.where((m) => m['isSelected']).toList() ?? [];
      Map map = {
        'id': int.parse('$id${startTimeOfDay?.hour ?? 0}${startTimeOfDay?.minute ?? 0}'),
        'startHour': startTimeOfDay?.hour,
        'startMinute': startTimeOfDay?.minute,
        'endHour': endTimeOfDay?.hour,
        'endMinute': endTimeOfDay?.minute,
        'interval': milliSeconds ?? 0,
        'days': days.map((m) => m['day']).toList(),
        'isEnable': model.isEnable,
      };

      if (sdkType == Constants.e66) {
        map['startHour'] = startTimeOfDay?.hour ?? 0;
        map['startMinute'] = startTimeOfDay?.minute ?? 0;
        map['endHour'] = endHour;
        map['endMinute'] = 0;

        map['secondStartHour'] = endHour;
        map['secondStartMinute'] = 0;
        map['secondEndHour'] = endTimeOfDay?.hour ?? 0;
        map['secondEndMinute'] = endTimeOfDay?.minute ?? 0;
      }

      final result = await Constants.platform.invokeMethod('addAlarm', map);

      return result;
    }
    return Future.value();
  }

  /// Added by: chandresh
  /// Added at: 28-05-2020
  /// this methods use to set cancel custom alarm
  /// @model ReminderModel have start time, end time, and interval
  /// @id unique int number
  /// @return true for enabled, false for disable.
  Future cancelCustomReminder(ReminderModel model, int id) async {
    if (model.startTime != null &&
        model.endTime != null &&
        model.interval != null &&
        model.isEnable != null) {
      TimeOfDay? startTimeOfDay;
      TimeOfDay? endTimeOfDay;
      if (model.startTime?.isNotEmpty ?? false) {
        var hour = int.tryParse(model.startTime?.split(':')[0] ?? '') ?? 0;
        var minute = int.tryParse(model.startTime?.split(':')[1] ?? '') ?? 0;
        startTimeOfDay = TimeOfDay(hour: hour, minute: minute);
      }
      if (model.endTime?.isNotEmpty ?? false) {
        var hour = int.tryParse(model.endTime?.split(':')[0] ?? '') ?? 0;
        var minute = int.tryParse(model.endTime?.split(':')[1] ?? '') ?? 0;
        endTimeOfDay = TimeOfDay(hour: hour, minute: minute);
      }

      var days = model.days?.where((m) => m['isSelected']).toList() ?? [];
      var map = {
        'id': int.parse('$id${startTimeOfDay?.hour ?? 0}${startTimeOfDay?.minute ?? 0}'),
        'startHour': startTimeOfDay?.hour ?? 0,
        'startMinute': startTimeOfDay?.minute ?? 0,
        'endHour': endTimeOfDay?.hour ?? 0,
        'endMinute': endTimeOfDay?.minute ?? 0,
        'interval': 0,
        'days': days.map((m) => m['day']).toList(),
        'isEnable': false,
      };
      map['sdkType'] = sdkType;
      final result = await Constants.platform.invokeMethod('addAlarm', map);

      return result;
    }
    return Future.value();
  }

  Future setAlarm(AlarmModel model) async {
    if (model.alarmTime != null &&
        model.id != null &&
        model.isRepeatEnable != null &&
        model.isAlarmEnable != null) {
      TimeOfDay? alarmTime;
      TimeOfDay? previousTime;
      if (model.alarmTime?.isNotEmpty ?? false) {
        var hour = int.tryParse(model.alarmTime?.split(':')[0] ?? '') ?? 0;
        var minute = int.tryParse(model.alarmTime?.split(':')[1] ?? '') ?? 0;
        alarmTime = TimeOfDay(hour: hour, minute: minute);
      }
      if (model.previousAlarmTime?.isNotEmpty ?? false) {
        var hour = int.tryParse(model.previousAlarmTime?.split(':')[0] ?? '') ?? 0;
        var minute = int.tryParse(model.previousAlarmTime?.split(':')[1] ?? '') ?? 0;
        previousTime = TimeOfDay(hour: hour, minute: minute);
      }
      if (Platform.isAndroid) {
        var days = <int>[];
        for (var i = 0; i < (model.days?.length ?? 0); i++) {
          switch (i) {
            case 0:
              days.add(model.days?.last);
              break;
            default:
              days.add(model.days?.elementAt(i - 1));
              break;
          }
        }
        var positions = <int>[];
        if (days.contains(1)) {
          for (var i = 0; i < days.length; i++) {
            if (days[i] > 0) {
              positions.add(i + 1);
            }
          }
        } else {
          days.clear();
        }
        var map = {
          'id': int.parse('${model.id}${alarmTime?.hour ?? 0}${alarmTime?.minute ?? 0}'),
          'startHour': alarmTime?.hour ?? 0,
          'startMinute': alarmTime?.minute ?? 0,
          'endHour': alarmTime?.hour ?? 0,
          'endMinute': (alarmTime?.minute ?? 0) < 60
              ? (alarmTime?.minute ?? 0) + 1
              : (alarmTime?.minute ?? 0),
          'interval': 0,
          'days': positions,
          'isEnable': model.isAlarmEnable,
        };

        var result;
        if (previousTime != null) {
          map['previousStartHour'] = previousTime.hour;
          map['previousStartMinute'] = previousTime.minute;

          map['sdkType'] = sdkType;
          result = await Constants.platform.invokeMethod('updateSdkAlarm', map);
        } else {
          map['sdkType'] = sdkType;
          result = await Constants.platform.invokeMethod('addAlarm', map);
        }
        return result;
      } else {
        var map = {
          'id': model.id,
          'alarmHour': alarmTime?.hour ?? 0,
          'alarmMin': alarmTime?.minute ?? 0,
          'days': model.days,
          'repeat': model.isRepeatEnable,
          'slider': model.isAlarmEnable
        };
        map['sdkType'] = sdkType;
        final result = await Constants.platform.invokeMethod('addSDKAlarm', map);
        return result;
      }
    }
    return Future.value();
  }

  Future setAlarmInE80(E80SetAlarmModel model) async {
    if (model != null &&
        model.hour != null &&
        model.minute != null &&
        model.days != null &&
        model.isAlarmEnable != null) {
      Map map = {
        'startHour': model.hour,
        'startMinute': model.minute,
        'delay': model.delayTime,
        'type': model.type ?? 7,
        'repeat': model.repeatBits,
      };
      final result = await Constants.platform.invokeMethod('addE80SDKAlarm', map);
      return result;
    }
    return Future.value();
  }

  Future modifyAlarmInE80(E80SetAlarmModel model) async {
    if (model != null &&
        model.hour != null &&
        model.minute != null &&
        model.days != null &&
        model.isAlarmEnable != null) {
      Map map = {
        'oldHour': model.oldHr ?? 0,
        'oldMinute': model.oldMin ?? 0,
        'startHour': model.hour,
        'startMinute': model.minute,
        'delay': model.delayTime,
        'type': model.type ?? 7,
        'repeat': model.repeatBits,
      };
      final result = await Constants.platform.invokeMethod('modifyE80SDKAlarm', map);
      return result;
    }
    return Future.value();
  }

  Future deleteAlarmInE80(E80SetAlarmModel model) async {
    if (model != null &&
        model.hour != null &&
        model.minute != null &&
        model.days != null &&
        model.isAlarmEnable != null) {
      Map map = {
        'startHour': model.hour,
        'startMinute': model.minute,
      };
      final result = await Constants.platform.invokeMethod('deleteE80SDKAlarm', map);
      return result;
    }
    return Future.value();
  }

  Future setStepTarget(int target) async {
    var map = {};
    map['sdkType'] = sdkType;
    map.putIfAbsent('target', () => target);
    final result = await Constants.platform.invokeMethod('setStepTarget', map);
    return result;
  }

  Future<int> getStepTarget() async {
    var stepTarget = 8000;
    if (Platform.isAndroid) {
      var map = {};
      map['sdkType'] = sdkType;
      final result = await Constants.platform.invokeMethod('getStepTarget', map);
      if (result != null && result is int) {
        return result;
      }
    }
    return stepTarget;
  }

  Future requestHealthKitOrGoogleFitAuthorization() async {
    final result = await Constants.platform.invokeMethod('requestHealthKitAuthorization');
    return result;
  }

  Future<bool> checkAuthForGoogleFit() async {
    final result = await Constants.platform.invokeMethod('requestAccess');
    print('object$result');
    return result;
  }

  Future<List> readStepDataFromHealthKitOrGoogleFit(String startDate, String endDate,
      {bool showProgress = false}) async {
    try {
      var map = {'startDate': startDate, 'endDate': endDate};
      if (showProgress) {
        HKGFHelper.instance.perStep.value = 10;
      }
      final result = await Constants.platform.invokeMethod('readStepsData', map);
      if (showProgress) {
        HKGFHelper.instance.perStep.value = 20;
      }
      return result;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> readDistanceDataFromHealthKitOrGoogleFit(String startDate, String endDate,
      {bool showProgress = false}) async {
    try {
      var map = {'startDate': startDate, 'endDate': endDate};
      print('readDistanceData :: $startDate, $endDate');
      if (showProgress) {
        HKGFHelper.instance.perDistance.value = 10;
      }
      final result = await Constants.platform.invokeMethod('readDistanceData', map);
      if (showProgress) {
        HKGFHelper.instance.perDistance.value = 20;
      }
      return result;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> readSleepDataFromHealthKitOrGoogleFit(String startDate, String endDate,
      {bool showProgress = false}) async {
    try {
      var map = {'startDate': startDate, 'endDate': endDate};
      if (showProgress) {
        HKGFHelper.instance.perSleep.value = 10;
      }
      print(map);
      final result = await Constants.platform.invokeMethod('readSleepData', map);

      print(result);

      if (showProgress) {
        HKGFHelper.instance.perSleep.value = 20;
      }
      return result;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> readHeightDataFromHealthKitOrGoogleFit(String startDate, String endDate) async {
    Map map = {'startDate': startDate, 'endDate': endDate};
    final result = await Constants.platform.invokeMethod('readHeightData', map);
    return result;
  }

  Future<List> readRestingEnergyBurnedDataFromHealthKitOrGoogleFit(String startDate, String endDate,
      {bool showProgress = false}) async {
    try {
      var map = {'startDate': startDate, 'endDate': endDate};
      print('readRestingEnergyBurned startDate: $startDate, endDate: $endDate');
      if (showProgress) {
        HKGFHelper.instance.perRestingCalorie.value = 10;
      }
      final result = await Constants.platform.invokeMethod('readRestingCaloriesData', map);
      print('readRestingEnergyBurned result :: $result');
      if (showProgress) {
        HKGFHelper.instance.perRestingCalorie.value = 20;
      }
      return result;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> readActiveEnergyBurnedDataFromHealthKitOrGoogleFit(String startDate, String endDate,
      {bool showProgress = false}) async {
    try {
      var map = {'startDate': startDate, 'endDate': endDate};
      print('readActiveEnergyBurned startDate: $startDate, endDate: $endDate');
      if (showProgress) {
        HKGFHelper.instance.perActiveCalorie.value = 10;
      }
      final result = await Constants.platform.invokeMethod('readActiveCaloriesData', map);
      print('readActiveEnergyBurned result :: $result');
      if (showProgress) {
        HKGFHelper.instance.perActiveCalorie.value = 20;
      }
      return result;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> readBodyMassDataFromHealthKitOrGoogleFit(String startDate, String endDate,
      {bool showProgress = false}) async {
    try {
      var map = {'startDate': startDate, 'endDate': endDate};
      print('readBodyMassData startDate: $startDate, endDate: $endDate');
      if (showProgress) {
        HKGFHelper.instance.perWeight.value = 10;
      }
      final result = await Constants.platform.invokeMethod('readBodyMassData', map);
      print('readBodyMassData result :: $result');
      if (showProgress) {
        HKGFHelper.instance.perWeight.value = 20;
      }
      return result;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> readHeartRateDataFromHealthKitOrGoogleFit(String startDate, String endDate,
      {bool showProgress = false}) async {
    try {
      var map = {'startDate': startDate, 'endDate': endDate};
      if (showProgress) {
        HKGFHelper.instance.perHeartRate.value = 10;
      }
      print('healthKitHr healthKitHr 0');
      final result = await Constants.platform.invokeMethod('readHeartRateData', map);
      print('healthKitHr healthKitHr ${result.toString()}');
      print(result);
      if (showProgress) {
        HKGFHelper.instance.perHeartRate.value = 20;
      }
      return result;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> readSystolicBloodPressureDataFromHealthKitOrGoogleFit(
      String startDate, String endDate,
      {bool showProgress = false}) async {
    try {
      var map = {'startDate': startDate, 'endDate': endDate};
      if (showProgress) {
        HKGFHelper.instance.perSBP.value = 10;
      }
      final result = await Constants.platform.invokeMethod('readSystolicBloodPressureData', map);
      if (showProgress) {
        HKGFHelper.instance.perSBP.value = 20;
      }
      return result;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> readDiastolicBloodPressureDataFromHealthKitOrGoogleFit(
      String startDate, String endDate,
      {bool showProgress = false}) async {
    try {
      var map = {'startDate': startDate, 'endDate': endDate};
      if (showProgress) {
        HKGFHelper.instance.perDBP.value = 10;
      }
      final result = await Constants.platform.invokeMethod('readDiastolicBloodPressureData', map);
      if (showProgress) {
        HKGFHelper.instance.perDBP.value = 20;
      }
      return result;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> readHRVDataFromHealthKitOrGoogleFit(String startDate, String endDate) async {
    Map map = {'startDate': startDate, 'endDate': endDate};
    final result = await Constants.platform.invokeMethod('readHRVData', map);
    return result;
  }

  Future<List> readBloodGlucoseDataFromHealthKitOrGoogleFit(String startDate, String endDate,
      {bool showProgress = false}) async {
    try {
      var map = {'startDate': startDate, 'endDate': endDate};
      if (showProgress) {
        HKGFHelper.instance.perBG.value = 10;
      }
      final result = await Constants.platform.invokeMethod('readBloodGlucoseData', map);
      if (showProgress) {
        HKGFHelper.instance.perBG.value = 20;
      }
      return result;
    } catch (e) {
      print(e);
    }
    return [];
  }

  /// Added by: Chaitanya
  /// Added on: Oct/8/2021
  /// method add for temperature data read from google fit
  Future<List> readBodyTemperatureDataFromHealthKitOrGoogleFit(String startDate, String endDate,
      {bool showProgress = false}) async {
    try {
      var map = {'startDate': startDate, 'endDate': endDate};
      if (showProgress) {
        HKGFHelper.instance.perTemperature.value = 10;
      }
      final result = await Constants.platform.invokeMethod('readBodyTemperatureData', map);
      if (showProgress) {
        HKGFHelper.instance.perTemperature.value = 20;
      }
      return result;
    } catch (e) {
      print(e);
    }
    return [];
  }

  /// Added by: Chaitanya
  /// Added on: Oct/8/2021
  /// method add for oxygen data read from google fit
  Future<List> readOxygenSaturationFromHealthKitOrGoogleFit(String startDate, String endDate,
      {bool showProgress = false}) async {
    try {
      var map = {'startDate': startDate, 'endDate': endDate};
      if (showProgress) {
        HKGFHelper.instance.perOxygen.value = 10;
      }
      final result = await Constants.platform.invokeMethod('readOxygenData', map);
      if (showProgress) {
        HKGFHelper.instance.perOxygen.value = 20;
      }
      return result;
    } catch (e) {
      print(e);
    }
    return [];
  }

  /// Added by: Chaitanya
  /// Added on: Oct/8/2021
  /// method add for Respiratory Rate data read from google fit
  Future<List> readRespiratoryRateFromHealthKitOrGoogleFit(String startDate, String endDate) async {
    Map map = {'startDate': startDate, 'endDate': endDate};
    final result = await Constants.platform.invokeMethod('readRespiratoryRate', map);
    return result;
  }

  Future readBodyEcgDataFromHealthKitOrGoogleFit(String startDate, String endDate) async {
    Map map = {'startDate': startDate, 'endDate': endDate};
    final result = await Constants.platform.invokeMethod('readEcgData', map);
    return result;
  }

  Future<bool> isHealthDataAvailable() async {
    final result = await Constants.platform.invokeMethod('isHealthDataAvailable');
    return result;
  }

  Future writeBloodPressureDataInHealthKitOrGoogleFit(Map<String, dynamic> map) async {
    final result = await Constants.platform.invokeMethod('writeBloodPressureData', map);
    return result;
  }

  Future writeStepsDataInHealthKitOrGoogleFit(Map<String, dynamic> map) async {
    final result = await Constants.platform.invokeMethod('writeStepsData', map);
    return result;
  }

  Future writeDistanceDataInHealthKitOrGoogleFit(Map<String, dynamic> map) async {
    final result = await Constants.platform.invokeMethod('writeDistanceData', map);
    return result;
  }

  Future writeHeartRateDataInHealthKitOrGoogleFit(Map<String, dynamic> map) async {
    final result = await Constants.platform.invokeMethod('writeHeartRateData', map);

    return result;
  }

  Future writeWeightDataInHealthKitOrGoogleFit(Map<String, dynamic> map) async {
    final result = await Constants.platform.invokeMethod('writeWeightData', map);
    return result;
  }

  Future writeSleepDataInHealthKitOrGoogleFit(List list) async {
    final result = await Constants.platform.invokeMethod('writeSleepData', list);
    return result;
  }

  Future writeSleepDataInHealthKit(Map<String, dynamic> map) async {
    final result = await Constants.platform.invokeMethod('writeSleepData', map);
    return result;
  }

  Future<DeviceModel?> getWeightScaleDevice() async {
    final result = await Constants.platform.invokeMethod('getConnectedWeightScaleDevice');
    if (result != null) {
      var model = DeviceModel.fromMap(result);
      return model;
    }
    return null;
  }

  void setSleepTarget(int hour, int minutes) async {
    try {
      Map map = {
        'hour': hour,
        'minute': minutes,
      };
      map['sdkType'] = sdkType;
      final result = await Constants.platform.invokeMethod('setSleepTarget', map);
    } catch (e) {
      print('Exception in constant class $e');
    }
  }

  void setCaloriesTarget(int caloriesValue) async {
    try {
      var map = {};
      map['sdkType'] = sdkType;
      map['caloriesValue'] = caloriesValue;
      final result = await Constants.platform.invokeMethod('setCaloriesTarget', map);
    } catch (e) {
      print('Exception in constant class $e');
    }
  }

  void setUnits(Map map) async {
    try {
      map['sdkType'] = sdkType;
      final result = await Constants.platform.invokeMethod('setUnits', map);
    } catch (e) {
      print('Exception in constant class $e');
    }
  }

  void setSkinType(int skinType) async {
    try {
      var map = {};
      map['sdkType'] = sdkType;
      map['skinType'] = skinType;
      final result = await Constants.platform.invokeMethod('setSkinType', map);
    } catch (e) {
      print('Exception in constant class $e');
    }
  }

  void setBrightness(int brightness) async {
    try {
      var map = {};
      map['sdkType'] = sdkType;
      map['brightness'] = brightness;
      final result = await Constants.platform.invokeMethod('setBrightness', map);
    } catch (e) {
      print('Exception in constant class $e');
    }
  }

  Future sendMessage(Map map) async {
    final result = await Constants.platform.invokeMethod('sendMessage', map);
  }

  Future setAppRemindersForE66(int arg1, int arg2) async {
    Map map = {
      'arg1': arg1,
      'arg2': arg2,
    };
    final result = await Constants.platform.invokeMethod('setAppReminderForE66', map);
  }

  Future<int> getCurrentHR() async {
    final result = await Constants.platform.invokeMethod('getCurrentHR');
    print('getCurrentHR $result');
    return result;
  }

  Future tryToReconnect() async {
    if (Platform.isAndroid) {
      final result = await Constants.platform.invokeMethod('tryToReconnect');
    }
    return;
  }

  Future<bool> bluetoothEnable() async {
    try {
      if (Platform.isAndroid) {
        final result = await Constants.platform.invokeMethod('isBluetoothEnable');
        if (result is bool) {
          return Future.value(result);
        }
      }
    } catch (e) {
      print('Exception at bluetoothEnable $e');
    }
    return false;
  }

  Future<DeviceModel?> checkAndConnectDeviceIfNotConnected({bool? doConnect}) async {
    try {
      try {
        if (Platform.isAndroid) {
          var isOn = await bluetoothEnable();
          if (!isOn) {
            return null;
          }
        }
      } catch (e) {
        print('Exception at BluetoothEnable.enableBluetooth $e');
      }
      if (preferences != null) {
        var value = preferences?.getString(Constants.connectedDeviceAddressPrefKey);
        print('Android Issue :: connectedDevice 1 :: $value');
        if (value != null && value.isNotEmpty) {
          var val = jsonDecode(value);
          if (val is Map) {
            var connectedDevice = DeviceModel.fromMap(val);
            connections.sdkType = connectedDevice.sdkType ?? Constants.e66;
            var isConnected = await connections.isConnected(
              connectedDevice.sdkType ?? Constants.e66,
              isFromMeasurement: true,
            );
            print('Android Issue :: connectedDevice 2 :: $connectedDevice');
            print('Android Issue :: connectedDevice 3 :: $isConnected');
            print('Android Issue :: connectedDevice 4 :: ${connectedDevice.sdkType}');
            if (!isConnected) {
              if ((doConnect ?? false) || Platform.isAndroid) {
                isConnected = await connectToDevice(connectedDevice);
                if (isConnected) {
                  print('successFully connected? = $isConnected');
                  performerListener?.onConnectIosDevice(connectedDevice);
                  return connectedDevice;
                } else {
                  print(
                      '\n------------------------------------------------------------------------------------------------\n'
                      'connection failed'
                      '\n------------------------------------------------------------------------------------------------\n');
                  // Fluttertoast.showToast(msg: 'failed to auto connect');return null;
                }
              }
              return null;
            }
            return connectedDevice;
          }
        }
      }
    } catch (e) {
      print('Exception in constant class $e');
    }
    return null;
  }

  Future<E80AlarmListModel?> getE80AlarmList() async {
    try {
      var result = await Constants.platform.invokeMethod('getAlarmListOfE80');
      if (result != null) {
        var data = E80AlarmListModel.fromMap(result);
        return data;
      }
      // List<E80AlarmInfoModel> infoData = [E80AlarmInfoModel(aAlarmHour:1,alarmDelayTime: 15,aAlarmMin: 7,alarmRepeat: 209,alarmType: 3 ),E80AlarmInfoModel(aAlarmHour:14,alarmDelayTime: 30,aAlarmMin: 0,alarmRepeat: 024,alarmType: 6),E80AlarmInfoModel(aAlarmHour:23,alarmDelayTime: 55,aAlarmMin: 0,alarmRepeat: 127,alarmType: 2),E80AlarmInfoModel(aAlarmHour:10,alarmDelayTime: 5,aAlarmMin: 48,alarmRepeat: 200,alarmType: 5),];
      // E80AlarmListModel data = E80AlarmListModel(alarmData: infoData,alarmNum: 4,maxLimitNum: 10,optType: 0);
      // print(data);
      // return(data);
    } on Exception catch (e) {
      print('Exception in getting alarm list from E80 $e');
    }
    return null;
  }

  Future startMode(int mode) async {
    var result = await Constants.platform.invokeMethod('startMode', mode);
    return result;
  }

  Future endMode(int mode) async {
    var result = await Constants.platform.invokeMethod('endMode', mode);
    return result;
  }

  Future collectHeartRateHistory() async {
    final result = await Constants.platform.invokeMethod('collectHeartRateHistory');

    if (result is List) {
      var dataList = result.map((e) => HrMonitorModel.fromMap(e)).toSet().toList();

      return dataList;
    }
    return [];
  }

  Future resetBracelet() async {
    var result = await Constants.platform.invokeMethod('reset');
    return result;
  }

  Future shutdownBracelet() async {
    var result = await Constants.platform.invokeMethod('shutdown');
    return result;
  }

  Future deleteSport() async {
    // return;
    var result = await Constants.platform.invokeMethod('deleteSport');
    return result;
  }

  Future deleteSleep() async {
    // return;
    var result = await Constants.platform.invokeMethod('deleteSleep');
    return result;
  }

  Future deleteHeartRate() async {
    var result = await Constants.platform.invokeMethod('deleteHeartRate');
    return result;
  }

  Future deleteBloodPressure() async {
    var result = await Constants.platform.invokeMethod('deleteBloodPressure');
    return result;
  }

  Future deleteTempAndOxygen() async {
    var result = await Constants.platform.invokeMethod('deleteTempAndOxygen');
    return result;
  }

  Future<CollectEcgModel?> collectECG() async {
    final result = await Constants.platform.invokeMethod('collectECG');
    if (result is Map) {
      var model = CollectEcgModel.fromMap(result);
      return model;
    }
    return null;
  }

  Future getDeviceConfigurationInfo() async {
    final result = await Constants.platform.invokeMethod('getDeviceConfiguration');
  }

  Stream getLocationstream() {
    if (Platform.isIOS) {
      return Constants.eventChannel.receiveBroadcastStream();
    }
    return Stream.empty();
  }
}

/// Added by: chandresh
/// Added at: 28-05-2020
/// this abstract class use to register scan callback
abstract class ScanDeviceListener {
  void onDeviceFound(DeviceModel device);
}

abstract class ScanBLEDeviceListener {
  void onBLEDeviceFound(BLEDeviceModel bledevice);
}

/// Added by: chandresh
/// Added at: 28-05-2020
/// this abstract class use to register connection, sleep and sport callback
abstract class PerformerListener {
  void onConnectIosDevice(DeviceModel? device);

  void onResponseDeviceInfo(DeviceInfoModel deviceInfoModel);

  void onResponseMotionInfoE66(List<MotionInfoModel> mMotionInfoList);

  void onResponseSleepInfoE66(List<SleepInfoModel> mSleepInfoList);

  void onResponsePoHeartInfo(HeartInfoModel mPoHeartInfo);

  void onResponseE66HeartInfo(List<SyncHRModel> map);

  void onResponseWoHeartInfo(WoHeartInfoModel mWoHeartInfo);

  void onGetHRData(Map map);

  void onResponseTempData(List<OTHistoryModel> list);

  void onGetRealTemp(num temp);

  void onResponseE80RealTimeMotionData(Map map);

  void onResponseBPData(List<BPHistoryModel> map);

  void deviceConfigurationInfo(DeviceConfigurationModel model);
}

abstract class BLEPerformerListener {
  void onConnectBLEIosDevice(BLEDeviceModel? device);

  void onResponseBLEDeviceInfo(DeviceInfoModel deviceInfoModel);

  void onResponseBLEMotionInfoE66(List<MotionInfoModel> mMotionInfoList);

  void onResponseBLESleepInfoE66(List<SleepInfoModel> mSleepInfoList);

  void onResponseBLEPoHeartInfo(HeartInfoModel mPoHeartInfo);

  void onResponseBLEE66HeartInfo(List map);

  void onResponseBLEWoHeartInfo(WoHeartInfoModel mWoHeartInfo);

  void onGetBLEHRData(Map map);

  void onResponseBLETempData(List<TempModel> list);

  void onGetBLERealTemp(num temp);

  void onResponseBLEE80RealTimeMotionData(Map map);

  void onResponseBLEBPData(List<BPModel> map);

  void BLEdeviceConfigurationInfo(DeviceConfigurationModel model);
}

abstract class HourlyPPGListener {
  void onResponsePPG(PpgInfoReadingModel ppgInfoReadingModel);

  void onResponseEcg(EcgInfoReadingModel ecgInfoReadingModel);
}

/// Added by: chandresh
/// Added at: 28-05-2020
/// this abstract class use to register ecg, ppg, lead off and conductive callback
abstract class MeasurementListener {
  void onGetEcg(EcgInfoReadingModel ecgInfoReadingModel);

  void onGetPpg(PpgInfoReadingModel ppgInfoReadingModel);

  void onGetPpgFromE66(PpgInfoReadingModel ppgInfoReadingModel);

  void onGetEcgFromE66(EcgInfoReadingModel ecgInfoReadingModel);

  void onGetLeadStatus(LeadOffStatusModel leadOffStatusModel);

//  void onGetLeadOff(bool isLeadOff);

//  void onGetPoorConductivity(bool isPoorConductivity);
}

/// Added by: chandresh
/// Added at: 28-05-2020
/// this abstract class use to find bracelet callback
abstract class VibrateListener {
  void onGetVibration(bool isVibrate);
}

/// Added by: chandresh
/// Added at: 28-05-2020
/// this abstract class use to find bracelet callback
abstract class AppNotificationListener {
  void onReceiveNotification(NotificationModel notification);
}

/// Added by: shahzad
/// Added on: 16-09-2020
/// this abstract class is use to get weight scale callbacks
abstract class WeightScaleListener {
  void onGetWeightScaleData(WeightMeasurementModel weightMeasurementModel);

  void onDeviceConnected(int status);
}

abstract class AssistantQueryListener {
  void onGetMeasurementQuery(String query);
}

abstract class HeartRateFromRunModeListener {
  onGetHeartRateFromRunMode(int HR);
}
