import 'package:health_gauge/repository/heart_rate_monitor/heart_rate_monitor_repository.dart';
import 'package:health_gauge/repository/heart_rate_monitor/request/get_hr_data_request.dart';
import 'package:health_gauge/repository/heart_rate_monitor/request/save_hr_data_request.dart';
import 'package:health_gauge/utils/Synchronisation/Models/hr_monitoring_model.dart';
import 'package:health_gauge/utils/Synchronisation/sync_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/db_table_helper.dart';
import 'package:health_gauge/utils/gloabals.dart';

class HRSyncHelper {
  static final HRSyncHelper _singleton = HRSyncHelper._internal();

  factory HRSyncHelper() {
    return _singleton;
  }

  HRSyncHelper._internal();

  int get getUserID => int.parse(preferences?.getString(Constants.prefUserIdKeyInt) ?? '0');

  int get lastRecordTimestampHR =>
      SyncHelper().mtModel?.hrTimestamp ??
      DateTime.now().subtract(Duration(days: 2)).millisecondsSinceEpoch;

  Future<void> insertHRHistory(List<SyncHRModel> list, {bool unSync = false}) async {
    var db = await DatabaseHelper.instance.database;
    if (list.isEmpty) {
      return;
    }
    final tableHelper = DBTableHelper();
    var ifTableExist = await dbHelper.checkIfTable(tableHelper.hr.table);
    for (var listItem in list) {
      var result = <Map<String, dynamic>>[];
      if (ifTableExist) {
        result = await db.query(
          tableHelper.hr.table,
          where: '${tableHelper.hr.columnUID} = ? AND ${tableHelper.hr.columnDate} = ?',
          whereArgs: [listItem.userID, listItem.date],
        );
      } else {
        result = [];
      }
      if (result.isEmpty) {
        await db.insert(tableHelper.hr.table, listItem.toJsonDB());
      } else {
        await db.update(
          tableHelper.hr.table,
          listItem.toJsonDB(unSync: unSync),
          where: '${unSync ? tableHelper.hr.columnDBID : tableHelper.hr.columnID} = ?',
          whereArgs: [unSync ? listItem.dbID : listItem.id],
        );
      }
    }
  }

  Future<List<SyncHRModel>> getAllHRUnSync({int? startTimestamp}) async {
    var db = await DatabaseHelper.instance.database;
    final tableHelper = DBTableHelper();
    var response = await db.query(
      tableHelper.hr.table,
      where:
          '${tableHelper.hr.columnUID} = ? AND ${tableHelper.hr.columnID} = ? AND ${tableHelper.hr.columnDate} > ?',
      whereArgs: [getUserID, 0, startTimestamp ?? lastRecordTimestampHR],
    );
    if (response.isEmpty) {
      return [];
    }
    var tempList = response.map(SyncHRModel.fromJsonDB).toList();
    return tempList;
  }

  Future<bool> saveHRData(List<SyncHRModel> listData, {bool unSync = false}) async {
    var requestData = SaveHrDataRequest(
      getUserID,
      listData.map((e) => HrData(e.approxHR, e.date.toString(), e.zoneID)).toList(),
    );
    final response = await HeartRateMonitorRepository().storeHeartRateRecordDetails(requestData);
    if (response.getData != null && response.getData!.result) {
      var hrSaveResponse = response.getData!;
      if (hrSaveResponse.iD.isNotEmpty && hrSaveResponse.iD.length == listData.length) {
        for (var i = 0; i < listData.length; i++) {
          listData[i].id = hrSaveResponse.iD[i];
        }
        await insertHRHistory(listData, unSync: true);
        return true;
      }
    }
    return false;
  }

  Future<void> syncHRFromServer() async {
    final response = await HeartRateMonitorRepository().getHeartRateRecordDetailList(
      GetHrDataRequest(
        userId: getUserID,
        pageSize: 300,
        pageIndex: 1,
        fromDateStamp: DateTime.now().subtract(Duration(days: 2)).millisecondsSinceEpoch.toString(),
        toDateStamp: DateTime.now().millisecondsSinceEpoch.toString(),
        ids: [],
      ),
    );
    if (response.getData != null && response.getData!.result) {
      var responseList = response.getData!.hrData;
      if (responseList.isNotEmpty) {
        var jsonList = responseList.map((e) => e.toJson()).toList();
        var syncList = jsonList.map(SyncHRModel.fromJson).toList();
        await insertHRHistory(syncList);
      }
    }
  }
}
