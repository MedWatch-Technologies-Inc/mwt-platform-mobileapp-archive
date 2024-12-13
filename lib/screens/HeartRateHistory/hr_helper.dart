import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:health_gauge/screens/HeartRateHistory/HRRepository/HRRequest/hr_request.dart';
import 'package:health_gauge/screens/HeartRateHistory/HRRepository/hr_repository.dart';
import 'package:health_gauge/screens/HeartRateHistory/HelperWidgets/heart_graph_widget.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';

import 'package:health_gauge/utils/Synchronisation/Models/hr_monitoring_model.dart';
import 'package:health_gauge/utils/Synchronisation/vital_helpers/hr_sync_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/db_table_helper.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HRHelper {
  static final HRHelper _singleton = HRHelper._internal();

  factory HRHelper() {
    return _singleton;
  }

  HRHelper._internal();

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

  ValueNotifier<List<SyncHRModel>> dayData = ValueNotifier([]);
  ValueNotifier<List<HRDateDisplay>> displayWeekDate = ValueNotifier([]);
  ValueNotifier<List<HRDateDisplay>> displayMonthDate = ValueNotifier([]);

  List<List<CAnnotation>> zoneLines = [];

  int get hrTotal => dayData.value.fold(0, (sum, item) => sum + item.approxHR);

  int get avgRestingHR => hrTotal ~/ dayData.value.length;


  int get lowestRestingHR => dayData.value
      .map((e) => e.approxHR)
      .toList()
      .reduce((curr, next) => curr < next ? curr : next);



  Future<void> gayData() async {
    dayData.value.clear();
    var tempList = await getAllHRHistory(startTimestamp: dayFromTime, endTimestamp: dayToTime);
    dayData.value.addAll(tempList);
    dayData.notifyListeners();
  }



  Future<List<SyncHRModel>> getAllHRHistory(
      {required int startTimestamp, required int endTimestamp}) async {
    var db = await DatabaseHelper.instance.database;
    final tableHelper = DBTableHelper();
    var response = await db.query(
      tableHelper.hr.table,
      where:
          '${tableHelper.hr.columnUID} = ? AND (${tableHelper.hr.columnHR} > 0 AND ${tableHelper.hr.columnHR} < 250) AND (${tableHelper.hr.columnDate} >= ? AND ${tableHelper.hr.columnDate} <= ?) ORDER BY ${tableHelper.hr.columnDate} DESC',
      whereArgs: [getUserID, startTimestamp, endTimestamp],
    );
    if (response.isEmpty) {
      return [];
    }
    var tempList = response.map(SyncHRModel.fromJsonDB).toList().toSet().toList();
    return tempList;
  }

  Future<List<SyncHRModel>> getLastRecord() async {
    var db = await DatabaseHelper.instance.database;
    final tableHelper = DBTableHelper();
    var response = await db.query(
      tableHelper.hr.table,
      where: '${tableHelper.hr.columnUID} = ? ORDER BY ${tableHelper.hr.columnDate} DESC LIMIT 1',
      whereArgs: [getUserID],
    );
    if (response.isEmpty) {
      return [];
    }
    var tempList = response.map(SyncHRModel.fromJsonDB).toList();
    return tempList;
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
      final response = await HRRepository().fetchAllHRData(requestData);
      if (response.hasData) {
        if (response.getData!.result) {
          var list = response.getData!.data;
          await HRSyncHelper().insertHRHistory(list);
          if (fetchNext) {
            if (list.length < dayPSize) {
              dayPHasData = false;
              refreshMap[dayFromTime.toString()] = true;
            } else {
              dayPIndex += 1;
              await fetchDay();
              return;
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

  HRRequest getRequestData(
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
    return HRRequest(
      userID: getUserID,
      pageIndex: pageIndex,
      pageSize: pageSize,
      ids: [],
      fromDatestamp: startDate,
      toDatestamp: endDate,
    );
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

  String get appbarTitle => DateFormat('dd MMMM yyyy').format(currentDate);

  DateTime get firstDateWeek =>
      selectedWeek.value.subtract(Duration(days: selectedWeek.value.weekday - 1));

  DateTime get lastDateWeek =>
      selectedWeek.value.add(Duration(days: DateTime.daysPerWeek - selectedWeek.value.weekday));

  String get monthTitle => DateFormat(DateUtil.MMMMyyyy).format(selectedDay.value);

  DateTime get firstDateMonth => DateTime(selectedMonth.value.year, selectedMonth.value.month, 1);

  DateTime get lastDateMonth => DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 0);

  DateTime get now => DateTime.now();

  List<HRDateDisplay> get getWeekItems => List.generate(
      7,
      (index) => HRDateDisplay(
          title: DateFormat(DateUtil.ddMMMMyyyy)
              .format(firstDateWeek.add(Duration(days: index))))).toList();

  List<HRDateDisplay> get getMonthItems => List.generate(
      lastDateMonth.difference(firstDateMonth).inDays,
      (index) => HRDateDisplay(
          title: DateFormat(DateUtil.ddMMMMyyyy)
              .format(firstDateMonth.add(Duration(days: index))))).toList();
}

class HRDateDisplay {
  String title;

  HRDateDisplay({
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
