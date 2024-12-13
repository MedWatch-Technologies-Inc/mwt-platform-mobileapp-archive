import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/material.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/screens/history/temperature/providers/temp_history_provider.dart';
import 'package:health_gauge/ui/graph_screen/graph_item_data.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_graph_data.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_item_enum.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_manager.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TempWeekDataProvider extends ChangeNotifier {
  List<TempModel> _modelList = [];
  bool _isLoading = true;
  bool _isPageLoading = false;

  bool isAllFetched = false;

  List<GraphItemData> _tempList = [];
  List<GraphTypeModel> _graphTypeList = [];
  List<GraphTypeModel> _selectedGraphTypeList = [];
  List<chart.Series<GraphItemData, num>> _tempLineSeries = [];

  DateTime _startDate = DateTime.now();

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

  List<GraphTypeModel> get graphTypeList => _graphTypeList;

  List<GraphTypeModel> get selectedGraphTypeList => _selectedGraphTypeList;

  List<chart.Series<GraphItemData, num>> get tempLineSeries => _tempLineSeries;

  List<GraphItemData> get tempList => _tempList;

  DateTime get startDate => _startDate;

  Future<List<TempModel>> getHistoryData(context) async {
    var userId = preferences?.getString(Constants.prefUserIdKeyInt);
    var provider = Provider.of<TempHistoryProvider>(context, listen: false);
    var model = TempModel();
    model.temperature = 37;
    modelList;
    if (isLoading) {
      modelList.clear();
    }

    var startDate = provider.firstDateOfWeek;
    var endDate = provider.lastDateOfWeek.add(Duration(days: 1));
    var strStart = DateFormat(DateUtil.yyyyMMdd).format(startDate);
    var strEnd = DateFormat(DateUtil.yyyyMMdd).format(endDate);
    var ids = modelList.map((e) => (e.id ?? -1)).toList();
    _startDate = DateTime(startDate.year, startDate.month, startDate.day);

    /*var data = await dbHelper.getTempTableData(userId!, strStart, strEnd, ids);
    if (data.length == 0) {
      isAllFetched = true;
    } else {
      isAllFetched = false;
    }
    modelList.addAll(data);*/

    await getTempDataFromDb(id: userId!, strDate: strStart, endDate: strEnd);

    await initializeData(_startDate,DateTime(endDate.year, endDate.month, endDate.day));

    isLoading = false;
    isPageLoading = false;

    Future.delayed(Duration.zero).then((value) {
      notifyListeners();
    });
    return Future.value(modelList);
  }

  Future<List<TempModel>> getTempDataFromDb({String? id, String? strDate, String? endDate }) async{
    var ids = modelList.map((e) => (e.id ?? -1)).toList();
    var data = await dbHelper.getTempTableData(id!, strDate!, endDate!, ids);
    modelList.addAll(data);
    if(data != null && data.length == 20){
      await getTempDataFromDb(id: id,strDate: strDate,endDate: endDate);
    }
    return Future.value(modelList);
  }

  Future<void> initializeData(DateTime startDate, DateTime endDate) async {
    if(modelList.isNotEmpty) {
      _graphTypeList = await dbHelper.getGraphTypeList(globalUser?.userId ?? '');
      if (_graphTypeList.isNotEmpty) {
        _selectedGraphTypeList = [
          _graphTypeList.firstWhere(
                  (element) =>
              element.fieldName == DefaultGraphItem.temperature.fieldName)
        ];
        if (_selectedGraphTypeList.isNotEmpty) {
          await getGraphData(startDate,endDate);
          _tempLineSeries =
              LineGraphData(
                  graphItemList: _tempList, graphList: _selectedGraphTypeList)
                  .getLineGraphData();
        }
      }
    }
  }

  Future<void> getGraphData(DateTime startDate, DateTime endDate) async {
    var date = startDate;
    _tempList.clear();
    while(date.isBefore(endDate.add(Duration(days: 1)))) {
      _tempList.addAll( await GraphDataManager().graphManager(
          userId: globalUser?.userId ?? '',
          startDate: date,
          endDate: date.add(Duration(days: 1)),
          selectedGraphTypes: _selectedGraphTypeList,
          isEnableNormalize: false,
          unitType: 1));
      date = date.add(Duration(days: 1));
    }
    _tempList.removeWhere((element) => element.yValue == 0);
  }

  DateTime? getDate(String? date) {
    if (date != null) {
      if (DateTime.tryParse(date) != null) {
        return DateTime.parse(date);
      }
    }
  }

  List<chart.Series<GraphItemData, num>> getTempLineSeries(DateTime startDate,DateTime endDate)  {
    List<GraphTypeModel> selectedGraphTypeList = getSelectedGraphTypeList();
    List<GraphItemData> tempList = getSpecificGraphData(startDate);
    return  LineGraphData(
        graphItemList: tempList, graphList: selectedGraphTypeList)
        .getLineGraphData();
  }

  List<GraphTypeModel> getSelectedGraphTypeList() {
    return [
      _graphTypeList.firstWhere(
              (element) =>
          element.fieldName == DefaultGraphItem.temperature.fieldName)
    ];
  }

  int? findAvgTem(List<List<TempModel>> list,
      DateTime date) {
    int? avgTemp;
    if (list.isNotEmpty) {
      for (var l in list) {
        if (l.isNotEmpty) {
          var date1 = getDate(l[0].date);
          if (date1 != null && date1.year == date.year
              && date1.month == date.month && date1.day == date.day) {
            var count = 0;
            avgTemp = 0;
            for (var element in l) {
              if (element.temperature != null && element.temperature != 0) {
                avgTemp = avgTemp! + element.temperature!.toInt();
                count++;
              }
            }
            avgTemp = avgTemp! ~/ (count != 0 ? count : 1);
            break;
          }
        }
      }
    }
    return avgTemp;
  }

  List<GraphItemData> getSpecificGraphData(DateTime date) {
    List<GraphItemData> tempList = [];
    for (var element in _tempList) {
      if(element.date != null && DateTime.tryParse(element.date!) != null) {
        var date1 = DateTime.parse(element.date!);
        if(date1.year == date.year && date1.month == date.month && date1.day == date.day) {
          tempList.add(element);
        }
      }
    }
    return tempList;
  }

  List<TempModel> distinctList(var dataList) {
    var distinctList = <TempModel>[];

    try {
      dataList.forEach((TempModel element) {
        if (element.date != null) {
          String date = DateFormat(DateUtil.yyyyMMddhhmm)
              .format(DateTime.parse(element.date!));
          bool isExist = distinctList.any((e) {
            if (e.date != null) {
              String dateE = DateFormat(DateUtil.yyyyMMddhhmm)
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
