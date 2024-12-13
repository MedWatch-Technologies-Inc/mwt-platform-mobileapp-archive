import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHRequest/m_history_request.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/m_history_repository.dart';
import 'package:health_gauge/utils/Synchronisation/watch_sync_helper.dart';
import 'package:health_gauge/utils/db_table_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum HTab { day, week, month }

class MHistoryHelper {
  static final MHistoryHelper _singleton = MHistoryHelper._internal();

  factory MHistoryHelper() {
    return _singleton;
  }

  MHistoryHelper._internal();

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

  ValueNotifier<List<MHistoryModel>> dayData = ValueNotifier([]);
  ValueNotifier<List<MHDateDisplay>> displayWeekDate = ValueNotifier([]);
  ValueNotifier<List<MHDateDisplay>> displayMonthDate = ValueNotifier([]);

  Map<String, dynamic> refreshMap = {};

  Future<void> gayData() async {
    dayData.value.clear();
    var tempList = await getAllMHistory(startTimestamp: dayFromTime, endTimestamp: dayToTime);
    dayData.value.addAll(tempList);
    dayData.notifyListeners();
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
      int pageSize = 0,
      Function? refresh}) async {
    try {
      var requestData = getRequestData(
          fetchBulk: fetchBulk, endDate: endDate, pageSize: pageSize, startDate: startDate);
      final response = await MHistoryRepository().fetchAllMHistory(requestData);
      print('responseData :: ${response.getData!.result}');
      print('responseData :: ${response.hasData}');
      if (response.hasData) {
        if (response.getData!.result) {
          var list = response.getData!.data;
          await insertMHistory(list);
          print('MH APIResponse :: Length :: ${list.length}');
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
      if (refresh != null) {
        refresh();
      }
    }
  }

  Future<List<MHistoryModel>> getLastRecord() async {
    var db = await DatabaseHelper.instance.database;
    final tableHelper = DBTableHelper();
    var response = await db.query(
      tableHelper.m.table,
      where:
          '${tableHelper.m.columnUID} = ? ORDER BY ${tableHelper.m.columnTimestamp} DESC LIMIT 1',
      whereArgs: [getUserID],
    );
    if (response.isEmpty) {
      return [];
    }
    var tempList = response.map(MHistoryModel.fromJsonDB).toList();
    return tempList;
  }

  Future<List<MHistoryModel>> getAllMHistory(
      {required int startTimestamp, required int endTimestamp}) async {
    var db = await DatabaseHelper.instance.database;
    final tableHelper = DBTableHelper();
    var response = await db.query(
      tableHelper.m.table,
      where:
          '${tableHelper.m.columnUID} = ? AND ${tableHelper.m.columnTimestamp} BETWEEN ? AND ? ORDER BY ${tableHelper.m.columnTimestamp} DESC',
      whereArgs: [getUserID, startTimestamp, endTimestamp],
    );
    if (response.isEmpty) {
      return [];
    }
    var tempList = response.map(MHistoryModel.fromJsonDB).toList();
    return tempList;
  }

  Future<double> getDayLastMHistory(
      {required int startTimestamp, required int endTimestamp}) async {
    var db = await DatabaseHelper.instance.database;
    final tableHelper = DBTableHelper();
    var response = await db.query(
      tableHelper.m.table,
      where:
          '${tableHelper.m.columnUID} = ? AND ${tableHelper.m.columnTimestamp} BETWEEN ? AND ? ORDER BY ${tableHelper.m.columnTimestamp} DESC Limit 1',
      whereArgs: [getUserID, startTimestamp, endTimestamp],
    );
    if (response.isNotEmpty) {
      var tempList = response.map(MHistoryModel.fromJsonDB).toList();
      return double.tryParse(tempList.first.mHistoryBean.hrvDevice.toString()) ??
          WatchSyncHelper().dashData.hrv.toDouble();
    }
    return WatchSyncHelper().dashData.hrv.toDouble();
  }

  Future<void> insertMHistory(List<MHistoryModel> list) async {
    var db = await DatabaseHelper.instance.database;
    if (list.isEmpty) {
      return;
    }
    final tableHelper = DBTableHelper();
    var ifTableExist = await dbHelper.checkIfTable(tableHelper.m.table);
    for (var listItem in list) {
      var result = <Map<String, dynamic>>[];
      if (ifTableExist) {
        result = await db.query(
          tableHelper.m.table,
          where: '${tableHelper.m.columnID} = ?',
          whereArgs: [listItem.id],
        );
      } else {
        result = [];
      }
      if (result.isEmpty) {
        print('inserted');
        await db.insert(tableHelper.m.table, listItem.toJson(isFromDB: true));
      } else {
        print('updated');
        await db.update(
          tableHelper.m.table,
          listItem.toJson(isFromDB: true),
          where: '${tableHelper.m.columnID} = ?',
          whereArgs: [listItem.id],
        );
      }
    }
  }

  MHistoryRequest getRequestData(
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
    return MHistoryRequest(
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

  DateTime get firstDateWeek =>
      selectedWeek.value.subtract(Duration(days: selectedWeek.value.weekday - 1));

  DateTime get lastDateWeek =>
      selectedWeek.value.add(Duration(days: DateTime.daysPerWeek - selectedWeek.value.weekday));

  String get monthTitle => DateFormat(DateUtil.MMMMyyyy).format(selectedDay.value);

  DateTime get firstDateMonth => DateTime(selectedMonth.value.year, selectedMonth.value.month, 1);

  DateTime get lastDateMonth => DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 0);

  DateTime get now => DateTime.now();

  List<MHDateDisplay> get getWeekItems => List.generate(
      7,
      (index) => MHDateDisplay(
          title: DateFormat(DateUtil.ddMMMMyyyy)
              .format(firstDateWeek.add(Duration(days: index))))).toList();

  List<MHDateDisplay> get getMonthItems => List.generate(
      lastDateMonth.difference(firstDateMonth).inDays,
      (index) => MHDateDisplay(
          title: DateFormat(DateUtil.ddMMMMyyyy)
              .format(firstDateMonth.add(Duration(days: index))))).toList();
}

class MHDateDisplay {
  String title;

  MHDateDisplay({
    required this.title,
  });

  final ValueNotifier<bool> showDetails = ValueNotifier(false);

  bool get isShowDetails => showDetails.value;

  set isShowDetails(bool value) {
    showDetails.value = value;
  }
}
