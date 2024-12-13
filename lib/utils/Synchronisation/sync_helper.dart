import 'package:health_gauge/repository/heart_rate_monitor/heart_rate_monitor_repository.dart';
import 'package:health_gauge/repository/heart_rate_monitor/request/save_hr_data_request.dart';
import 'package:health_gauge/screens/BloodPressureHistory/bp_history_helper.dart';
import 'package:health_gauge/screens/GraphHistory/graph_history_helper.dart';
import 'package:health_gauge/screens/HeartRateHistory/hr_helper.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';
import 'package:health_gauge/screens/OxygenHistory/ot_history_helper.dart';
import 'package:health_gauge/screens/device_management/api_client/device_setting_repo.dart';
import 'package:health_gauge/screens/device_management/model/m_t_response.dart';
import 'package:health_gauge/utils/Synchronisation/Models/hr_monitoring_model.dart';
import 'package:health_gauge/utils/Synchronisation/watch_sync_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/db_table_helper.dart';
import 'package:health_gauge/utils/gloabals.dart';

class SyncHelper {
  static final SyncHelper _singleton = SyncHelper._internal();

  factory SyncHelper() {
    return _singleton;
  }

  SyncHelper._internal();

  final WatchSyncHelper _watchSyncHelper = WatchSyncHelper();

  MTModel? mtModel;

  int get getUserID => int.parse(preferences?.getString(Constants.prefUserIdKeyInt) ?? '0');

  void initWatchConfig() {
    Future.delayed(Duration(seconds: 1), () {
      connections.setHourlyHrMonitorOn(true, 5);
    });
    Future.delayed(Duration(seconds: 3), () {
      connections.setBPMonitorOn(true, 5);
    });
    Future.delayed(Duration(seconds: 5), () {
      SyncHelper().initialise();
    });
  }

  Future<void> initialise() async {
    await fetchMeasurementTimestamp();
    await _watchSyncHelper.fetchWatch();
  }

  Future<void> syncDataFromServer() async {
    await MHistoryHelper().fetchDay(fetchBulk: true);
    await OTHistoryHelper().fetchDay(fetchBulk: true);
    _watchSyncHelper.fetchLatestDashData();
    HRHelper().fetchDay(fetchBulk: true);
    BPHistoryHelper().fetchDay(fetchBulk: true);
  }

  Future<void> fetchMeasurementTimestamp() async {
    var mtResponseModel = await DeviceSettingRepo().fetchMeasurementTimestamp(getUserID);
    if (mtResponseModel.getData != null && mtResponseModel.hasData) {
      var mtModel = mtResponseModel.getData!.data;
      if (mtModel != null) {
        var result = checkIfMTUpdate(mtModel);
        if (result) {
          this.mtModel = mtModel;
        }
      }
    }
  }

  bool checkIfMTUpdate(MTModel mtModel) {
    return mtModel.toJson() != (this.mtModel?.toJson() ?? {});
  }
}
