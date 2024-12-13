import 'package:flutter/material.dart';
import 'package:health_gauge/models/bp_model.dart';
import 'package:health_gauge/screens/history/model/month_history_data_model.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_item_enum.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'blood_pressure_history_provider.dart';

class BloodPressureMonthDataProvider extends ChangeNotifier {
  List<BPModel> _modelList = [];
  bool _isLoading = true;
  bool _isPageLoading = false;

  bool _isAllFetched = false;

  List<MonthHistoryDataModel<BPModel>> _monthWeekDataList = [];

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

  bool get isAllFetched => _isAllFetched;

  set isAllFetched(bool value) {
    _isAllFetched = value;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
  }

  List<BPModel> get modelList => _modelList;

  set modelList(List<BPModel> value) {
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

  List<MonthHistoryDataModel<BPModel>> get monthWeekDataList =>
      _monthWeekDataList;

  set monthWeekDataList(List<MonthHistoryDataModel<BPModel>> value) {
    _monthWeekDataList = value;
  }

  Future<List<BPModel>> getHistoryData(context) async {
    var userId = preferences?.getString(Constants.prefUserIdKeyInt);
    var provider =
        Provider.of<BloodPressureHistoryProvider>(context, listen: false);
    modelList;
    if (isLoading) {
      modelList.clear();
    }

    var startDate =
        DateTime(provider.selectedDate.year, provider.selectedDate.month, 1);
    var endDate = DateTime(
        provider.selectedDate.year, provider.selectedDate.month + 1, 1);
    var strStart = DateFormat("yyyy-MM-dd").format(startDate);
    var strEnd = DateFormat("yyyy-MM-dd").format(endDate);
    var ids = modelList.map((e) => (e.id ?? -1)).toList();

    var data = await dbHelper.getBloodPressureTableData(
        userId!, strStart, strEnd, ids);
    await Future.delayed(Duration(seconds: 3)); // data = distinctList(data);
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
      var dataList = await getBPDataFromDb(
          list: [],
          id: userId,
          strDate: DateFormat('yyyy-MM-dd').format(weekFirstDayDt),
          endDate: DateFormat('yyyy-MM-dd').format(weekLastDayDt.add(Duration(days: 1))));
      monthWeekDataList.add(MonthHistoryDataModel<BPModel>(
          fieldName: DefaultGraphItem.bp,
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

  Future<List<BPModel>> getBPDataFromDb(
      {required List<BPModel> list,
      String? id,
      String? strDate,
      String? endDate}) async {
    var ids = list.map((e) => (e.id ?? -1)).toList();
    var data =
        await dbHelper.getBloodPressureTableData(id!, strDate!, endDate!, ids);
    list.addAll(data);
    if (data != null && data.length == 20) {
      await getBPDataFromDb(
          list: list, id: id, strDate: strDate, endDate: endDate);
    }
    return Future.value(list);
  }

  List<BPModel> distinctList(var dataList) {
    var distinctList = <BPModel>[];

    try {
      dataList.forEach((BPModel element) {
        if (element.date != null) {
          String date = DateFormat("yyyy-MM-dd hh:mm")
              .format(DateTime.parse(element.date!));
          bool isExist = distinctList.any((e) {
            if (e.date != null) {
              String dateE = DateFormat("yyyy-MM-dd hh:mm")
                  .format(DateTime.parse(e.date!));
              return date == dateE;
            }
            return false;
          });
          if (!isExist) {
            distinctList.add(element);
          }
        }
      });
    } catch (e) {
      print('Exception at distinct list in temp $e');
    }
    return distinctList;
  }

  reset() {
    _modelList = [];
    _isLoading = true;
    _isPageLoading = false;
  }
}
