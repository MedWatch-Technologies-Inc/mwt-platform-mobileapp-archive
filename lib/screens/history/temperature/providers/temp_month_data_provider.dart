import 'package:flutter/material.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/screens/history/model/month_history_data_model.dart';
import 'package:health_gauge/screens/history/temperature/providers/temp_history_provider.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_item_enum.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TempMonthDataProvider extends ChangeNotifier {
  List<TempModel> _modelList = [];
  bool _isLoading = true;
  bool _isPageLoading = false;

  bool isAllFetched = false;

  List<MonthHistoryDataModel<TempModel>> _monthWeekDataList = [];

  List<TempModel> get modelList => _modelList;

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

  set modelList(List<TempModel> value) {
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

  List<MonthHistoryDataModel<TempModel>> get monthWeekDataList =>
      _monthWeekDataList;

  set monthWeekDataList(List<MonthHistoryDataModel<TempModel>> value) {
    _monthWeekDataList = value;
  }

  Future<List<TempModel>> getHistoryData(context) async {
    var userId = preferences?.getString(Constants.prefUserIdKeyInt);
    var provider = Provider.of<TempHistoryProvider>(context, listen: false);
    var model = TempModel();
    model.temperature = 37;
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

    var data = await dbHelper.getTempTableData(userId!, strStart, strEnd, ids);
    if (data.isEmpty) {
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
      var dataList = await getTempDataFromDb(
        list: [],
        id: userId,
        strDate: DateFormat(DateUtil.yyyyMMdd).format(weekFirstDayDt),
        endDate: DateFormat(DateUtil.yyyyMMdd).format(weekLastDayDt.add(Duration(days: 1))),
      );
      monthWeekDataList.add(MonthHistoryDataModel<TempModel>(
          fieldName: DefaultGraphItem.temperature,
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

  Future<List<TempModel>> getTempDataFromDb(
      {required List<TempModel> list,
      String? id,
      String? strDate,
      String? endDate}) async {
    var ids = list.map((e) => (e.id ?? -1)).toList();
    var data = await dbHelper.getTempTableData(id!, strDate!, endDate!, ids);
    list.addAll(data);
    if (data != null && data.length == 20) {
      await getTempDataFromDb(
          list: list, id: id, strDate: strDate, endDate: endDate);
    }
    return Future.value(list);
  }

  reset() {
    _modelList = [];
    _monthWeekDataList = [];
    _isLoading = true;
    _isPageLoading = false;
  }
}
