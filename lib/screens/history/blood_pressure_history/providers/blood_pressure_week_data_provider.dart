import 'package:charts_flutter/flutter.dart' as chart;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/models/bp_model.dart';
import 'package:health_gauge/ui/graph_screen/graph_item_data.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_graph_data.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_item_enum.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_manager.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'blood_pressure_history_provider.dart';

class BloodPressureWeekDataProvider extends ChangeNotifier {
  List<BPModel> _modelList = [];
  bool _isLoading = true;
  bool _isPageLoading = false;

  bool _isAllFetched = false;

  List<GraphItemData> _bpList = [];
  List<GraphTypeModel> _graphTypeList = [];
  List<GraphTypeModel> _selectedGraphTypeList = [];
  List<chart.Series<GraphItemData, num>> _bpLineSeries = [];

  DateTime _startDate = DateTime.now();

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

  List<GraphTypeModel> get graphTypeList => _graphTypeList;

  List<GraphTypeModel> get selectedGraphTypeList => _selectedGraphTypeList;

  List<chart.Series<GraphItemData, num>> get bpLineSeries => _bpLineSeries;

  List<GraphItemData> get bpList => _bpList;

  DateTime get startDate => _startDate;

  Future<List<BPModel>> getHistoryData(context) async {
    var userId = preferences?.getString(Constants.prefUserIdKeyInt);
    var provider =
        Provider.of<BloodPressureHistoryProvider>(context, listen: false);

    if (isLoading) {
      modelList.clear();
    }

    var startDate = provider.firstDateOfWeek;
    var endDate = provider.lastDateOfWeek.add(Duration(days: 1));
    var strStart = DateFormat('yyyy-MM-dd').format(startDate);
    var strEnd = DateFormat('yyyy-MM-dd').format(endDate);
    var ids = modelList.map((e) => (e.id ?? -1)).toList();
    _startDate = DateTime(startDate.year, startDate.month, startDate.day);

    /*var data = await dbHelper.getBloodPressureTableData(userId!, strStart, strEnd, ids);
    await Future.delayed(Duration(seconds: 3));
    if(data.length == 0){
      isAllFetched = true;
    }else{
      isAllFetched = false;
    }

    modelList.addAll(data);*/

    await getBPDataFromDb(id: userId!, strDate: strStart, endDate: strEnd);

    await initializeData(
        _startDate, DateTime(endDate.year, endDate.month, endDate.day));

    isLoading = false;
    isPageLoading = false;
    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
    return Future.value(modelList);
  }

  Future<List<BPModel>> getBPDataFromDb(
      {String? id, String? strDate, String? endDate}) async {
    var ids = modelList.map((e) => (e.id ?? -1)).toList();
    var data =
        await dbHelper.getBloodPressureTableData(id!, strDate!, endDate!, ids);
    modelList.addAll(data);
    if (data != null && data.length == 20) {
      await getBPDataFromDb(id: id, strDate: strDate, endDate: endDate);
    }
    return Future.value(modelList);
  }

  Future<void> initializeData(DateTime startDate, DateTime endDate) async {
    if (modelList.isNotEmpty) {
      _graphTypeList =
          await dbHelper.getGraphTypeList(globalUser?.userId ?? '');
      if (_graphTypeList.isNotEmpty) {
        var model = _graphTypeList.firstWhereOrNull(
            (element) => element.fieldName == DefaultGraphItem.bp.fieldName);
        if (model != null) {
          _selectedGraphTypeList = [model];
        }
        if (_selectedGraphTypeList.isNotEmpty) {
          await getGraphData(startDate, endDate);
          _bpLineSeries = LineGraphData(
                  graphItemList: _bpList, graphList: _selectedGraphTypeList)
              .getLineGraphData();
        }
      }
    }
  }

  Future<void> getGraphData(DateTime startDate, DateTime endDate) async {
    var date = startDate;
    _bpList.clear();
    while (date.isBefore(endDate.add(Duration(days: 1)))) {
      _bpList.addAll(await GraphDataManager().graphManager(
          userId: globalUser?.userId ?? '',
          startDate: date,
          endDate: date.add(Duration(days: 1)),
          selectedGraphTypes: _selectedGraphTypeList,
          isEnableNormalize: false,
          unitType: 1));
      date = date.add(Duration(days: 1));
    }
    _bpList.removeWhere((element) => element.yValue == 0);
  }

  DateTime? getDate(String? date) {
    if (date != null) {
      if (DateTime.tryParse(date) != null) {
        return DateTime.parse(date);
      }
    }
  }

  List<chart.Series<GraphItemData, num>> getBPLineSeries(
      DateTime startDate, DateTime endDate) {
    List<GraphTypeModel> selectedGraphTypeList = getSelectedGraphTypeList();
    List<GraphItemData> bpList = getSpecificGraphData(startDate);
    return LineGraphData(
            graphItemList: bpList, graphList: selectedGraphTypeList)
        .getLineGraphData();
  }

  List<GraphTypeModel> getSelectedGraphTypeList() {
    return [
      _graphTypeList.firstWhere(
          (element) => element.fieldName == DefaultGraphItem.bp.fieldName)
    ];
  }

  int? findAvgBP(List<List<BPModel>> list, DateTime date) {
    int? avgBP;
    if (list.isNotEmpty) {
      for (var l in list) {
        if (l.isNotEmpty) {
          var date1 = getDate(l[0].date);
          if (date1 != null &&
              date1.year == date.year &&
              date1.month == date.month &&
              date1.day == date.day) {
            var count = 0;
            avgBP = 0;
            for (var element in l) {
              if (element.bloodDBP != null && element.bloodDBP != 0) {
                avgBP = avgBP! + element.bloodDBP!.toInt();
                count++;
              }
            }
            avgBP = avgBP! ~/ (count != 0 ? count : 1);
            break;
          }
        }
      }
    }
    return avgBP;
  }
  int? findAvgDBP(List<List<BPModel>> list, DateTime date) {
    int? avgBP;
    if (list.isNotEmpty) {
      for (var l in list) {
        if (l.isNotEmpty) {
          var date1 = getDate(l[0].date);
          if (date1 != null &&
              date1.year == date.year &&
              date1.month == date.month &&
              date1.day == date.day) {
            var count = 0;
            avgBP = 0;
            for (var element in l) {
              if (element.bloodDBP != null && element.bloodDBP != 0) {
                avgBP = avgBP! + element.bloodDBP!.toInt();
                count++;
              }
            }
            avgBP = avgBP! ~/ (count != 0 ? count : 1);
            break;
          }
        }
      }
    }
    return avgBP;
  }
  int? findAvgSBP(List<List<BPModel>> list, DateTime date) {
    int? avgBP;
    if (list.isNotEmpty) {
      for (var l in list) {
        if (l.isNotEmpty) {
          var date1 = getDate(l[0].date);
          if (date1 != null &&
              date1.year == date.year &&
              date1.month == date.month &&
              date1.day == date.day) {
            var count = 0;
            avgBP = 0;
            for (var element in l) {
              if (element.bloodSBP != null && element.bloodSBP != 0) {
                avgBP = avgBP! + element.bloodSBP!.toInt();
                count++;
              }
            }
            avgBP = avgBP! ~/ (count != 0 ? count : 1);
            break;
          }
        }
      }
    }
    return avgBP;
  }

  List<GraphItemData> getSpecificGraphData(DateTime date) {
    List<GraphItemData> bpList = [];
    for (var element in _bpList) {
      if (element.date != null && DateTime.tryParse(element.date!) != null) {
        var date1 = DateTime.parse(element.date!);
        if (date1.year == date.year &&
            date1.month == date.month &&
            date1.day == date.day) {
          bpList.add(element);
        }
      }
    }
    return bpList;
  }

  List<BPModel> distinctList(List<BPModel> dataList) {
    var distinctList = <BPModel>[];

    try {
      dataList.forEach((BPModel element) {
        if (element.date != null) {
          var date = DateFormat('yyyy-MM-dd hh:mm')
              .format(DateTime.parse(element.date!));
          var isExist = distinctList.any((e) {
            if (e.date != null) {
              var dateE = DateFormat('yyyy-MM-dd hh:mm')
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
