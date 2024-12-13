import 'package:flutter/material.dart';
import 'package:health_gauge/screens/HeartRateHistory/HRRepository/HRRequest/hr_request.dart';
import 'package:health_gauge/screens/HeartRateHistory/HRRepository/hr_repository.dart';
import 'package:health_gauge/screens/HeartRateHistory/HelperWidgets/heart_graph_widget.dart';
import 'package:health_gauge/screens/HeartRateHistory/hr_helper.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHRequest/m_history_request.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/m_history_repository.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTRequest/ot_h_request.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTResponse/ot_h_model.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/ot_repository.dart';
import 'package:health_gauge/screens/OxygenHistory/ot_history_helper.dart';

import 'package:health_gauge/utils/Synchronisation/Models/hr_monitoring_model.dart';
import 'package:health_gauge/utils/Synchronisation/vital_helpers/hr_sync_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GraphHistoryHelper {
  static final GraphHistoryHelper _singleton = GraphHistoryHelper._internal();

  factory GraphHistoryHelper() {
    return _singleton;
  }

  GraphHistoryHelper._internal();

  RefreshController dayRefreshController = RefreshController();
  RefreshController weekRefreshController = RefreshController();
  RefreshController monthRefreshController = RefreshController();

  late TabController tabController;

  ValueNotifier<DateTime> selectedDay = ValueNotifier(DateTime.now());
  ValueNotifier<HTab> currentTab = ValueNotifier(HTab.day);

  List<List<CAnnotation>> zoneLines = [];

  int dayPSizeBP = 100;
  int dayPSizeHR = 100;
  int dayPSizeOT = 100;
  int dayPIndexBP = 1;
  int dayPIndexHR = 1;
  int dayPIndexOT = 1;
  bool dayPHasDataBP = true;
  bool dayPHasDataHR = true;
  bool dayPHasDataOT = true;

  Map<String, dynamic> refreshMapBP = {};
  Map<String, dynamic> refreshMapHR = {};
  Map<String, dynamic> refreshMapOT = {};

  ValueNotifier<List<MHistoryModel>> bpData = ValueNotifier([]);
  ValueNotifier<List<CandleGraphBP>> candleBPGraph = ValueNotifier([]);
  ValueNotifier<List<SyncHRModel>> hrData = ValueNotifier([]);
  ValueNotifier<List<OTHistoryModel>> otData = ValueNotifier([]);

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

  Future<void> deyDataHR() async {
    hrData.value.clear();
    var tempListHR =
        await HRHelper().getAllHRHistory(startTimestamp: dayFromTime, endTimestamp: dayToTime);
    hrData.value.addAll(tempListHR);
    hrData.notifyListeners();
  }

  Future<void> dayDataOT() async {
    otData.value.clear();
    var tempListOT = await OTHistoryHelper()
        .getAllOTHistory(startTimestamp: dayFromTime, endTimestamp: dayToTime);
    otData.value.addAll(tempListOT);
    otData.notifyListeners();
  }

  Future<void> dayData() async {
    if (currentTab.value == HTab.day) {
      deyDataHR();
      dayDataOT();
    } else {
      hrData.value.clear();
      otData.value.clear();
      hrData.notifyListeners();
      otData.notifyListeners();
    }
    deyDataBP();
  }

  Future<void> fetchDayBP(
      {bool fetchNext = true,
      bool fetchBulk = false,
      int startDate = 0,
      int endDate = 0,
      int pageSize = 0}) async {
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

  HRRequest getRequestDataHR(
      {bool fetchBulk = false, int startDate = 0, int endDate = 0, int pageSize = 0}) {
    var pageIndex = dayPIndexHR;
    if (pageSize == 0) {
      pageSize = dayPSizeHR;
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

  OTHistoryRequest getRequestDataOT(
      {bool fetchBulk = false, int startDate = 0, int endDate = 0, int pageSize = 0}) {
    var pageIndex = dayPIndexOT;
    if (pageSize == 0) {
      pageSize = dayPSizeOT;
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

  Future<void> fetchDayHR(
      {bool fetchNext = true,
      bool fetchBulk = false,
      int startDate = 0,
      int endDate = 0,
      int pageSize = 0}) async {
    var requestDataHR = getRequestDataHR(
        fetchBulk: fetchBulk, endDate: endDate, startDate: startDate, pageSize: pageSize);
    final responseHR = await HRRepository().fetchAllHRData(requestDataHR);
    if (responseHR.hasData) {
      if (responseHR.getData!.result) {
        var list = responseHR.getData!.data;
        await HRSyncHelper().insertHRHistory(list);
        print('MH APIResponse :: Length :: ${list.length}');
        if (fetchNext) {
          if (list.length < dayPSizeHR) {
            dayPHasDataHR = false;
            refreshMapHR['hr_${currentTab.value.name}_${dayFromTime.toString()}'] = true;
          } else {
            dayPIndexHR += 1;
            await fetchDayHR();
          }
        }
      } else {
        refreshMapHR['hr_${currentTab.value.name}_${dayFromTime.toString()}'] = true;
      }
    } else {
      refreshMapHR['hr_${currentTab.value.name}_${dayFromTime.toString()}'] = true;
    }
  }

  Future<void> fetchDayOT(
      {bool fetchNext = true,
        bool fetchBulk = false,
        int startDate = 0,
        int endDate = 0,
        int pageSize = 0}) async {
    var requestDataOT = getRequestDataOT(
        fetchBulk: fetchBulk, endDate: endDate, startDate: startDate, pageSize: pageSize);
    final responseOT = await OTRepository().fetchAllOTHistory(requestDataOT);
    if (responseOT.hasData) {
      if (responseOT.getData!.result) {
        var list = responseOT.getData!.data;
        await OTHistoryHelper().insertOTHistory(list);
        print('OT APIResponse :: Length :: ${list.length}');
        if (fetchNext) {
          if (list.length < dayPSizeOT) {
            dayPHasDataOT = false;
            refreshMapOT['ot_${currentTab.value.name}_${dayFromTime.toString()}'] = true;
          } else {
            dayPIndexOT += 1;
            await fetchDayOT();
          }
        }
      } else {
        refreshMapOT['ot_${currentTab.value.name}_${dayFromTime.toString()}'] = true;
      }
    } else {
      refreshMapOT['ot_${currentTab.value.name}_${dayFromTime.toString()}'] = true;
    }
  }

  Future<void> fetchDay({
    bool fetchNext = true,
    bool fetchBulk = false,
    int startDate = 0,
    int endDate = 0,
    int pageSize = 0,
  }) async {
    try {
      await fetchDayBP(
        fetchNext: fetchNext,
        pageSize: pageSize,
        startDate: startDate,
        endDate: endDate,
        fetchBulk: fetchBulk,
      );
      if (currentTab.value == HTab.day) {
        await fetchDayHR(
          fetchNext: fetchNext,
          pageSize: pageSize,
          startDate: startDate,
          endDate: endDate,
          fetchBulk: fetchBulk,
        );
        deyDataHR();
        await fetchDayOT(
          fetchNext: fetchNext,
          pageSize: pageSize,
          startDate: startDate,
          endDate: endDate,
          fetchBulk: fetchBulk,
        );
        dayDataOT();
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

  void onTabChange(int index) {
    switch (index) {
      case 0:
        dayPIndexBP = 1;
        dayPIndexHR = 1;
        currentTab.value = HTab.day;
        selectedDay.notifyListeners();
        dayData();
        Future.delayed(Duration(milliseconds: 100), () {
          dayRefreshController.requestRefresh();
        });
        break;
      case 1:
        dayPIndexBP = 1;
        dayPIndexHR = 1;
        currentTab.value = HTab.week;
        selectedDay.value =
            selectedDay.value.subtract(Duration(days: selectedDay.value.weekday - 1));
        dayData();
        selectedDay.notifyListeners();
        break;
      case 2:
        dayPIndexBP = 1;
        dayPIndexHR = 1;
        currentTab.value = HTab.month;
        dayData();
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

  int get hrTotal => hrData.value.fold(0, (sum, item) => sum + item.approxHR);

  int get avgRestingHR => hrTotal ~/ hrData.value.length;

  double get oxygenTotal => otData.value.fold(0, (sum, item) => sum + item.oxygen.toDouble());

  int get avgOxygen => oxygenTotal ~/ otData.value.length;

  int get lowestRestingHR => hrData.value
      .map((e) => e.approxHR)
      .toList()
      .reduce((curr, next) => curr < next ? curr : next);
}

class CandleGraphBP {
  int sbpMax;
  int dbpMax;
  int sbpMin;
  int dbpMin;

  CandleGraphBP({
    required this.dbpMax,
    required this.dbpMin,
    required this.sbpMax,
    required this.sbpMin,
  });
}
