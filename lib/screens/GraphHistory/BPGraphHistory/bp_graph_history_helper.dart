import 'package:flutter/material.dart';
import 'package:health_gauge/screens/HeartRateHistory/HRRepository/HRRequest/hr_request.dart';
import 'package:health_gauge/screens/HeartRateHistory/HRRepository/hr_repository.dart';
import 'package:health_gauge/screens/HeartRateHistory/HelperWidgets/heart_graph_widget.dart';
import 'package:health_gauge/screens/HeartRateHistory/hr_helper.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHRequest/m_history_request.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/m_history_repository.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';

import 'package:health_gauge/utils/Synchronisation/Models/hr_monitoring_model.dart';
import 'package:health_gauge/utils/Synchronisation/vital_helpers/hr_sync_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BPGraphHistoryHelper {
  static final BPGraphHistoryHelper _singleton = BPGraphHistoryHelper._internal();

  factory BPGraphHistoryHelper() {
    return _singleton;
  }

  BPGraphHistoryHelper._internal();

  RefreshController dayRefreshController = RefreshController();
  RefreshController weekRefreshController = RefreshController();
  RefreshController monthRefreshController = RefreshController();

  late TabController tabController;

  ValueNotifier<DateTime> selectedDay = ValueNotifier(DateTime.now());
  ValueNotifier<HTab> currentTab = ValueNotifier(HTab.day);

  int dayPSizeBP = 100;
  int dayPIndexBP = 1;
  bool dayPHasDataBP = true;

  Map<String, dynamic> refreshMapBP = {};

  ValueNotifier<List<MHistoryModel>> bpData = ValueNotifier([]);

  Future<void> deyDataBP() async {
    bpData.value.clear();
    var tempListBP = <MHistoryModel>[];
    if (currentTab.value == HTab.week) {
      tempListBP = await MHistoryHelper().getAllMHistory(
        startTimestamp: firstDateWeek.millisecondsSinceEpoch,
        endTimestamp: lastDateWeek.add(Duration(days: 1)).millisecondsSinceEpoch,
      );
    } else if (currentTab.value == HTab.month) {
      tempListBP = await MHistoryHelper().getAllMHistory(
        startTimestamp: firstDateMonth.millisecondsSinceEpoch,
        endTimestamp: lastDateMonth.add(Duration(days: 1)).millisecondsSinceEpoch,
      );
    } else {
      tempListBP = await MHistoryHelper().getAllMHistory(
        startTimestamp: dayFromTime,
        endTimestamp: dayToTime,
      );
    }
    bpData.value.addAll(tempListBP);
    bpData.notifyListeners();
  }

  Future<void> fetchDayBP(
      {bool fetchNext = true,
      bool fetchBulk = false,
      int startDate = 0,
      int endDate = 0,
      int pageSize = 0}) async {
    try {
      var requestDataBP = getRequestDataBP();
      final responseBP = await MHistoryRepository().fetchAllMHistory(requestDataBP);
      if (responseBP.hasData) {
            if (responseBP.getData!.result) {
              var list = responseBP.getData!.data;
              await MHistoryHelper().insertMHistory(list);
              deyDataBP();
              print('MH APIResponse :: Length :: ${list.length}');
              if (fetchNext) {
                if (list.length < dayPSizeBP) {
                  dayPHasDataBP = false;
                  refreshMapBP['bp_${currentTab.value.name}_${dayFromTime.toString()}'] = true;
                } else {
                  dayPIndexBP += 1;
                  await fetchDayBP();
                }
              }
            } else {
              refreshMapBP['bp_${currentTab.value.name}_${dayFromTime.toString()}'] = true;
            }
          } else {
            refreshMapBP['bp_${currentTab.value.name}_${dayFromTime.toString()}'] = true;
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
    }
  }

  MHistoryRequest getRequestDataBP(
      {bool fetchBulk = false, int startDate = 0, int endDate = 0, int pageSize = 0}) {
    var pageIndex = dayPIndexBP;
    if (pageSize == 0) {
      pageSize = dayPSizeBP;
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

  void onTabChange(int index) {
    switch (index) {
      case 0:
        dayPIndexBP = 1;
        currentTab.value = HTab.day;
        selectedDay.notifyListeners();
        deyDataBP();
        Future.delayed(Duration(milliseconds: 100),(){
          dayRefreshController.requestRefresh();
        });
        break;
      case 1:
        dayPIndexBP = 1;
        currentTab.value = HTab.week;
        selectedDay.value =
            selectedDay.value.subtract(Duration(days: selectedDay.value.weekday - 1));
        deyDataBP();
        selectedDay.notifyListeners();
        break;
      case 2:
        dayPIndexBP = 1;
        currentTab.value = HTab.month;
        deyDataBP();
        selectedDay.notifyListeners();
        break;
      default:
    }
  }

  String get getUserID => preferences?.getString(Constants.prefUserIdKeyInt) ?? '';

  int get dayFromTime =>
      DateTime(selectedDay.value.year, selectedDay.value.month, selectedDay.value.day)
          .millisecondsSinceEpoch;

  int get dayFromTimeBulk =>
      DateTime(selectedDay.value.year, selectedDay.value.month, selectedDay.value.day - 5)
          .millisecondsSinceEpoch;

  int get dayToTime =>
      DateTime(selectedDay.value.year, selectedDay.value.month, selectedDay.value.day + 1)
          .millisecondsSinceEpoch;

  String get dayTitle => DateFormat(DateUtil.ddMMyyyyDashed).format(selectedDay.value);

  String get appbarTitle => DateFormat('dd MMMM yyyy').format(selectedDay.value);

  DateTime get firstDateWeek =>
      selectedDay.value.subtract(Duration(days: selectedDay.value.weekday - 1));

  DateTime get lastDateWeek =>
      selectedDay.value.add(Duration(days: DateTime.daysPerWeek - selectedDay.value.weekday));

  String get monthTitle => DateFormat(DateUtil.MMMMyyyy).format(selectedDay.value);

  DateTime get firstDateMonth => DateTime(selectedDay.value.year, selectedDay.value.month, 1);

  DateTime get lastDateMonth => DateTime(selectedDay.value.year, selectedDay.value.month + 1, 0);

  DateTime get now => DateTime.now();
}
