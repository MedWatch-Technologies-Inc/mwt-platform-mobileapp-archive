import 'package:health_gauge/models/device_configuration_model.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/infoModels/device_info_model.dart';
import 'package:health_gauge/models/infoModels/heart_info_model.dart';
import 'package:health_gauge/models/infoModels/motion_info_model.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/models/infoModels/wo_heart_info_model.dart';
import 'package:health_gauge/screens/BloodPressureHistory/BPRepository/BPModel/bp_h_model.dart';
import 'package:health_gauge/screens/BloodPressureHistory/bp_history_helper.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTResponse/ot_h_model.dart';
import 'package:health_gauge/screens/OxygenHistory/ot_history_helper.dart';
import 'package:health_gauge/screens/WeightHistory/w_history_helper.dart';

import 'package:health_gauge/screens/dashboard/dash_common_notifier.dart';
import 'package:health_gauge/utils/Synchronisation/Models/hr_monitoring_model.dart';
import 'package:health_gauge/utils/Synchronisation/vital_helpers/hr_sync_helper.dart';
import 'package:health_gauge/utils/connections.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';

class WatchSyncHelper implements PerformerListener {
  static final WatchSyncHelper _singleton = WatchSyncHelper._internal();

  factory WatchSyncHelper() {
    return _singleton;
  }

  DashData dashData = DashData();

  WatchSyncHelper._internal();

  int get userID => int.parse(preferences?.getString(Constants.prefUserIdKeyInt) ?? '0');

  Future<bool> checkConnection() async {
    return await connections.isConnected(Constants.e66);
  }

  Future<void> fetchWatch() async {
    connections.performerListener = this;
    var isConnected = await connections.isConnected(Constants.e66);
    if (isConnected) {
      connections.getAllWatchHistory();
    }
  }

  Future<void> fetchLatestDashData() async {
    fetchLatestWeightData();
    fetchLatestOxygenData();
    var lastListHRV = await MHistoryHelper().getLastRecord();
    if (lastListHRV.isNotEmpty) {
      var temp = lastListHRV.first;
      dashData.hrv = num.parse(temp.mHistoryBean.hrvDevice);
      dashData.sys = temp.getAISys > temp.getAIDias ? temp.getAISys : temp.getAIDias;
      dashData.dia = temp.getAISys < temp.getAIDias ? temp.getAISys : temp.getAIDias;
      dashData.hr = num.parse(temp.mHistoryBean.hrDevice);
    }
  }

  Future<void> fetchLatestWeightData() async {
    try {
      var lastListWeight = await WHistoryHelper().getLastRecord();
      num weight = 50.0;
      if(lastListWeight.isNotEmpty){
        var weightModel = lastListWeight.first;
        weight = num.tryParse(weightModel.weightSum.toString()) ?? 0.0;
      }else{
        weight = num.tryParse(globalUser!.weight.toString()) ?? 0.0;
      }
      var weightUnit = num.tryParse(globalUser!.weightUnit.toString()) ?? 0.0;
      if (UnitExtension.getUnitType(weightUnit.toInt()) == UnitTypeEnum.imperial) {
        dashData.weight = weight * 2.20462;
      } else {
        dashData.weight = weight.toDouble();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchLatestOxygenData() async {
    try {
      var lastListOxygen = await OTHistoryHelper().getLastRecord();
      if (lastListOxygen.isNotEmpty) {
        var temp = lastListOxygen.first;
        dashData.oxygen = num.parse(temp.oxygen.toDouble().toStringAsFixed(1));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void onResponseTempData(List<OTHistoryModel> list) async {
    print('onResponseTempData :: ${DateTime.now()} :: $list');
    if (list.isNotEmpty) {
      var reqList = <OTHistoryModel>[];
      for (var item in list) {
        item.userID = int.parse(preferences?.getString(Constants.prefUserIdKeyInt) ?? '0');
        reqList.add(item);
        print('OTHistory :: ${item.timestamp} :: ${item.toJsonDB()}');
      }
      if(reqList.isNotEmpty){
        dashData.oxygen =  num.parse(reqList.last.oxygen.toDouble().toStringAsFixed(1));
      }
      await OTHistoryHelper().insertOTHistory(reqList, unSync: true);
    }
    var unSyncData = await OTHistoryHelper().getAllOTUnSync();
    if (unSyncData.isNotEmpty) {
      var result = await OTHistoryHelper().saveOTData(unSyncData, unSync: true);
      if (result) {
        await connections.deleteTempAndOxygen();
      }
    }
  }

  @override
  void onResponseE66HeartInfo(List<SyncHRModel> list) async {
    print('onResponseE66HeartInfo :: ${DateTime.now().toString()} :: $list');
    if (list.isNotEmpty) {
      var reqList = <SyncHRModel>[];
      for (var item in list) {
        item.userID = int.parse(preferences?.getString(Constants.prefUserIdKeyInt) ?? '0');
        reqList.add(item);
        print('SyncHRModel :: ${item.toJsonDB()}');
      }
      await HRSyncHelper().insertHRHistory(reqList, unSync: true);
    }
    var unSyncData = await HRSyncHelper().getAllHRUnSync();
    if (unSyncData.isNotEmpty) {
      for (var item in unSyncData) {
        print('SyncHRModel :: UnSync :: ${item.toJsonDB()}');
      }
      var result = await HRSyncHelper().saveHRData(unSyncData, unSync: true);
      if (result) {
        await connections.deleteHeartRate();
      }
    }
  }

  @override
  void onResponseBPData(List<BPHistoryModel> list) async {
    print('onResponseBPData :: ${DateTime.now().toString()} :: $list');
    if (list.isNotEmpty) {
      var reqList = <BPHistoryModel>[];
      for (var item in list) {
        item.userID = int.parse(preferences?.getString(Constants.prefUserIdKeyInt) ?? '0');
        reqList.add(item);
      }
      await BPHistoryHelper().insertBPHistory(reqList, unSync: true);
    }
    var unSyncData = await BPHistoryHelper().getAllUnSync();
    if (unSyncData.isNotEmpty) {
      var result = await BPHistoryHelper().saveBPData(unSyncData, unSync: true);
      if (result) {
        await connections.deleteBloodPressure();
      }
    }
  }

  @override
  void deviceConfigurationInfo(DeviceConfigurationModel model) {
    // TODO: implement deviceConfigurationInfo
  }

  @override
  void onConnectIosDevice(DeviceModel? device) {
    // TODO: implement onConnectIosDevice
  }

  @override
  void onGetHRData(Map map) {
    // TODO: implement onGetHRData
  }

  @override
  void onGetRealTemp(num temp) {
    // TODO: implement onGetRealTemp
  }

  @override
  void onResponseDeviceInfo(DeviceInfoModel deviceInfoModel) {
    // TODO: implement onResponseDeviceInfo
  }

  @override
  void onResponseE80RealTimeMotionData(Map map) {
    // TODO: implement onResponseE80RealTimeMotionData
  }

  @override
  void onResponseMotionInfoE66(List<MotionInfoModel> mMotionInfoList) {
    // TODO: implement onResponseMotionInfoE66
    print(
        'onResponseMotionInfoE66 :: ${DateTime.now().toString()} :: ${mMotionInfoList.toString()}');
  }

  @override
  void onResponsePoHeartInfo(HeartInfoModel mPoHeartInfo) {
    // TODO: implement onResponsePoHeartInfo
  }

  @override
  void onResponseSleepInfoE66(List<SleepInfoModel> mSleepInfoList) {
    // TODO: implement onResponseSleepInfoE66
  }

  @override
  void onResponseWoHeartInfo(WoHeartInfoModel mWoHeartInfo) {
    // TODO: implement onResponseWoHeartInfo
  }
}
