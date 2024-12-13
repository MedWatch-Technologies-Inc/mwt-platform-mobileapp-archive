import 'package:flutter/material.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/screens/history/heart_rate/providers/heart_rate_history_provider.dart';
import 'package:health_gauge/screens/history/model/month_history_data_model.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_item_enum.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../repository/heart_rate_monitor/model/get_hr_data_response.dart';

class HeartRateMonthDataProvider extends ChangeNotifier {
  List<HrDataModel> _modelList = [];
  bool _isLoading = true;
  bool _isPageLoading = false;

  bool _isAllFetched = false;

  List<MonthHistoryDataModel<HrDataModel>> _monthWeekDataList = [];

  bool get isAllFetched => _isAllFetched;

  int _currentListIndex = 0;
  bool _showDetails = false;

  bool get showDetails => _showDetails;

  int get currentListIndex => _currentListIndex;

  set currentListIndex(int value) {
    _currentListIndex = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set showDetails(bool value) {
    _showDetails = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  set isAllFetched(bool value) {
    _isAllFetched = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  List<HrDataModel> get modelList => _modelList;

  set modelList(List<HrDataModel> value) {
    _modelList = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  List<MonthHistoryDataModel<HrDataModel>> get monthWeekDataList =>
      _monthWeekDataList;

  set monthWeekDataList(List<MonthHistoryDataModel<HrDataModel>> value) {
    _monthWeekDataList = value;
  }

  Future<List<HrDataModel>> getHistoryData(context) async {
    assert(context != null);
    var userId = preferences?.getString(Constants.prefUserIdKeyInt);
    var provider =
        Provider.of<HeartRateHistoryProvider>(context, listen: false);
    modelList;
    if (isLoading) {
      modelList.clear();
    }

    var startDate =
        DateTime(provider.selectedDate.year, provider.selectedDate.month, 1);
    var endDate = DateTime(
        provider.selectedDate.year, provider.selectedDate.month + 1, 1);
    var strStart = DateFormat(DateUtil.yyyyMMdd).format(startDate);
    var strEnd = DateFormat(DateUtil.yyyyMMdd).format(endDate);
    var ids = modelList.map((e) => (e.id ?? -1)).toList();

    // var data = await dbHelper.getHeartRateData(userId!, strStart, strEnd, ids);
    var data =
        await dbHelper.getHrMonitoringTableData(userId!, strStart, strEnd, ids);
    // data = distinctList(data);
    if (data.length == 0) {
      isAllFetched = true;
    } else {
      isAllFetched = false;
    }

    modelList.addAll(data);

    monthWeekDataList.clear();

    var weekFirstDayDt =
        DateTime(provider.selectedDate.year, provider.selectedDate.month, 1);
    var weekLastDayDt =
        weekFirstDayDt.add(Duration(days: 7 - weekFirstDayDt.weekday));

    while (weekFirstDayDt.month == provider.selectedDate.month) {
      var dataList = await getHrDataFromDb(
          list: [],
          id: userId,
          strDate: DateFormat(DateUtil.yyyyMMdd).format(weekFirstDayDt),
          endDate: DateFormat(DateUtil.yyyyMMdd)
              .format(weekLastDayDt.add(Duration(days: 1))));
      monthWeekDataList.add(MonthHistoryDataModel<HrDataModel>(
          fieldName: DefaultGraphItem.hr,
          startDate: weekFirstDayDt,
          endDate: weekLastDayDt,
          data: dataList));
      weekFirstDayDt = weekLastDayDt.add(Duration(days: 1));
      if (weekFirstDayDt.add(Duration(days: 7)).isBefore(endDate)) {
        weekLastDayDt = weekFirstDayDt.add(Duration(days: 6));
      } else {
        weekLastDayDt = DateTime(
            provider.selectedDate.year, provider.selectedDate.month + 1, 0);
      }
    }

    isLoading = false;
    isPageLoading = false;

    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
    return Future.value(modelList);
  }

  Future<List<HrDataModel>> getHrDataFromDb(
      {required List<HrDataModel> list,
      String? id,
      String? strDate,
      String? endDate}) async {
    var ids = list.map((e) => (e.id ?? -1)).toList();
    List<HrDataModel> data =
        await dbHelper.getHrMonitoringTableData(id!, strDate!, endDate!, ids);
    list.addAll(data);
    if (data.length == 20) {
      await getHrDataFromDb(
          list: list, id: id, strDate: strDate, endDate: endDate);
    }
    return Future.value(list);
  }

  void reset() {
    _modelList = [];
    _monthWeekDataList = [];
    _isLoading = true;
    _isPageLoading = false;
  }
}
