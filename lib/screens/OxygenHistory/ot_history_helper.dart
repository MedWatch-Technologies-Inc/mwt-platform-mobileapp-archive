import 'package:flutter/material.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTRequest/ot_h_request.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTResponse/ot_h_model.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/ot_repository.dart';
import 'package:health_gauge/utils/Synchronisation/sync_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/db_table_helper.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OTHistoryHelper {
  static final OTHistoryHelper _singleton = OTHistoryHelper._internal();

  factory OTHistoryHelper() {
    return _singleton;
  }

  OTHistoryHelper._internal();

  RefreshController dayRefreshController = RefreshController();
  RefreshController weekRefreshController = RefreshController();
  RefreshController monthRefreshController = RefreshController();

  late TabController tabController;

  ValueNotifier<DateTime> selectedDay = ValueNotifier(DateTime.now());
  ValueNotifier<DateTime> selectedWeek = ValueNotifier(DateTime.now());
  ValueNotifier<DateTime> selectedMonth = ValueNotifier(DateTime.now());

  DateTime get currentDate {
    switch (currentTab.value) {
      case HTab.day:
        return selectedDay.value;
      case HTab.week:
        return selectedWeek.value;
      case HTab.month:
        return selectedMonth.value;
    }
  }

  ValueNotifier<HTab> currentTab = ValueNotifier(HTab.day);

  int dayPSize = 100;
  int dayPIndex = 1;
  bool dayPHasData = true;

  Map<String, dynamic> refreshMap = {};

  ValueNotifier<List<OTHistoryModel>> dayData = ValueNotifier([]);
  ValueNotifier<List<OTDateDisplay>> displayWeekDate = ValueNotifier([]);
  ValueNotifier<List<OTDateDisplay>> displayMonthDate = ValueNotifier([]);

  double get oxygenTotal => dayData.value.fold(0, (sum, item) => sum + item.oxygen.toDouble());

  int get avgOxygen => (oxygenTotal / dayData.value.length).ceil();

  Future<void> gayData() async {
    dayData.value.clear();
    var tempList = await getAllOTHistory(startTimestamp: dayFromTime, endTimestamp: dayToTime);
    dayData.value.addAll(tempList);
    dayData.notifyListeners();
  }

  Future<List<OTHistoryModel>> getLastRecord() async {
    var db = await DatabaseHelper.instance.database;
    final tableHelper = DBTableHelper();
    var response = await db.query(
      tableHelper.ot.table,
      where:
      '${tableHelper.ot.columnUID} = ? ORDER BY ${tableHelper.ot.columnTimestamp} DESC LIMIT 1',
      whereArgs: [getUserID],
    );
    if (response.isEmpty) {
      return [];
    }
    var tempList = response.map(OTHistoryModel.fromJsonDB).toList();
    return tempList;
  }

  Future<List<OTHistoryModel>> getAllOTHistory(
      {required int startTimestamp, required int endTimestamp}) async {
    var db = await DatabaseHelper.instance.database;
    final tableHelper = DBTableHelper();
    var response = await db.query(
      tableHelper.ot.table,
      where:
          '${tableHelper.ot.columnUID} = ? AND ${tableHelper.ot.columnTimestamp} BETWEEN ? AND ? ORDER BY ${tableHelper.ot.columnTimestamp} DESC',
      whereArgs: [getUserID, startTimestamp, endTimestamp],
    );
    if (response.isEmpty) {
      return [];
    }
    var tempList = response.map(OTHistoryModel.fromJsonDB).toList();
    return tempList;
  }

  Future<List<OTHistoryModel>> getAllOTUnSync({int? startTimestamp}) async {
    var db = await DatabaseHelper.instance.database;
    final tableHelper = DBTableHelper();
    var response = await db.query(
      tableHelper.ot.table,
      where:
          '${tableHelper.ot.columnUID} = ? AND ${tableHelper.ot.columnID} = ? AND ${tableHelper.ot.columnTimestamp} > ?',
      whereArgs: [getUserID, 0, startTimestamp ?? lastRecordTimestampOT],
    );
    if (response.isEmpty) {
      return [];
    }
    var tempList = response.map(OTHistoryModel.fromJsonDB).toList();
    return tempList;
  }

  Future<bool> saveOTData(List<OTHistoryModel> listData, {bool unSync = false}) async {
    final response = await OTRepository().saveOTData(listData);
    if (response.getData != null && response.getData!.result) {
      var otSaveResponse = response.getData!;
      if (otSaveResponse.ids.isNotEmpty && otSaveResponse.ids.length == listData.length) {
        for (var i = 0; i < listData.length; i++) {
          listData[i].id = otSaveResponse.ids[i];
        }
        await insertOTHistory(listData, unSync: true);
        return true;
      }
    }
    return false;
  }

  void onTabChange(int index) async {
    switch (index){
      case 0:
        dayPIndex = 1;
        currentTab.value = HTab.day;
        selectedDay.notifyListeners();
        await gayData();
        break;
      case 1:
        dayPIndex = 1;
        currentTab.value = HTab.week;
        displayWeekDate.value.clear();
        displayWeekDate.value.addAll(getWeekItems);
        displayWeekDate.notifyListeners();
        selectedDay.notifyListeners();
        break;
      case 2:
        dayPIndex = 1;
        currentTab.value = HTab.month;
        displayMonthDate.value.clear();
        displayMonthDate.value.addAll(getMonthItems);
        displayMonthDate.notifyListeners();
        selectedDay.notifyListeners();
        break;
      default:
    }
  }

  Future<void> fetchDay(
      {bool fetchNext = true,
      bool fetchBulk = false,
      int startDate = 0,
      int endDate = 0,
      int pageSize = 0}) async {
    try {
      var requestData = getRequestData(
          fetchBulk: fetchBulk, endDate: endDate, pageSize: pageSize, startDate: startDate);
      final response = await OTRepository().fetchAllOTHistory(requestData);
      if (response.hasData) {
        if (response.getData!.result) {
          var list = response.getData!.data;
          await insertOTHistory(list);
          if (fetchNext) {
            if (list.length < dayPSize) {
              dayPHasData = false;
              refreshMap[dayFromTime.toString()] = true;
            } else {
              dayPIndex += 1;
              await fetchDay();
            }
          }
        } else {
          refreshMap[dayFromTime.toString()] = true;
        }
        gayData();
      } else {
        refreshMap[dayFromTime.toString()] = true;
      }
    } catch (e) {
      print(e);
    } finally {
      if (dayRefreshController.isRefresh) {
        dayRefreshController.refreshCompleted();
      }
      if (dayRefreshController.isLoading) {
        dayRefreshController.loadComplete();
      }
      if (weekRefreshController.isRefresh) {
        weekRefreshController.refreshCompleted();
      }
      if (weekRefreshController.isLoading) {
        weekRefreshController.loadComplete();
      }
      if (monthRefreshController.isRefresh) {
        monthRefreshController.refreshCompleted();
      }
      if (monthRefreshController.isLoading) {
        monthRefreshController.loadComplete();
      }
    }
  }

  Future<void> insertOTHistory(List<OTHistoryModel> list, {bool unSync = false}) async {
    var db = await DatabaseHelper.instance.database;
    if (list.isEmpty) {
      return;
    }
    final tableHelper = DBTableHelper();
    var ifTableExist = await dbHelper.checkIfTable(tableHelper.ot.table);
    for (var listItem in list) {
      var result = <Map<String, dynamic>>[];
      if (ifTableExist) {
        result = await db.query(
          tableHelper.ot.table,
          where: '${tableHelper.ot.columnUID} = ? AND ${tableHelper.ot.columnTimestamp} = ?',
          whereArgs: [listItem.userID, listItem.timestamp],
        );
      } else {
        result = [];
      }
      if (result.isEmpty) {
        await db.insert(tableHelper.ot.table, listItem.toJsonDB());
      } else {
        await db.update(
          tableHelper.ot.table,
          listItem.toJsonDB(unSync: unSync),
          where: '${unSync ? tableHelper.ot.columnDBID : tableHelper.ot.columnID} = ?',
          whereArgs: [unSync ? listItem.dbID : listItem.id],
        );
      }
    }
  }

  OTHistoryRequest getRequestData(
      {bool fetchBulk = false, int startDate = 0, int endDate = 0, int pageSize = 0}) {
    var pageIndex = dayPIndex;
    if (pageSize == 0) {
      pageSize = dayPSize;
    }
    if (startDate == 0) {
      startDate = fetchBulk ? dayFromTimeBulk : dayFromTime;
    }
    if (endDate == 0) {
      endDate = dayToTime;
    }
    return OTHistoryRequest(
      userID: getUserID,
      pageIndex: pageIndex,
      pageSize: pageSize,
      ids: [],
      fromDatestamp: startDate,
      toDatestamp: endDate,
    );
  }

  int get dayFromTime =>
      DateTime(currentDate.year, currentDate.month, currentDate.day)
          .millisecondsSinceEpoch;

  int get dayFromTimeBulk =>
      DateTime(currentDate.year, currentDate.month, currentDate.day - 15)
          .millisecondsSinceEpoch;

  int get dayToTime =>
      DateTime(currentDate.year, currentDate.month, currentDate.day + 1)
          .millisecondsSinceEpoch;

  String get getUserID => preferences?.getString(Constants.prefUserIdKeyInt) ?? '';

  int get lastRecordTimestampOT =>
      SyncHelper().mtModel?.otTimestamp ??
      DateTime.now().subtract(Duration(days: 2)).millisecondsSinceEpoch;

  String get title {
    var hTab = currentTab.value;
    switch (hTab) {
      case HTab.day:
        var difference =
            DateTime(selectedDay.value.year, selectedDay.value.month, selectedDay.value.day)
                .difference(DateTime(now.year, now.month, now.day))
                .inDays;
        if (difference == -1) {
          return 'Yesterday';
        }
        if (difference == 0) {
          return 'Today';
        }
        if (difference == 1) {
          return 'Tomorrow';
        }
        return dayTitle;
      case HTab.week:
        return '${DateFormat(DateUtil.ddMMyyyy).format(firstDateWeek)} To ${DateFormat(DateUtil.ddMMyyyy).format(lastDateWeek)}';
      case HTab.month:
        return monthTitle;
      default:
        return dayTitle;
    }
  }

  String get dayTitle => DateFormat(DateUtil.ddMMyyyyDashed).format(selectedDay.value);

  String get appbarTitle => DateFormat('dd MMMM yyyy').format(currentDate);

  DateTime get firstDateWeek =>
      selectedWeek.value.subtract(Duration(days: selectedWeek.value.weekday - 1));

  DateTime get lastDateWeek =>
      selectedWeek.value.add(Duration(days: DateTime.daysPerWeek - selectedWeek.value.weekday));

  String get monthTitle => DateFormat(DateUtil.MMMMyyyy).format(selectedDay.value);

  DateTime get firstDateMonth => DateTime(selectedMonth.value.year, selectedMonth.value.month, 1);

  DateTime get lastDateMonth => DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 0);

  DateTime get now => DateTime.now();

  List<OTDateDisplay> get getWeekItems => List.generate(
      7,
      (index) => OTDateDisplay(
          title: DateFormat(DateUtil.ddMMMMyyyy)
              .format(firstDateWeek.add(Duration(days: index))))).toList();

  List<OTDateDisplay> get getMonthItems => List.generate(
      lastDateMonth.difference(firstDateMonth).inDays,
      (index) => OTDateDisplay(
          title: DateFormat(DateUtil.ddMMMMyyyy)
              .format(firstDateMonth.add(Duration(days: index))))).toList();
}

class OTDateDisplay {
  String title;

  OTDateDisplay({
    required this.title,
  });

  bool get isPastDay =>
      DateFormat('dd MMMM yyyy').parse(title).millisecondsSinceEpoch >
          DateTime.now().millisecondsSinceEpoch;

  final ValueNotifier<bool> showDetails = ValueNotifier(false);

  bool get isShowDetails => showDetails.value;

  set isShowDetails(bool value) {
    showDetails.value = value;
  }
}
