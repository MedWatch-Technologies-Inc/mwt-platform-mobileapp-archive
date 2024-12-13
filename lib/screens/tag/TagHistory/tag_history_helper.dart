import 'package:flutter/material.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';
import 'package:health_gauge/screens/tag/TagHistory/TagRepository/TagRequest/tag_request.dart';
import 'package:health_gauge/screens/tag/TagHistory/TagRepository/TagResponse/tag_record_model.dart';
import 'package:health_gauge/screens/tag/TagHistory/TagRepository/t_repository.dart';
import 'package:health_gauge/utils/db_table_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class THistoryHelper{
  static final THistoryHelper _singleton = THistoryHelper._internal();

  factory THistoryHelper() {
    return _singleton;
  }

  THistoryHelper._internal();

  RefreshController dayRefreshController = RefreshController();
  RefreshController weekRefreshController = RefreshController();
  RefreshController monthRefreshController = RefreshController();

  late TabController tabController;

  ValueNotifier<DateTime> selectedDay = ValueNotifier(DateTime.now());
  ValueNotifier<HTab> currentTab = ValueNotifier(HTab.day);

  int dayPSize = 100;
  int dayPIndex = 1;
  bool dayPHasData = true;

  Map<String, dynamic> refreshMap = {};

  ValueNotifier<List<TagRecordModel>> dayData = ValueNotifier([]);
  ValueNotifier<List<TDateDisplay>> displayWeekDate = ValueNotifier([]);
  ValueNotifier<List<TDateDisplay>> displayMonthDate = ValueNotifier([]);

  Future<void> gayData() async {
    var result = await dbHelper.checkIfTable(DBTableHelper().t.table);
    if(!result){
      return;
    }
    dayData.value.clear();
    var tempList = await getAllMHistory(startTimestamp: dayFromTime, endTimestamp: dayToTime);
    dayData.value.addAll(tempList);
    dayData.notifyListeners();
  }

  Future<void> fetchDay() async {
    try {
      var requestData = getRequestData(0);
      final response =
      await TRepository().fetchAllMHistory(requestData);
      print('responseData :: ${response.getData!.result}');
      if (response.hasData) {
        if (response.getData!.result) {
          var list = response.getData!.data;
          await insertTHistory(list);
          print('MH APIResponse :: Length :: ${list.length}');
          if (list.length < dayPSize) {
            dayPHasData = false;
            refreshMap[dayFromTime.toString()] = true;
          } else {
            dayPIndex += 1;
            await fetchDay();
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

  Future<void> insertTHistory(List<TagRecordModel> list) async {
    var db = await DatabaseHelper.instance.database;
    if (list.isEmpty) {
      return;
    }
    final tableHelper = DBTableHelper();
    var ifTableExist = await dbHelper.checkIfTable(tableHelper.t.table);
    for (var listItem in list) {
      var result = <Map<String, dynamic>>[];
      if (ifTableExist) {
        result = await db.query(
          tableHelper.t.table,
          where: '${tableHelper.t.columnID} = ?',
          whereArgs: [listItem.id],
        );
      } else {
        result = [];
      }
      if (result.isEmpty) {
        print('inserted');
        try {
          var value = await db.insert(tableHelper.t.table, listItem.toJson(isFromDB: true));
          print('insertTHistory $value');
        } catch (e) {
          print('insertTHistory :: $e');
        }
      } else {
        print('updated');
        await db.update(
          tableHelper.t.table,
          listItem.toJson(isFromDB: true),
          where: '${tableHelper.t.columnID} = ?',
          whereArgs: [listItem.id],
        );
      }
    }
  }

  Future<List<TagRecordModel>> getAllMHistory(
      {required int startTimestamp, required int endTimestamp}) async {
    var db = await DatabaseHelper.instance.database;
    final tableHelper = DBTableHelper();
    var response = await db.query(
      tableHelper.t.table,
      where:
      '${tableHelper.t.columnFKUserID} = ? AND ${tableHelper.t.columnCreatedDateTimeTimestamp} BETWEEN ? AND ? ORDER BY ${tableHelper.t.columnCreatedDateTimeTimestamp} DESC',
      whereArgs: [getUserID, startTimestamp, endTimestamp],
    );
    if (response.isEmpty) {
      return [];
    }
    var tempList = response.map(TagRecordModel.fromJsonDB).toList();
    return tempList;
  }

  TRequest getRequestData(int index) {
    var pageSize = 0;
    var pageIndex = 0;
    if (index == 0) {
      pageSize = dayPSize;
      pageIndex = dayPIndex;
    }
    return TRequest(
      userID: getUserID,
      pageIndex: pageIndex,
      pageSize: pageSize,
      ids: [],
      fromDatestamp: dayFromTime,
      toDatestamp: dayToTime,
    );
  }

  void onTabChange(int index) {
    switch (index) {
      case 0:
        dayPIndex = 1;
        currentTab.value = HTab.day;
        selectedDay.notifyListeners();
        dayRefreshController.requestRefresh();
        break;
      case 1:
        dayPIndex = 1;
        currentTab.value = HTab.week;
        selectedDay.value =
            selectedDay.value.subtract(Duration(days: selectedDay.value.weekday - 1));
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
      DateTime(selectedDay.value.year, selectedDay.value.month, selectedDay.value.day)
          .millisecondsSinceEpoch;

  int get dayToTime =>
      DateTime(selectedDay.value.year, selectedDay.value.month, selectedDay.value.day + 1)
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
      selectedDay.value.subtract(Duration(days: selectedDay.value.weekday - 1));

  DateTime get lastDateWeek =>
      selectedDay.value.add(Duration(days: DateTime.daysPerWeek - selectedDay.value.weekday));

  String get monthTitle => DateFormat(DateUtil.MMMMyyyy).format(selectedDay.value);

  DateTime get firstDateMonth =>
      DateTime(selectedDay.value.year, selectedDay.value.month, 1);

  DateTime get lastDateMonth =>
      DateTime(selectedDay.value.year, selectedDay.value.month + 1, 0);

  DateTime get now => DateTime.now();

  List<TDateDisplay> get getWeekItems => List.generate(
      7,
          (index) => TDateDisplay(
          title: DateFormat(DateUtil.ddMMMMyyyy)
              .format(firstDateWeek.add(Duration(days: index))))).toList();

  List<TDateDisplay> get getMonthItems => List.generate(
      lastDateMonth.difference(firstDateMonth).inDays,
          (index) => TDateDisplay(
          title: DateFormat(DateUtil.ddMMMMyyyy)
              .format(firstDateMonth.add(Duration(days: index))))).toList();
}

class TDateDisplay {
  String title;

  TDateDisplay({
    required this.title,
  });

  final ValueNotifier<bool> showDetails = ValueNotifier(false);

  bool get isShowDetails => showDetails.value;

  set isShowDetails(bool value) {
    showDetails.value = value;
  }
}